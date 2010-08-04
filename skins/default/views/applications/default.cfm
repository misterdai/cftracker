<cfsilent>
	<cfsavecontent variable="js">
		<script type="text/javascript">
			var table = {
				sort: [[2, 'asc']],
				cols: [
					{bSortable: false},
					null,
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
	<li><label for="col4"><input type="checkbox" name="display" value="4" id="col4" /> Expired</label></li>
	<li><label for="col5"><input type="checkbox" name="display" value="5" id="col5" /> Last accessed</label></li>
	<li><label for="col6"><input type="checkbox" name="display" value="6" id="col6" /> Application Timeout</label></li>
	<li><label for="col7"><input type="checkbox" name="display" value="7" id="col7" /> First initialised</label></li>
	<li><label for="col8"><input type="checkbox" name="display" value="8" id="col8" /> Initialised?</label></li>
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
			<th scope="col">Context</th>
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
	<cfset num = 1 />
	<tbody><cfloop collection="#rc.data#" item="wc">
		<cfloop collection="#rc.data[wc]#" item="app">
		<tr>
			<td><input type="checkbox" name="app_#num#" value="#HtmlEditFormat(wc)#,#HtmlEditFormat(app)#" /></td>
			<td>#HtmlEditFormat(wc)#</td>
			<td>#HtmlEditFormat(app)#</td>
			<td><cfif StructKeyExists(rc.data[wc][app], 'sessionCount')><a href="#BuildURL('sessions.application?name=' & app & '&wc=' & wc)#" class="button" alt="person">#rc.data[wc][app].sessionCount#</a><br /></cfif>
				<a alt="zoomin" title="View the application scope for this app." class="button detail" href="#BuildUrl('applications.getscope?name=' & app & '&wc=' & wc)#">&nbsp;</a>
				<cfif application.server Eq 'ColdFusion'><a alt="wrench" title="View the settings for this application." class="button detail" href="#BuildUrl('applications.getsettings?name=' & app & '&wc=' & wc)#">&nbsp;</a></cfif>
			</td>
			<td>#HtmlEditFormat(rc.data[wc][app].expired)#</td>
			<td>#LsDateFormat(rc.data[wc][app].lastAccessed, application.settings.display.dateformat)#<br />#LsTimeFormat(rc.data[wc][app].lastAccessed, application.settings.display.timeformat)#</td>
			<td>#LsDateFormat(rc.data[wc][app].idleTimeout, application.settings.display.dateformat)#<br />#LsTimeFormat(rc.data[wc][app].idleTimeout, application.settings.display.timeformat)#</td>
			<td><cfif StructKeyExists(rc.data[wc][app], 'timeAlive')>#LsDateFormat(rc.data[wc][app].timeAlive, application.settings.display.dateformat)#<br />#LsTimeFormat(rc.data[wc][app].timeAlive, application.settings.display.timeformat)#</cfif></td>
			<td><cfif StructKeyExists(rc.data[wc][app], 'isinited')>#rc.data[wc][app].isinited#</cfif></td>
		</tr>
		<cfset num++ />
		</cfloop>
	</cfloop></tbody>
</table>
<div class="actions">
	<button class="ui-icon-stop" value="applications.stop">Stop App only</button>
	<cfif application.server Eq 'ColdFusion'>
		<button class="ui-icon-stop" value="applications.stopsessions">Stop Sessions only</button>
		<button class="ui-icon-stop" value="applications.stopboth">Stop App &amp; Sessions</button>
		<button class="ui-icon-seek-first" value="applications.restart">Restart</button>
	</cfif>
	<button class="ui-icon-refresh" value="applications.refresh">Refresh</button>
</div>
</form>
</cfoutput>
</div>