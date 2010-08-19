<div class="span-24 last">
	<h2>Sessions</h2>
	
	<h3>Application Information</h3>
	<cfoutput>
		<table class="styled">
			<thead>
				<tr>
					<th scope="col" colspan="2">#HtmlEditFormat(rc.name)#</th>
				</tr>
			</thead>
			<tbody>
				<cfif application.cftracker.support.apps.data.expired><tr>
					<th scope="row">Expired</th>
					<td>#HtmlEditFormat(rc.appInfo.expired)#</td>
				</tr></cfif>
				<cfif application.cftracker.support.apps.data.lastAccessed><tr>
					<th scope="row">Last Accessed</th>
					<td>#LsDateFormat(rc.appInfo.lastAccessed, application.settings.display.dateformat)# #LsTimeFormat(rc.appInfo.lastAccessed, application.settings.display.timeformat)#</td>
				</tr></cfif>
				<cfif application.cftracker.support.apps.data.idleTimeout><tr>
					<th scope="row">Expiry date</th>
					<td>#LsDateFormat(rc.appInfo.idleTimeout, application.settings.display.dateformat)# #LsTimeFormat(rc.appInfo.idleTimeout, application.settings.display.timeformat)#</td>
				</tr></cfif>
				<cfif application.cftracker.support.apps.data.idleTimeout><tr>
					<th scope="row">Expiry progress bar</th>
					<td><div class="progress" title="#rc.appInfo.idlePercent#"></div></td>
				</tr></cfif>
				<cfif application.cftracker.support.apps.data.timeAlive><tr>
					<th scope="row">Created</th>
					<td>#LsDateFormat(rc.appInfo.timeAlive, application.settings.display.dateformat)# #LsTimeFormat(rc.appInfo.timeAlive, application.settings.display.timeformat)#</td>
				</tr></cfif>
				<cfif application.cftracker.support.apps.data.isinited><tr>
					<th scope="row">Is Initialised?</th>
					<td>#HtmlEditFormat(rc.appInfo.isInited)#</td>
				</tr></cfif>
			</tbody>
		</table>
		#View('sessions/default')#
	</cfoutput>