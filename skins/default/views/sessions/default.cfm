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

<cfif Not StructKeyExists(rc, 'name')>
<div class="span-24 last">
	<h2>Sessions</h2>
</cfif>

<cfoutput>
<h3>Filter by application</h3>
<select id="apps">
	<option value="#BuildUrl('sessions.default')#">-All Applications-</option>
	<cfloop array="#rc.apps#" index="app">
		<option value="#BuildUrl('sessions.application?name=' & app)#" <cfif StructKeyExists(rc, 'name') And rc.name Eq app>selected="selected"</cfif>>#HtmlEditFormat(app)#</option>
	</cfloop>
</select>
<button id="goApp">Go</button>
</cfoutput>


<h3>Sessions</h3>

<div id="displayCols" title="Table columns">
<p>Please select the table columns you would like displayed.</p>
<ul>
	<li><label for="col3"><input type="checkbox" name="display" value="3" id="col3" /> Expired</label></li>
	<li><label for="col4"><input type="checkbox" name="display" value="4" id="col4" /> Accessed</label></li>
	<li><label for="col5"><input type="checkbox" name="display" value="5" id="col5" /> Timeout</label></li>
	<li><label for="col6"><input type="checkbox" name="display" value="6" id="col6" /> Created</label></li>
	<li><label for="col7"><input type="checkbox" name="display" value="7" id="col7" /> Type</label></li>
	<li><label for="col8"><input type="checkbox" name="display" value="8" id="col8" /> Client IP</label></li>
	<li><label for="col9"><input type="checkbox" name="display" value="9" id="col9" /> ID from URL</label></li>
</ul>
</div>

<button id="selectCols"> Select columns</button>

<cfoutput>
<form action="" method="post">
	<cfif StructKeyExists(rc, 'name')>
		<input type="hidden" name="app" value="#HtmlEditFormat(rc.name)#" />
	</cfif>
	<input type="hidden" name="action" value="" />
<table class="display dataTable">
	<thead>
		<tr>
			<th scope="col"></th>
			<th scope="col">ID</th>
			<th scope="col">View</th>
			<th scope="col">Expired</th>
			<th scope="col">Accessed</th>
			<th scope="col">Timeout</th>
			<th scope="col">Created</th>
			<th scope="col">Type</th>
			<th scope="col">Client IP</th>
			<th scope="col">ID From URL</th>
		</tr>
	</thead>
	<tfoot> 
		<tr> 
			<th></th>
			<th><input type="text" value="" /></th> 
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
				<option value="CF">CF</option>
				<option value="J2ee">J2ee</option>
			</select></th>
			<th><input type="text" value="" /></th>
			<th><select>
				<option value=""></option>
				<option value="YES">Yes</option>
				<option value="NO">No</option>
			</select></th>
		</tr> 
	</tfoot> 
	<tbody><cfloop collection="#rc.data#" item="sess">
	<tr>
			<cfif rc.data[sess].exists>
				<td><input type="checkbox" name="sessions" value="#HtmlEditFormat(sess)#" /></td>
				<td>#HtmlEditFormat(sess)#</td>
				<td><a alt="zoomin" title="View the session scope." class="button detail" href="#BuildUrl('sessions.getscope?name=' & sess)#">&nbsp;</a></td>
				<td>#HtmlEditFormat(rc.data[sess].expired)#</td>
				<td>#LsDateFormat(rc.data[sess].lastAccessed, application.settings.display.dateformat)#<br />#LsTimeFormat(rc.data[sess].lastAccessed, application.settings.display.timeformat)#</td>
				<td>#LsDateFormat(rc.data[sess].idleTimeout, application.settings.display.dateformat)#<br />#LsTimeFormat(rc.data[sess].idleTimeout, application.settings.display.timeformat)#</td>
				<td>#LsDateFormat(rc.data[sess].timeAlive, application.settings.display.dateformat)#<br />#LsTimeFormat(rc.data[sess].timeAlive, application.settings.display.timeformat)#</td>
				<td><cfif rc.data[sess].isJ2eeSession>J2ee<cfelse>CF</cfif></td>
				<td>#HtmlEditFormat(rc.data[sess].clientIp)#</td>
				<td>#HtmlEditFormat(rc.data[sess].idFromUrl)#</td>
			<cfelse>
				<td></td>
				<td>#HtmlEditFormat(sess)#</td>
				<td colspan="8">No longer exists</td>
			</cfif>
		</tr>
	</cfloop></tbody>
</table>
<div class="actions">
	<button class="ui-icon-stop" value="sessions.stop">Stop</button>
	<button class="ui-icon-refresh" value="sessions.refresh">Refresh</button>
</div>
</form>
</cfoutput>

<hr />
<h3>Action <cfif StructKeyExists(rc, 'name')>application<cfelse>all</cfif> sessions by:</h3>
<cfoutput>
<form action="" method="post">
	<input type="hidden" name="action" value="" />
	<fieldset>
		<legend>Filters</legend>
		<p><label for="id">ID (regex)</label><br />
		<input type="text" name="id" id="id" /></p>
		<p><label for="expired">Expired</label><br />
		<select name="expired" id="expired"><option value=""></option><option value="YES">Yes</option><option value="NO">No</option></select></p>
		<p><label for="lastaccessed">Last accessed</label><br />
		<select name="lastaccessedOp">
			<option value="before">Before</option>
			<option value="on">On</option>
			<option value="after">After</option>
		</select>
		<input type="text" name="lastaccessedOp" id="lastaccessedOp" /></p>
		<p><label for="timeout">Timeout</label><br />
		<select name="timeoutOp">
			<option value="before">Before</option>
			<option value="on">On</option>
			<option value="after">After</option>
		</select>
		<input type="text" name="timeout" id="timeout" /></p>
		<p><label for="created">Created</label><br />
		<select name="createdOp">
			<option value="before">Before</option>
			<option value="on">On</option>
			<option value="after">After</option>
		</select>
		<input type="text" name="created" id="created" /></p>
		<p><label for="clientIp">Client IP (regex)</label><br />
		<input type="text" name="clientIp" id="clientIp" /></p>
		<p><label for="idFromUrl">ID from URL</label><br />
		<select name="idFromUrl" id="idFromUrl"><option value=""></option><option value="YES">Yes</option><option value="NO">No</option></select></p>
	</fieldset>
	<div class="actions">
		<button class="ui-icon-stop" value="sessions.stopby">Purge</button>
		<button class="ui-icon-refresh" value="queries.refreshby">Refresh</button>
	</div>
</form>
</cfoutput>
</div>