<cfsilent>
	<cfsavecontent variable="js">
		<script type="text/javascript">
			var table = {
				sort: [[1, 'asc']],
				cols: [
					{bSortable: false},
					null,
					{bSortable: false},
					null,
					null,
					null
				]
			};
		</script>
		<script type="text/javascript" src="assets/js/datatable.js"></script>
	</cfsavecontent>
	<cfhtmlhead text="#js#" />
	
</cfsilent>
<div class="span-24 last">

<h2>Query Cache</h2>

<div id="displayCols" title="Table columns">
<p>Please select the table columns you would like displayed.</p>
<ul>
	<li><label for="col3"><input type="checkbox" name="display" value="3" id="col3" /> Query Name</label></li>
	<li><label for="col5"><input type="checkbox" name="display" value="4" id="col4" /> Creation Date</label></li>
	<li><label for="col6"><input type="checkbox" name="display" value="5" id="col5" /> SQL</label></li>
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
			<th scope="col">Hash Code</th>
			<th scope="col">View</th>
			<th scope="col">QueryName</th>
			<th scope="col">Creation</th>
			<th scope="col">SQL</th>
		</tr>
	</thead>
	<tfoot> 
		<tr> 
			<th></th>
			<th></th>
			<th></th>
			<th><input type="text" /></th>
			<th></th>
			<th><input type="text" /></th>
		</tr> 
	</tfoot> 
	<tbody><cfloop collection="#rc.data#" item="query">
		<tr>
			<td><input type="checkbox" name="queries" value="#HtmlEditFormat(query)#" /></td>
			<td>#HtmlEditFormat(query)#</td>
			<td><a alt="zoomin" title="View the result set for this query." class="button detail" href="#BuildUrl('queries.getresult?name=' & query)#">&nbsp;</a>
				<a alt="wrench" title="View the parameters for this query." class="button detail" href="#BuildUrl('queries.getparams?name=' & query)#">#ArrayLen(rc.data[query].params)#</a>
			</td>
			<td>#HtmlEditFormat(rc.data[query].queryName)#</td>
			<td>#LsDateFormat(rc.data[query].creation, application.settings.display.dateformat)#<br />#LsTimeFormat(rc.data[query].creation, application.settings.display.timeformat)#</td>
			<td>#HtmlEditFormat(rc.data[query].sql)#</td>
		</tr>
	</cfloop></tbody>
</table>
<div class="actions">
	<button class="ui-icon-stop" value="queries.purge">Purge</button>
	<button class="ui-icon-refresh" value="queries.refresh">Reset creation time</button>
</div>
</form>
</cfoutput>
<hr />
<h3>Action all queries by:</h3>
<cfoutput>
<form action="" method="post">
	<input type="hidden" name="action" value="" />
	<fieldset>
		<legend>Filters</legend>
		<p><label for="sql">SQL (regex)</label><br />
		<input type="text" name="sql" id="sql" /></p>
		<p><label for="name">Query name (regex)</label><br />
		<input type="text" name="name" id="name" /></p>
		<p><label for="creation">Creation date</label><br />
		<select name="creationOp">
			<option value="before">Before</option>
			<option value="on">On</option>
			<option value="after">After</option>
		</select>
		<input type="text" name="creation" id="creation" /></p>
	</fieldset>
	<div class="actions">
		<button class="ui-icon-stop" value="queries.purgeby">Purge</button>
		<button class="ui-icon-refresh" value="queries.refreshby">Reset creation time</button>
	</div>
</form>
</cfoutput>

</div>