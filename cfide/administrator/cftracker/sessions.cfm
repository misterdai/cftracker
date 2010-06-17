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
	<cfparam name="form.action" type="string" default="" />
	
	<cfscript>
		cfcTracker = CreateObject('component', 'tracker').init();

		appInfo = cfcTracker.getAppInfo(url.app);
	</cfscript>
	<cfif Not appInfo.appExists>
		<cflocation url="index.cfm?error=1" addtoken="false" />
	</cfif>
	<cffunction name="abort"><cfdump var="#arguments#"><cfabort></cffunction>
	<cfscript>
		sessions = cfcTracker.getAppSessions(url.app);
		sessCount = ArrayLen(sessions);
		refreshing = {};
		filtering = false;
		filters = {};
		error = '';
		if (cgi.request_method Eq 'post') {
			if (sessCount Eq 0) {
				error = 'No sessions available.';
			} else if (StructKeyExists(form, 'form')) {
				if (form.form Eq 'properties') {
					// ACTIONS BY PROPERTIES
					present = false;
					fields = 'lastAccessed,idleTimeout,timeAlive,expired,idlePercent,isNew,isIdFromUrl,clientIp,isJ2eeSession,idlePercent,isInited';
					formAction = form.action;
					for (field in form) {
						if (ListFindNoCase(fields, field) And Len(Trim(form[field])) Gt 0) {
							present = true;
						} else {
							StructDelete(form, field);
						}
					}
					if (Not present) {
						error = 'No fields were present.';
					} else {
						count = ArrayLen(sessions);
						for (s = 1; s Lte count; s = s + 1) {
							sessInfo = cfcTracker.getSessInfo(sessions[s]);
							if (sessInfo.sessionExists) {
								actionable = true;
								for (field in form) {
									if (form[field] Neq sessInfo[field]) {
										actionable = false;
									}
								}
								if (actionable) {
									if (formAction Eq 'stop') {
										cfcTracker.sessionStop(sessions[s]);
									} else if (formAction Eq 'refresh') {
										cfcTracker.getSession(sessions[s]).setLastAccess();
										refreshing[sessions[s]] = true;
									}
								}
							}
						}
					}
				} else if (form.form Eq 'filter') {
					// FILTERING THE SESSION TABLE
					for (field in form) {
						if (ListFirst(field, '_') Eq 'key') {
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
				} else if (form.form Eq 'action') {
					// ACTIONS AGAINST THE SESSION TABLE
					for (field in form) {
						if (ListFirst(field, '_') Eq 'session' And Len(field) Gt 8) {
							sessId = form[field];
							sess = cfcTracker.getSession(sessId);
							if (IsDefined('variables.sess')) {
								if (StructKeyExists(form, 'action') && form.action Eq 'stop') {
									if (sessId Eq session.getSessionId()) {
										StructDelete(cookie, 'cfid');
										StructDelete(cookie, 'cftoken');
									}
									cfcTracker.sessionStop(sessId);
								} else {
									sess.setLastAccess();
									refreshing[sessId] = true;
								}
							}
						}
					}
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
</cfsilent>
<script type="text/javascript" src="js/cftracker.js?v=3"></script>
<br />
<cfoutput>
	<h2 class="pageHeader">CFTracker > Sessions for "#HtmlEditFormat(url.app)#"</h2>
	<a href="sessions.cfm?app=#HtmlEditFormat(url.app)#" class="button" alt="refresh" title="Refresh the page, keeping the currently selected application.  This is useful for avoiding extra post requests.">Refresh page</a>
</cfoutput>

<h3 class="cellBlueTopAndBottom pageSection">Application information</h3>
<cfscript>
	accessDate = DateAdd('s', -appInfo.lastAccessed / 1000, Now());
	timeoutDate = DateAdd('s', appInfo.idleTimeout / 1000, accessDate);
	startDate = DateAdd('s', -appInfo.timeAlive / 1000, Now());
</cfscript>
<table class="styled narrow">
	<tbody><cfoutput>
		<tr>
			<th scope="row" class="cellBlueTopAndBottom">Expired</th>
			<td class="cell4BlueSides">#HtmlEditFormat(appInfo.expired)#</td>
		</tr>
		<tr>
			<th scope="row" class="cellBlueTopAndBottom">Idle Percentage</th>
			<td class="cell4BlueSides">#NumberFormat(appInfo.idlePercent, '_.99')# %</td>
		</tr>
		<tr>
			<th scope="row" class="cellBlueTopAndBottom">Idle Timeout</th>
			<td class="cell4BlueSides">#LsDateFormat(timeoutDate, variables.settings.dateformat)# #LsTimeFormat(timeoutDate, variables.settings.timeformat)#</td>
		</tr>
		<tr>
			<th scope="row" class="cellBlueTopAndBottom">Initialised Date</th>
			<td class="cell4BlueSides">#LsDateFormat(startDate, variables.settings.dateformat)# #LsTimeFormat(startDate, variables.settings.timeformat)#</td>
		</tr>
		<tr>
			<th scope="row" class="cellBlueTopAndBottom">Last Accessed</th>
			<td class="cell4BlueSides">#LsDateFormat(accessDate, variables.settings.dateformat)# #LsTimeFormat(accessDate, variables.settings.timeformat)#</td>
		</tr>
		<tr>
			<th scope="row" class="cellBlueTopAndBottom">Is Initialised</th>
			<td class="cell4BlueSides">#HtmlEditFormat(appInfo.isInited)#</td>
		</tr>
	</cfoutput></tbody>
</table>


<h3 class="cellBlueTopAndBottom pageSection">Actions by property</h3>
<form action="sessions.cfm?app=<cfoutput>#HtmlEditFormat(url.app)#</cfoutput>" method="post">
	<input type="hidden" name="form" value="properties" />
	<input type="hidden" name="action" value="" />
	
	<cfoutput>
		<label for="clientIp">Client IP:</label><br />
		<input type="text" name="clientIp" id="clientId" value="#HtmlEditFormat(GetVal(form, 'clientIp'))#" />
	</cfoutput>
	<div class="cellBlueBottom action">
		<button class="button" alt="stop" value="stop" title="Stop the selected session(s).  This will remove the session scope from memory and cause the next request to create a new session.">Stop session</button>
		<button class="button" alt="refresh" value="refresh" title="Updates the last accessed time stamp of the session.  This can be useful for keeping a session scope alive without using it directly.">Refresh last accessed</button>
	</div>
</form>


<h3 class="cellBlueTopAndBottom pageSection" id="sessions">Filter <cfif filtering>[filtered]</cfif> (<cfoutput>#HtmlEditFormat(url.app)#</cfoutput>)</h3>
<ul>
	<li>Large scopes can take time to duplicate and dump due to the need to avoid updating the "last accessed" time.</li>
</ul>
<form action="sessions.cfm?app=<cfoutput>#HtmlEditFormat(url.app)#</cfoutput>" method="post">
	<input type="hidden" name="form" value="filter" />
	<cfoutput>
		<div id="filterRows">
			<cfset first = true />
			<cfloop collection="#filters#" item="n">
				<div id="row_#n#"><label for="key_#n#">Key: <input type="text" name="key_#n#" id="key_#n#" value="#HtmlEditFormat(GetVal(form, 'key_' & n))#" /></label> <label for="val_#n#">Value: <input type="text" name="val_#n#" id="val_#n#" value="#HtmlEditFormat(GetVal(form, 'val_' & n))#" /></label> <cfif Not first> <button class="removeRow">Remove row</button></cfif></div>
				<cfset first = false />
			</cfloop>
		</div>
	</cfoutput>
	<div class="cellBlueTopAndBottom action">
		<button class="button" alt="search" title="Filter the sessions of the currently selected application.">Filter</button>
		<button type="button" class="button" alt="plus" id="addRow" title="Create a new key/value pair for filtering sessions.">Add more filters</button>
	</div>
</form>

<cfoutput>
	<h3 class="cellBlueTopAndBottom pageSection">Sessions <cfif filtering>[filtered]</cfif></h3>
	<form action="sessions.cfm?app=#HtmlEditFormat(url.app)#" method="post">
		<input type="hidden" name="action" value="" />
		<input type="hidden" name="form" value="action" />
		<table class="styled"> 
			<thead>
				<tr>
					<th class="cellBlueTopAndBottom" scope="col" title="Use the boxes below to select which sessions you'd like to perform an action against."></th>
					<th class="cellBlueTopAndBottom" scope="col" title="This is the session ID, usually named by combining the application name, an underscore and the CFID, CFTOKEN values.">Session</th>
					<th class="cellBlueTopAndBottom" scope="col" title="If marked expired, the session has timed out and is now marked for garbage collection.">Expired?</th>
					<th class="cellBlueTopAndBottom" scope="col" title="Date and time that the session was last accessed.">Last accessed</th>
					<th class="cellBlueTopAndBottom" scope="col" title="Date and time that the session is expected to time out if there is no further activity.">Sess Timeout</th>
					<th class="cellBlueTopAndBottom" scope="col" title="Date and time that the session was first created.">Initialised</th>
					<th class="cellBlueTopAndBottom" scope="col" title="Was the ID of the session created from URL variables (e.g. CFID and CFToken)">ID from URL</th>
					<th class="cellBlueTopAndBottom" scope="col" title="This is the client IP address that originally started the session.">Client IP</th>
					<th class="cellBlueTopAndBottom" scope="col" title="Session type, CF being the standard Coldfusion session and J2EE if 'Use J2EE session variables' is checked in CFIDE Administrator.">Type</th>
				</tr>
			</thead>
			<tbody>
				<cfif ArrayLen(sessions) Eq 0>
					<td class="cell4BlueSides" colspan="8">No sessions found</td>
				</cfif>
				<cfloop array="#sessions#" index="sessId">
					<cfscript>
						class = '';
						sessInfo = cfcTracker.getSessInfo(sessId);
						if (sessInfo.sessionExists) {
							accessDate = DateAdd('s', -sessInfo.lastAccessed / 1000, Now());
							timeoutDate = DateAdd('s', sessInfo.idleTimeout / 1000, accessDate);
							startDate = DateAdd('s', -sessInfo.timeAlive / 1000, Now());
						} else {
							class = 'highlightRed';
						}
						if (StructKeyExists(refreshing, sessId)) {
							class = 'highlightGreen';
						}
					</cfscript>
					<tr class="#class#">
						<cfif Not sessInfo.sessionExists>
							<td class="cell4BlueSides"></td>
							<th class="cell4BlueSides" scope="row">#HtmlEditFormat(sessId)#</th>
							<td colspan="6" class="cell4BlueSides">Garbage Collected</td>
						<cfelse>
							<td class="cell4BlueSides"><cfif Not sessInfo.isJ2eeSession><input type="checkbox" name="session_#HtmlEditFormat(sessId)#" value="#HtmlEditFormat(sessId)#" /></cfif></td>
							<th class="cell4BlueSides" scope="row"><a class="detail" alt="Session Detail" href="ajax/session.cfm?sessId=#HtmlEditFormat(sessId)#">#HtmlEditFormat(sessId)#</a></th>
							<td class="cell4BlueSides">#HtmlEditFormat(sessInfo.expired)#</td>
							<td class="cell4BlueSides">#LsDateFormat(accessDate, variables.settings.dateformat)#<br />#LsTimeFormat(accessDate, variables.settings.timeformat)#</td>
							<td class="cell4BlueSides">#LsDateFormat(timeoutDate, variables.settings.dateformat)#<br />#LsTimeFormat(timeoutDate, variables.settings.timeformat)#</td>
							<td class="cell4BlueSides">#LsDateFormat(startDate, variables.settings.dateformat)#<br />#LsTimeFormat(startDate, variables.settings.timeformat)#</td>
							<td class="cell4BlueSides">#sessInfo.isIdFromUrl#</td>
							<td class="cell4BlueSides">#HtmlEditFormat(sessInfo.clientIp)#</td>
							<td class="cell4BlueSides"><cfif sessInfo.isJ2eeSession>J2EE<cfelse>CF</cfif></td>
						</cfif>
					</tr>
				</cfloop>
			</tbody>
		</table>
		<cfif ArrayLen(sessions) Gt 0>
			<div class="cellBlueBottom action">
				<button class="button" alt="stop" value="stop" title="Stop the selected session(s).  This will remove the session scope from memory and cause the next request to create a new session.">Stop session</button>
				<button class="button" alt="refresh" value="refresh" title="Updates the last accessed time stamp of the session.  This can be useful for keeping a session scope alive without using it directly.">Refresh last accessed</button>
			</div>
		</cfif>
	</form>
</cfoutput>

<cfinclude template="myfooter.cfm" />
<cfinclude template="../footer.cfm" />