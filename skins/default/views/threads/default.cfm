<cfsilent>
	<cfsavecontent variable="js">
		<script type="text/javascript">
			var table = {
				sort: [[1, 'asc']],
				cols: [
					{bSortable: false},
					null,
					null,
					null,
					{bVisible: false},
					{bVisible: false},
					{bVisible: false},
					{bVisible: false},
					{bVisible: false},
					{bVisible: false},
					{bVisible: false},
					{bVisible: false},
					{bVisible: false},
					{bVisible: false}
				]
			};
			$(function() {
				$('#goApp').button({
					icons: {
						primary: 'ui-icon-search'
					}
				}).click(function(e) {
					e.preventDefault();
					app = $('#apps').val();
					window.location.href = app;
				});
			});
		</script>
		<script type="text/javascript" src="assets/js/datatable.js"></script>
	</cfsavecontent>
	<cfhtmlhead text="#js#" />
</cfsilent>

<div class="span-24 last">
	<h2>Threads</h2>


<div id="displayCols" title="Table columns">
<p>Please select the table columns you would like displayed.</p>
<ul>
	<li><label for="col4"><input type="checkbox" name="display" value="4" id="col4" /> Priority</label></li>
	<li><label for="col5"><input type="checkbox" name="display" value="5" id="col5" /> State</label></li>
	<li><label for="col6"><input type="checkbox" name="display" value="6" id="col6" /> Alive</label></li>
	<li><label for="col7"><input type="checkbox" name="display" value="7" id="col7" /> Daemon</label></li>
	<li><label for="col8"><input type="checkbox" name="display" value="8" id="col8" /> Interrupted</label></li>
	<li><label for="col9"><input type="checkbox" name="display" value="9" id="col9" /> Current Time</label></li>
	<li><label for="col10"><input type="checkbox" name="display" value="10" id="col10" /> Shutdown</label></li>
	<li><label for="col11"><input type="checkbox" name="display" value="11" id="col11" /> Start Time</label></li>
	<li><label for="col12"><input type="checkbox" name="display" value="12" id="col12" /> Method Timing</label></li>
	<li><label for="col13"><input type="checkbox" name="display" value="13" id="col13" /> File</label></li>
</ul>
</div>

<button id="selectCols"> Select columns</button>

<cfoutput>
<table class="display dataTable">
	<thead>
		<tr>
			<th scope="col"></th>
			<th scope="col">ID</th>
			<th scope="col">Name</th>
			<th scope="col">Group</th>
			<th scope="col">Priority</th>
			<th scope="col">State</th>
			<th scope="col">Alive</th>
			<th scope="col">Daemon</th>
			<th scope="col">Interrupted</th>
			<th scope="col">Current Time</th>
			<th scope="col">Shutdown</th>
			<th scope="col">Start Time</th>
			<th scope="col">Method Timing</th>
			<th scope="col">File</th>
		</tr>
	</thead>
	<tfoot> 
		<tr> 
			<th></th>
			<th><input type="text" /></th>
			<th><input type="text" /></th>
			<th><select class="build"></select></th>
			<th><select class="build"></select></th>
			<th><select class="build"></select></th>
			<th><select class="build"></select></th>
			<th><select class="build"></select></th>
			<th><select class="build"></select></th>
			<th></th>
			<th><select class="build"></select></th>
			<th></th>
			<th><select class="build"></select></th>
			<th><input type="text" /></th>
		</tr> 
	</tfoot> 
	<tbody><cfloop array="#rc.data#" index="thread">
		<tr>
			<td></td>
			<td>#HtmlEditFormat(thread.id)#</td>
			<td>#HtmlEditFormat(thread.name)#</td>
			<td>#HtmlEditFormat(thread.group)#</td>
			<td>#HtmlEditFormat(thread.priority)#</td>
			<td>#HtmlEditFormat(thread.state)#</td>
			<td>#HtmlEditFormat(thread.isAlive)#</td>
			<td>#HtmlEditFormat(thread.isDaemon)#</td>
			<td>#HtmlEditFormat(thread.isInterrupted)#</td>
			<td>#HtmlEditFormat(thread.currentTimeMillis)#</td>
			<td>#HtmlEditFormat(thread.isShutdown)#</td>
			<td>#HtmlEditFormat(thread.startTime)#</td>
			<td>#HtmlEditFormat(thread.methodTiming)#</td>
			<td>#HtmlEditFormat(thread.file)#</td>
		</tr>
	</cfloop></tbody>
</table>
</cfoutput>
