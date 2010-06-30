<cfsilent>
	<cfsavecontent variable="js">
		<script type="text/javascript">
			var table = {
				sort: [[1, 'asc']],
				cols: [
					{bSortable: false},
					null,
					{bSortable: false},
					{bVisible: false},
					{bVisible: false},
					{bVisible: false},
					{bVisible: false},
					{bVisible: false}
				]
			};
		</script>
		<script type="text/javascript" src="assets/js/datatable.js"></script>
	</cfsavecontent>
	<cfhtmlhead text="#js#" />
</cfsilent>
<div class="span-24 last">
<h2>Applications</h2>

<div id="displayCols" title="Table columns">
<p>Please select the table columns you would like displayed.</p>
<ul>
	<li><label for="col3"><input type="checkbox" name="display" value="3" id="col3" /> Expired</label></li>
	<li><label for="col4"><input type="checkbox" name="display" value="4" id="col4" /> Last accessed</label></li>
	<li><label for="col5"><input type="checkbox" name="display" value="5" id="col5" /> Application Timeout</label></li>
	<li><label for="col6"><input type="checkbox" name="display" value="6" id="col6" /> First initialised</label></li>
	<li><label for="col7"><input type="checkbox" name="display" value="7" id="col7" /> Initialised?</label></li>
</ul>
</div>

<button id="selectCols"> Select columns</button>
<cfoutput>
<form action="" method="post">
	<input type="hidden" name="action" value="" />
<table class="display dataTable">
	<thead>
		<tr>
			<th scope="col"></th>
			<th scope="col">Name</th>
			<th scope="col">View</th>
			<th scope="col">Expired</th>
			<th scope="col">Last accessed</th>
			<th scope="col">App Timeout</th>
			<th scope="col">First Init</th>
			<th scope="col">Inited?</th>
		</tr>
	</thead>
	<tfoot> 
		<tr> 
			<th></th>
			<th><input type="text" name="search_app" value="" /></th> 
			<th></th>
			<th><select>
				<option value=""></option>
				<option value="YES">Yes</option>
				<option value="NO">No</option>
			</select></th> 
			<th></th>
			<th></th>
			<th></th>
			<th><select>
				<option value=""></option>
				<option value="YES">Yes</option>
				<option value="NO">No</option>
			</select></th>
		</tr> 
	</tfoot> 
	<tbody><cfloop collection="#rc.data#" item="app">
		<tr>
			<td><input type="checkbox" name="apps" value="#HtmlEditFormat(app)#" /></td>
			<td>#HtmlEditFormat(app)#</td>
			<td><a href="#BuildURL('sessions.application?name=' & app)#" class="button" alt="person">#rc.data[app].sessionCount#</a>
			<br />
				<a alt="zoomin" title="View the application scope for this app." class="button detail" href="#BuildUrl('applications.getscope?name=' & app)#">&nbsp;</a>
				<a alt="wrench" title="View the settings for this application." class="button detail" href="#BuildUrl('applications.getsettings?name=' & app)#">&nbsp;</a>
			</td>
			<td>#HtmlEditFormat(rc.data[app].expired)#</td>
			<td>#LsDateFormat(rc.data[app].lastAccessed)#<br />#LsTimeFormat(rc.data[app].lastAccessed)#</td>
			<td>#LsDateFormat(rc.data[app].idleTimeout)#<br />#LsTimeFormat(rc.data[app].idleTimeout)#</td>
			<td>#LsDateFormat(rc.data[app].timeAlive)#<br />#LsTimeFormat(rc.data[app].timeAlive)#</td>
			<td>#rc.data[app].isinited#</td>
		</tr>
	</cfloop></tbody>
</table>
<div class="actions">
	<button class="ui-icon-stop" value="applications.stop">Stop</button>
	<button class="ui-icon-seek-first" value="applications.restart">Restart</button>
	<button class="ui-icon-refresh" value="applications.refresh">Refresh</button>
</div>
</form>
</cfoutput>
</div>