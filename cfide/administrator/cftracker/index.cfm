<cfinclude template="../header.cfm" />
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

	<!--- The dreaded cfhtmlhead tag, just because I don't want to message around with the header template --->
	<cfsavecontent variable="jQuery">
		<link type="text/css" href="css/overcast/jquery-ui-1.8.2.custom.css" rel="stylesheet" />	
		<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
		<script type="text/javascript" src="js/jquery-ui-1.8.2.custom.min.js"></script>
		<script type="text/javascript" src="js/cftracker.js?v=3"></script>
	</cfsavecontent>
	<cfhtmlhead text="#jQuery#" />

	<cfparam name="url.app" type="string" default="" />
	<cfparam name="url.session" type="string" default="" />
	<cfparam name="form.app" type="string" default="" />
	
	<cfscript>
		if (Len(url.app) Eq 0) {
			url.app = form.app;
		}
		
		cfcTracker = CreateObject('component', 'tracker').init();
		apps = cfcTracker.getApplications();
		
		expiringApps = {};
		refreshingApps = {};
		if (cgi.request_method Eq 'post') {
			for (field in form) {
				if (ListFirst(field, '_') Eq 'app' And Len(field) Gt 4) {
					appName = form[field];
					appScope = cfcTracker.getApplication(appName);
					if (IsDefined('variables.appScope')) {
						if (StructKeyExists(form, 'action') && form.action Eq 'expire') {
							StructClear(appScope);
							appScope.setMaxInactiveInterval(1);
							expiringApps[appName] = true;
						} else if (StructKeyExists(form, 'action') && form.action Eq 'reinit') {
							cfcTracker.setAppIsInited(appName, false);
						} else {
							appScope.setLastAccess();
							refreshingApps[appName] = true;
						}
					}
				}
			}
		}
		
		foundApp = false;
		if (apps.contains(url.app)) {
			foundApp = true;
			sessions = cfcTracker.getAppSessions(url.app);
			expiring = {};
			refreshing = {};
			filtering = false;
			filters = {};
			if (cgi.request_method Eq 'post') {
				for (field in form) {
					if (ListFirst(field, '_') Eq 'session' And Len(field) Gt 8) {
						sessId = form[field];
						sess = cfcTracker.getSession(sessId);
						if (IsDefined('variables.sess')) {
							if (StructKeyExists(form, 'action') && form.action Eq 'expire') {
								if (sessId Eq session.getSessionId()) {
									StructDelete(cookie, 'cfid');
									StructDelete(cookie, 'cftoken');
								}
								StructClear(sess);
								sess.setMaxInactiveInterval(1);
								expiring[sessId] = true;
							} else {
								sess.setLastAccess();
								refreshing[sessId] = true;
							}
						}
					} else if (ListFirst(field, '_') Eq 'key') {
						num = ListLast(field, '_');
						if (Not StructKeyExists(filters, num)) {
							filters[num] = {key = '', val = ''};
						}
						filters[num]['key'] = form[field];
					} else if (ListFirst(field, '_') Eq 'val') {
						num = ListLast(field, '_');
						if (Not StructKeyExists(filters, num)) {
							filters[num] = {key = '', val = ''};
						}
						filters[num]['val'] = form[field];
					}
				}
				if (StructCount(filters) Gt 0) {
					for (num in filters) {
						if (Len(Trim(filters[num].key)) Eq 0) {
							StructDelete(filters, num);
						}
					}
				}
				if (StructCount(filters) Gt 0 And ArrayLen(sessions) Gt 0) {
					filtering = true;
					length = ArrayLen(sessions);
					for (i = 1; i Lte length; i++) {
						remove = false;
						for (num in filters) {
							if (Not remove) {
								sessValue = cfcTracker.getSessionValue(sessions[i], filters[num].key);
								if (Not IsDefined('variables.sessValue') Or sessValue Neq filters[num].val) {
									remove = true;
								}
							}
						}
						if (remove) {
							ArrayDeleteAt(sessions, i);
						}
					}
				}
			}
			if (StructCount(filters) Eq 0) {
				filters['1'] = {
					key = '',
					val = ''
				};
				form['key_1'] = '';
				form['val_1'] = '';
			}
		}
	</cfscript>
