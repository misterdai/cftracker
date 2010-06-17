<cfinclude template="config.cfm" />
<cfinclude template="../header.cfm" />
<cfinclude template="myHeader.cfm" />
<cfsilent>
	<!--- Function for lazy retrieval of url / form variables --->
	<cffunction name="getVal" output="false" returntype="any">
		<cfargument name="scope" required="true" />
		<cfargument name="key" type="string" required="true" />
		<cfif StructKeyExists(arguments.scope, arguments.key)>
			<cfreturn arguments.scope[arguments.key] />
		<cfelse>
			<cfreturn '' />
		</cfif>
	</cffunction>

	<cfparam name="url.app" type="string" default="" />
	<cfparam name="form.app" type="string" default="" />
	<cfparam name="url.error" type="string" default="" />
	<cfscript>
		if (Len(url.app) Eq 0) {
			url.app = form.app;
		}
		
		cfcTracker = CreateObject('component', 'tracker').init();

		apps = cfcTracker.getApplications();

		refreshingApps = {};
		restartingApps = {};
		if (cgi.request_method Eq 'post') {
			for (field in form) {
				if (ListFirst(field, '_') Eq 'app' And Len(field) Gt 4) {
					appName = form[field];
					appScope = cfcTracker.getApplication(appName);
					if (IsDefined('variables.appScope')) {
						if (StructKeyExists(form, 'action') && form.action Eq 'stop') {
							cfcTracker.applicationStop(appName);
						} else if (StructKeyExists(form, 'action') && form.action Eq 'restart') {
							cfcTracker.applicationRestart(appName);
							restartingApps[appName] = true;
						} else {
							appScope.setLastAccess();
							refreshingApps[appName] = true;
						}
					}
				}
			}
		}
	</cfscript>
</cfsilent>
<script type="text/javascript" src="js/cftracker.js?v=2"></script>
<br />
<cfif url.error Eq 1>
	<div class="ui-widget">
		<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;"> 
			<p><span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span> 
			<strong>Alert:</strong> Application does not exist.</p>
		</div>
	</div>
</cfif>


<h2 class="pageHeader">CFTracker > Applications &amp; Sessions</h2>
<cfoutput><a href="index.cfm?app=#HtmlEditFormat(url.app)#" class="button" alt="refresh" title="Refresh the page, keeping the currently selected application.  This is useful for avoiding extra post requests.">Refresh page</a></cfoutput>

<p>Please hover over the column headers and buttons for help and further information.</p>

<h3 class="cellBlueTopAndBottom pageSection">Applications</h3>
<ul>
	<li>Large scopes can take time to duplicate and dump due to the need to avoid updating the "last accessed" time.</li>
	<li>The "Is Initialised" flag tells the application if it has run onApplicationStart.</li>
</ul>

