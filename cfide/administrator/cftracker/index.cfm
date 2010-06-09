<cfinclude template="../header.cfm" />
<cfsilent>
	<cfsavecontent variable="jQuery">
		<link type="text/css" href="css/overcast/jquery-ui-1.8.2.custom.css" rel="stylesheet" />	
		<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
		<script type="text/javascript" src="js/jquery-ui-1.8.2.custom.min.js"></script>
		<script type="text/javascript" src="js/cftracker.js"></script>
	</cfsavecontent>
	<cfhtmlhead text="#jQuery#" />

	<cfparam name="url.app" type="string" default="" />
	<cfparam name="url.session" type="string" default="" />
	<cfparam name="form.app" type="string" default="" />
	<cfif Len(url.app) Eq 0>
		<cfset url.app = form.app />
	</cfif>
	<cfset cfcTracker = CreateObject('component', 'tracker').init() />
	<cfset apps = cfcTracker.getApplications() />
	
	<cffunction name="getVal" output="false" returntype="any">
		<cfargument name="scope" required="true" />
		<cfargument name="key" type="string" required="true" />
		<cfif StructKeyExists(arguments.scope, arguments.key)>
			<cfreturn arguments.scope[arguments.key] />
		<cfelse>
			<cfreturn '' />
		</cfif>
	</cffunction>
	
	<cfscript>
		expiringApps = {};
		if (cgi.request_method Eq 'post') {
			for (field in form) {
				if (ListFirst(field, '_') Eq 'app' And Len(field) Gt 4) {
					appName = form[field];
					appScope = cfcTracker.getApplication(appName);
					StructClear(appScope);
					appScope.setMaxInactiveInterval(1);
					expiringApps[appName] = true;
				}
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
	table.styled .highlight th {background-color:#e3f7f7 !important;}
	table.styled .highlightRed th {background-color:#f7e3e3 !important;}
	.detail {padding-right: 20px;}
	.loading {background: url('css/overcast/images/ui-anim_basic_16x16.gif') right center no-repeat;}
</style>
<br />
<h2 class="pageHeader">CFTracker</h2>
<h3 class="cellBlueTopAndBottom pageSection">Applications</h3>

<cfoutput>
	<cfset foundApp = false />
	<form action="index.cfm" method="post">
	<table class="styled"> 
		<thead>
			<tr>
				<th class="cellBlueTopAndBottom" scope="col"></th>
				<th class="cellBlueTopAndBottom" scope="col">Application</th>
				<th class="cellBlueTopAndBottom" scope="col">Sessions</th>
				<th class="cellBlueTopAndBottom" scope="col">Expired?</th>
				<th class="cellBlueTopAndBottom" scope="col">Last accessed</th>
				<th class="cellBlueTopAndBottom" scope="col">App Timeout</th>
				<th class="cellBlueTopAndBottom" scope="col">Initialised</th>
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
					if (url.app Eq appName) {
						foundApp = true;
					}
					sessionCount = cfcTracker.getAppSessionCount(appName);
				</cfscript>
				<tr <cfif StructKeyExists(expiringApps, appName)>class="highlightRed"<cfelseif url.app Eq appName>class="highlight"</cfif>>
					<td class="cell4BlueSides"><input type="checkbox" name="app_#HtmlEditFormat(appName)#" value="#HtmlEditFormat(appName)#" /></td>
					<th class="cell4BlueSides" scope="row"><a title="Application Detail" class="detail" href="ajax/app.cfm?appName=#HtmlEditFormat(appName)#">#HtmlEditFormat(appName)#</a></th>
					<td class="cell4BlueSides"><a href="index.cfm?app=#HtmlEditFormat(appName)#" class="button" title="person">#HtmlEditFormat(sessionCount)#</a>
					<td class="cell4BlueSides">#HtmlEditFormat(appInfo.expired)#</td>
					<td class="cell4BlueSides">#LsDateFormat(accessDate)#<br />#LsTimeFormat(accessDate)#</td>
					<td class="cell4BlueSides">#LsDateFormat(timeoutDate)#<br />#LsTimeFormat(timeoutDate)#</td>
					<td class="cell4BlueSides">#LsDateFormat(startDate)#<br />#LsTimeFormat(startDate)#</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
	<cfif ArrayLen(apps) Gt 0>
		<div class="cellBlueBottom action"><button class="button" title="clock">Force expiration</button></div>
	</cfif>
	</form>
	<br />
</cfoutput>

<cfif Len(url.app) Gt 0 And foundApp>

	<cfscript>
		sessions = cfcTracker.getAppSessions(url.app);
		expiring = {};
		filtering = false;
		filters = {};
		if (cgi.request_method Eq 'post') {
			for (field in form) {
				if (ListFirst(field, '_') Eq 'session' And Len(field) Gt 8) {
					sessId = form[field];
					sess = cfcTracker.getSession(sessId);
					StructClear(sess);
					sess.setMaxInactiveInterval(1);
					expiring[sessId] = true;
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
	</cfscript>
	
	<h3 class="cellBlueTopAndBottom pageSection">Sessions <cfif filtering>[filtered]</cfif> (<cfoutput>#HtmlEditFormat(url.app)#</cfoutput>)</h3>
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
						</cfscript>
						<tr <cfif StructKeyExists(expiring, sessId)>class="highlightRed"</cfif>>
							<td class="cell4BlueSides"><input type="checkbox" name="session_#HtmlEditFormat(sessId)#" value="#HtmlEditFormat(sessId)#" /></td>
							<th class="cell4BlueSides" scope="row"><a class="detail" href="ajax/session.cfm?sessId=#HtmlEditFormat(sessId)#">#HtmlEditFormat(sessId)#</a></th>
							<td class="cell4BlueSides">#HtmlEditFormat(sessInfo.expired)#</td>
							<td class="cell4BlueSides">#LsDateFormat(accessDate)#<br />#LsTimeFormat(accessDate)#</td>
							<td class="cell4BlueSides">#LsDateFormat(timeoutDate)#<br />#LsTimeFormat(timeoutDate)#</td>
							<td class="cell4BlueSides">#LsDateFormat(startDate)#<br />#LsTimeFormat(startDate)#</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			<cfif ArrayLen(sessions) Gt 0>
				<div class="cellBlueBottom action"><button class="button" title="clock">Force expiration</button></div>
			</cfif>
		</form>
	</cfoutput>
	
</cfif>

<cfinclude template="../footer.cfm" />