</cfsilent>
<style type="text/css">
	.pageSection {font-size:13px; font-family:Arial, Helvetica; padding:3px; background-color:#E2E6E7}
	.action {background-color:#f3f7f7; padding:3px;}
	table.styled {border-collapse:collapse; width:100%; border:none;}
	table.styled th {background-color:#F3F7F7;}
	table.styled td, table.styled th {padding:3px;}
	table.styled tbody th {padding-left: 20px;}
	table.styled .highlight th {background-color:#e3f7f7 !important;}
	table.styled .highlightRed th {background-color:#f7e3e3 !important;}
	table.styled .highlightGreen th {background-color:#e3f7e3 !important;}
	.loading th {background: url('css/overcast/images/ui-anim_basic_16x16.gif') left center no-repeat;}
</style>


<br />
<h2 class="pageHeader">CFTracker > Applications &amp; Sessions</h2>
<cfoutput><a href="index.cfm?app=#HtmlEditFormat(url.app)#" class="button" title="refresh">Refresh page</a></cfoutput>

<h3 class="cellBlueTopAndBottom pageSection">Applications</h3>
<ul>
	<li>Forced expiration sets the timeout to 1 second (cannot be 0).  If a request is received within that second, the timeout will be reset to it's original value.</li>
	<li>Large scopes can take time to duplicate and dump due to the need to avoid updating the "last accessed" time.</li>
	<li>The "Is Initialised" flag tells the application if it has run onApplicationStart.</li>
</ul>

<cfoutput>
	<form action="index.cfm?app=#HtmlEditFormat(url.app)#" method="post">
		<input type="hidden" name="action" value="" />
	<table class="styled"> 
		<thead>
			<tr>
				<th class="cellBlueTopAndBottom" scope="col"></th>
				<th class="cellBlueTopAndBottom" scope="col">Application</th>
				<th class="cellBlueTopAndBottom" scope="col">View</th>
				<th class="cellBlueTopAndBottom" scope="col">Expired?</th>
				<th class="cellBlueTopAndBottom" scope="col">Last accessed</th>
				<th class="cellBlueTopAndBottom" scope="col">App Timeout</th>
				<th class="cellBlueTopAndBottom" scope="col">First Initialised</th>
				<th class="cellBlueTopAndBottom" scope="col">Is Initialised</th>
			</tr>
		</thead>
		<tbody>
			<cfif ArrayLen(apps) Eq 0>
				<td class="cell4BlueSides" colspan="7">No applications found</td>
			</cfif>
			<cfloop array="#apps#" index="appName">
				<cfscript>
					appInfo = cfcTracker.getAppInfo(appName);
					accessDate = DateAdd('s', -appInfo.lastAccessed / 1000, Now());
					timeoutDate = DateAdd('s', appInfo.idleTimeout / 1000, accessDate);
					startDate = DateAdd('s', -appInfo.timeAlive / 1000, Now());
					sessionCount = cfcTracker.getAppSessionCount(appName);
					if (StructKeyExists(expiringApps, appName)) {
						class = 'highlightRed';
					} else if (StructKeyExists(refreshingApps, appName)) {
						class = 'highlightGreen';
					} else {
						class = '';
					}
				</cfscript>
				<tr class="#class#">
					<td class="cell4BlueSides"><input type="checkbox" name="app_#HtmlEditFormat(appName)#" value="#HtmlEditFormat(appName)#" /></td>
					<th class="cell4BlueSides" scope="row">#HtmlEditFormat(appName)#</th>
					<td class="cell4BlueSides"><a title="zoomin" class="button detail" href="ajax/app.cfm?appName=#HtmlEditFormat(appName)#">&nbsp;</a>
					<a href="ajax/appSettings.cfm?appName=#HtmlEditFormat(appName)#" class="button detail" title="wrench">&nbsp;</a>
					<a href="index.cfm?app=#HtmlEditFormat(appName)###sessions" class="button" title="person">#HtmlEditFormat(sessionCount)#</a></td>
					<td class="cell4BlueSides">#HtmlEditFormat(appInfo.expired)#</td>
					<td class="cell4BlueSides">#LsDateFormat(accessDate)#<br />#LsTimeFormat(accessDate)#</td>
					<td class="cell4BlueSides">#LsDateFormat(timeoutDate)#<br />#LsTimeFormat(timeoutDate)#</td>
					<td class="cell4BlueSides">#LsDateFormat(startDate)#<br />#LsTimeFormat(startDate)#</td>
					<td class="cell4BlueSides">#HtmlEditFormat(appInfo.isInited)#</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
	<cfif ArrayLen(apps) Gt 0>
		<div class="cellBlueBottom action"><button class="button" title="clock" value="expire">Attempt forced expiration</button> <button class="button" title="refresh" value="refresh">Refresh last accessed</button> <button class="button" title="power" value="reinit">onApplicationStart on next request</button></div>
	</cfif>
	</form>
	<br />
</cfoutput>

<cfif foundApp>

	<h3 class="cellBlueTopAndBottom pageSection" id="sessions">Sessions <cfif filtering>[filtered]</cfif> (<cfoutput>#HtmlEditFormat(url.app)#</cfoutput>)</h3>
	<ul>
	<li>Forced expiration sets the timeout to 1 second (cannot be 0).  If a request is received within that second, the timeout will be reset to it's original value.</li>
	<li>Large scopes can take time to duplicate and dump due to the need to avoid updating the "last accessed" time.</li>
</ul>
	<form action="index.cfm" method="post">
		<cfoutput>
			<input type="hidden" name="app" value="#HtmlEditFormat(url.app)#" />
			<div id="filterRows">
				<cfset first = true />
				<cfloop collection="#filters#" item="n">
					<div id="row_#n#"><label for="key_#n#">Key: <input type="text" name="key_#n#" id="key_#n#" value="#HtmlEditFormat(GetVal(form, 'key_' & n))#" /></label> <label for="val_#n#">Value: <input type="text" name="val_#n#" id="val_#n#" value="#HtmlEditFormat(GetVal(form, 'val_' & n))#" /></label> <cfif Not first> <button class="removeRow">Remove row</button></cfif></div>
					<cfset first = false />
				</cfloop>
			</div>
		</cfoutput>
		<div class="cellBlueTopAndBottom action"><button class="button" title="search">Filter</button> <button type="button" class="button" title="plus" id="addRow">Add more filters</button></div>
	</form>
	
	<cfoutput>
		<form action="index.cfm" method="post">
			<input type="hidden" name="action" value="" />
			<input type="hidden" name="app" value="#HtmlEditFormat(url.app)#" />
			<table class="styled"> 
				<thead>
					<tr>
						<th class="cellBlueTopAndBottom" scope="col"></th>
						<th class="cellBlueTopAndBottom" scope="col">Session</th>
						<th class="cellBlueTopAndBottom" scope="col">Expired?</th>
						<th class="cellBlueTopAndBottom" scope="col">Last accessed</th>
						<th class="cellBlueTopAndBottom" scope="col">Sess Timeout</th>
						<th class="cellBlueTopAndBottom" scope="col">Initialised</th>
						<th class="cellBlueTopAndBottom" scope="col">ID from URL</th>
						<th class="cellBlueTopAndBottom" scope="col">Client IP</th>
					</tr>
				</thead>
				<tbody>
					<cfif ArrayLen(sessions) Eq 0>
						<td class="cell4BlueSides" colspan="6">No sessions found</td>
					</cfif>
					<cfloop array="#sessions#" index="sessId">
						<cfscript>
							sessInfo = cfcTracker.getSessInfo(sessId);
							accessDate = DateAdd('s', -sessInfo.lastAccessed / 1000, Now());
							timeoutDate = DateAdd('s', sessInfo.idleTimeout / 1000, accessDate);
							startDate = DateAdd('s', -sessInfo.timeAlive / 1000, Now());
							if (url.app Eq appName) {
								foundApp = true;
							}
							if (StructKeyExists(expiring, sessId)) {
								class = 'highlightRed';
							} else if (StructKeyExists(refreshing, sessId)) {
								class = 'highlightGreen';
							} else {
								class = '';
							}
						</cfscript>
						<tr class="#class#">
							<td class="cell4BlueSides"><input type="checkbox" name="session_#HtmlEditFormat(sessId)#" value="#HtmlEditFormat(sessId)#" /></td>
							<th class="cell4BlueSides" scope="row"><a class="detail" title="Session Detail" href="ajax/session.cfm?sessId=#HtmlEditFormat(sessId)#">#HtmlEditFormat(sessId)#</a></th>
							<td class="cell4BlueSides">#HtmlEditFormat(sessInfo.expired)#</td>
							<td class="cell4BlueSides">#LsDateFormat(accessDate)#<br />#LsTimeFormat(accessDate)#</td>
							<td class="cell4BlueSides">#LsDateFormat(timeoutDate)#<br />#LsTimeFormat(timeoutDate)#</td>
							<td class="cell4BlueSides">#LsDateFormat(startDate)#<br />#LsTimeFormat(startDate)#</td>
							<td class="cell4BlueSides">#sessInfo.isIdFromUrl#</td>
							<td class="cell4BlueSides">#HtmlEditFormat(sessInfo.clientIp)#</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			<cfif ArrayLen(sessions) Gt 0>
				<div class="cellBlueBottom action"><button class="button" title="clock" value="expire">Attempt forced expiration</button> <button class="button" title="refresh" value="refresh">Refresh last accessed</button></div>
			</cfif>
		</form>
	</cfoutput>
</cfif>

<cfinclude template="myfooter.cfm" />

<cfinclude template="../footer.cfm" />