<cfoutput>
	<form action="index.cfm?app=#HtmlEditFormat(url.app)#" method="post">
		<input type="hidden" name="action" value="" />
	<table class="styled"> 
		<thead>
			<tr>
				<th class="cellBlueTopAndBottom" scope="col" title="Use the boxes below to select which applications you'd like to perform an action against."></th>
				<th class="cellBlueTopAndBottom" scope="col" title="Name of the Application.">Application</th>
				<th class="cellBlueTopAndBottom" scope="col" title="View application information.">View</th>
				<th class="cellBlueTopAndBottom" scope="col" title="When the application has timed out, it is marked as expired and the garbage collection process will remove it.">Expired</th>
				<th class="cellBlueTopAndBottom" scope="col" title="Date and time that the application was last accessed.">Last accessed</th>
				<th class="cellBlueTopAndBottom" scope="col" title="Date and time that the application would timeout, if there was no further activity.">App Timeout</th>
				<th class="cellBlueTopAndBottom" scope="col" title="Date and time that the application was started.">First Init</th>
				<th class="cellBlueTopAndBottom" scope="col" title="Has the application initialised and onApplicationStart executed.">Inited?</th>
			</tr>
		</thead>
		<tbody>
			<cfif ArrayLen(apps) Eq 0>
				<td class="cell4BlueSides" colspan="7">No applications found</td>
			</cfif>
			<cfloop array="#apps#" index="appName">
				<cfscript>
					class = '';
					appInfo = cfcTracker.getAppInfo(appName);
					if (appInfo.appExists) {
						accessDate = DateAdd('s', -appInfo.lastAccessed / 1000, Now());
						timeoutDate = DateAdd('s', appInfo.idleTimeout / 1000, accessDate);
						startDate = DateAdd('s', -appInfo.timeAlive / 1000, Now());
						sessionCount = cfcTracker.getAppSessionCount(appName);
					} else {
						class = 'highlightRed';
					}
					if (StructKeyExists(refreshingApps, appName)) {
						class = 'highlightGreen';
					} else if (StructKeyExists(restartingApps, appName)) {
						class = 'highlightBlue';
					}
				</cfscript>
				<tr class="#class#">
					<cfif Not appInfo.appExists>
						<td class="cell4BlueSides"></td>
						<th class="cell4BlueSides" scope="row">#HtmlEditFormat(appName)#</th>
						<td class="cell4BlueSides" colspan="6">Garbage Collected</td>
					<cfelse>
						<td class="cell4BlueSides"><input type="checkbox" name="app_#HtmlEditFormat(appName)#" value="#HtmlEditFormat(appName)#" /></td>
						<th class="cell4BlueSides" scope="row">#HtmlEditFormat(appName)#</th>
						<td class="cell4BlueSides"><a alt="zoomin" title="View the application scope for this app." class="button detail" href="ajax/app.cfm?appName=#HtmlEditFormat(appName)#">&nbsp;</a>
						<a href="ajax/appSettings.cfm?appName=#HtmlEditFormat(appName)#" title="View the settings for this application." class="button detail" alt="wrench">&nbsp;</a>
						<a href="sessions.cfm?app=#HtmlEditFormat(appName)###sessions" class="button" title="View sessions that are currently active in this application." alt="person">#HtmlEditFormat(sessionCount)#</a></td>
						<td class="cell4BlueSides">#HtmlEditFormat(appInfo.expired)#</td>
						<td class="cell4BlueSides">#LsDateFormat(accessDate, variables.settings.dateformat)#<br />#LsTimeFormat(accessDate, variables.settings.timeformat)#</td>
						<td class="cell4BlueSides">#LsDateFormat(timeoutDate, variables.settings.dateformat)#<br />#LsTimeFormat(timeoutDate, variables.settings.timeformat)#</td>
						<td class="cell4BlueSides">#LsDateFormat(startDate, variables.settings.dateformat)#<br />#LsTimeFormat(startDate, variables.settings.timeformat)#</td>
						<td class="cell4BlueSides">#HtmlEditFormat(appInfo.isInited)#</td>
					</cfif>
				</tr>
			</cfloop>
		</tbody>
	</table>
	<cfif ArrayLen(apps) Gt 0>
		<div class="cellBlueBottom action">
			<button class="button" alt="stop" title="Stop the selected application(s).  This will remove the application scope from memory and cause the next request to the application to start a new one." value="stop">Stop App</button>
			<button class="button" alt="seek-first" title="Restart the selected application(s).  This will flag the application as not being initialised, causing it to run 'onApplicationStart()' on the next request.  This does not destroy the current application scope variables." value="restart">Restart App</button>
			<button class="button" alt="refresh" title="Updates the last accessed time stamp of the application.  This can be useful for keeping an application scope alive without having to go to the app directly." value="refresh">Refresh last accessed</button>
		</div>
	</cfif>
	</form>
	<br />
</cfoutput>

<cfinclude template="myfooter.cfm" />
<cfinclude template="../footer.cfm" />