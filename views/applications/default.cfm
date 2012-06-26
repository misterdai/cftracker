<script type="text/javascript">
	var table = {
		sort: [[2, 'asc']],
		cols: [
			{bSortable: false},
			null,
			null,
			{bSortable: false}
			<cfscript>
				if (application.cftracker.support.apps.data.expired) {
					WriteOutput(',{bSortable: false}');
				}
				if (application.cftracker.support.apps.data.lastAccessed) {
					WriteOutput(',{bSortable: false}');
				}
				if (application.cftracker.support.apps.data.idleTimeout) {
					WriteOutput(',{bSortable: false}');
				}
				if (application.cftracker.support.apps.data.timeAlive) {
					WriteOutput(',{bSortable: false}');
				}
				if (application.cftracker.support.apps.data.isinited) {
					WriteOutput(',{bSortable: false}');
				}
			</cfscript>
		]
	};
</script>
<cfoutput><script type="text/javascript" src="#this.assetBegin#assets/js/datatable.js#this.assetEnd#"></script></cfoutput>
<div class="span-24 last">
<h2>Applications</h2>

<div id="displayCols" title="Table columns">3</div>

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
			<cfif application.cftracker.support.apps.data.expired><th scope="col">Expired</th></cfif>
			<cfif application.cftracker.support.apps.data.lastAccessed><th scope="col">Last accessed</th></cfif>
			<cfif application.cftracker.support.apps.data.idleTimeout><th scope="col">App Timeout</th></cfif>
			<cfif application.cftracker.support.apps.data.timeAlive><th scope="col">First Init</th></cfif>
			<cfif application.cftracker.support.apps.data.isinited><th scope="col">Inited?</th></cfif>
		</tr>
	</thead>
	<tfoot>
		<tr>
			<th></th>
			<th></th>
			<th><input type="text" name="search_app" value="" /></th> 
			<th></th>
			<cfif application.cftracker.support.apps.data.expired><th><select>
				<option value=""></option>
				<option value="YES">Yes</option>
				<option value="NO">No</option>
			</select></th></cfif>
			<cfif application.cftracker.support.apps.data.lastAccessed><th></th></cfif>
			<cfif application.cftracker.support.apps.data.idleTimeout><th></th></cfif>
			<cfif application.cftracker.support.apps.data.timeAlive><th></th></cfif>
			<cfif application.cftracker.support.apps.data.isinited><th><select>
				<option value=""></option>
				<option value="YES">Yes</option>
				<option value="NO">No</option>
			</select></th></cfif>
		</tr> 
	</tfoot>
	<cfset num = 1 />
	<tbody><cfloop collection="#rc.data#" item="wc">
		<cfloop collection="#rc.data[wc]#" item="app">
		<tr>
			<td><input type="checkbox" name="app_#num#" value="#HtmlEditFormat(wc)##Chr(9)##HtmlEditFormat(app)#" /></td>
			<td>#HtmlEditFormat(wc)#</td>
			<td>#HtmlEditFormat(app)#</td>
			<td><cfif application.cftracker.support.apps.data.sessionCount><a href="#BuildURL('sessions.application?name=' & UrlEncodedFormat(app) & '&wc=' & UrlEncodedFormat(wc))#" class="button" alt="person">#rc.data[wc][app].sessionCount#</a><br /></cfif>
				<cfif application.cftracker.support.apps.data.scope><a alt="zoomin" title="View the application scope for this app." class="button detail" href="#BuildUrl('applications.getscope?name=' & UrlEncodedFormat(app) & '&wc=' & UrlEncodedFormat(wc))#">&nbsp;</a></cfif>
				<cfif application.cftracker.support.apps.data.settings><a alt="wrench" title="View the settings for this application." class="button detail" href="#BuildUrl('applications.getsettings?name=' & UrlEncodedFormat(app) & '&wc=' & UrlEncodedFormat(wc))#">&nbsp;</a></cfif>
			</td>
			<cfif application.cftracker.support.apps.data.expired>
				<td>#HtmlEditFormat(rc.data[wc][app].expired)#</td>
			</cfif>
			<cfif application.cftracker.support.apps.data.lastAccessed>
				<td>#LsDateFormat(rc.data[wc][app].lastAccessed, application.settings.display.dateformat)#<br />#LsTimeFormat(rc.data[wc][app].lastAccessed, application.settings.display.timeformat)#</td>
			</cfif>
			<cfif application.cftracker.support.apps.data.idleTimeout>
				<td>#LsDateFormat(rc.data[wc][app].idleTimeout, application.settings.display.dateformat)#<br />#LsTimeFormat(rc.data[wc][app].idleTimeout, application.settings.display.timeformat)#</td>
			</cfif>
			<cfif application.cftracker.support.apps.data.timeAlive><td>#LsDateFormat(rc.data[wc][app].timeAlive, application.settings.display.dateformat)#<br />#LsTimeFormat(rc.data[wc][app].timeAlive, application.settings.display.timeformat)#</td></cfif>
			<cfif application.cftracker.support.apps.data.isinited><td>#rc.data[wc][app].isinited#</td></cfif>
		</tr>
		<cfset num++ />
		</cfloop>
	</cfloop></tbody>
</table>
<div class="actions">
	<cfif application.cftracker.support.apps.actions.stop><button class="ui-icon-stop" value="applications.stop">Stop App only</button></cfif>
	<cfif application.cftracker.support.apps.actions.stopSessions><button class="ui-icon-stop" value="applications.stopsessions">Stop Sessions only</button></cfif>
	<cfif application.cftracker.support.apps.actions.stopBoth><button class="ui-icon-stop" value="applications.stopboth">Stop App &amp; Sessions</button></cfif>
	<cfif application.cftracker.support.apps.actions.restart><button class="ui-icon-seek-first" value="applications.restart">Restart</button></cfif>
	<cfif application.cftracker.support.apps.actions.refresh><button class="ui-icon-refresh" value="applications.refresh">Refresh</button></cfif>
</div>
</form>
</cfoutput>
</div>