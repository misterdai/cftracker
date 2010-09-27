<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfscript>
			var lc = {};
			lc.cfcPath = 'cftracker.';
			if (application.settings.demo) {
				lc.cfcPath &= 'demo.';
			}
			variables.sessTracker = CreateObject('component', lc.cfcPath & 'sessions').init(application.settings.security.password);
		</cfscript>
	</cffunction>

	<cffunction name="default" output="false">
		<cfreturn variables.sessTracker.getInfo() />
	</cffunction>

	<cffunction name="application" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="wc" type="string" required="true" />
		<cfreturn variables.sessTracker.getInfo(variables.sessTracker.getSessions(arguments.name, arguments.wc)) />
	</cffunction>

	<cffunction name="getScope" output="false">
		<cfargument name="wc" type="string" required="true" />
		<cfargument name="app" type="string" required="true" />
		<cfargument name="name" type="string" required="true" />
		<cfreturn variables.sessTracker.getScope(arguments.wc, arguments.app, arguments.name) />
	</cffunction>

	<cffunction name="stop" output="false">
		<cfargument name="sessions" />
		<cfset var lc = {} />
		<cfloop array="#arguments.sessions#" index="lc.s">
			<cfset lc.wc = ListFirst(lc.s, Chr(9)) />
			<cfset lc.app = ListGetAt(lc.s, 2, Chr(9)) />
			<cfset lc.id = ListLast(lc.s, Chr(9)) />
			<cfset variables.sessTracker.stop(lc.wc, lc.app, lc.id) />
		</cfloop>
	</cffunction>

	<cffunction name="refresh" output="false">
		<cfargument name="sessions" />
		<cfset var lc = {} />
		<cfloop array="#arguments.sessions#" index="lc.s">
			<cfset lc.wc = ListFirst(lc.s, Chr(9)) />
			<cfset lc.app = ListGetAt(lc.s, 2, Chr(9)) />
			<cfset lc.id = ListLast(lc.s, Chr(9)) />
			<cfset variables.sessTracker.touch(lc.wc, lc.app, lc.id) />
		</cfloop>
	</cffunction>

	<cffunction name="filter" output="false" access="private">
		<cfargument name="id" type="string" required="false" default="" />
		<cfargument name="expired" type="string" required="false" default="" />
		<cfargument name="lastaccessed" type="string" required="false" default="" />
		<cfargument name="lastaccessedOp" type="string" required="false" default="" />
		<cfargument name="created" type="string" required="false" default="" />
		<cfargument name="createdOp" type="string" required="false" default="" />
		<cfargument name="timeout" type="string" required="false" default="" />
		<cfargument name="timeoutOp" type="string" required="false" default="" />
		<cfargument name="clientIp" type="string" required="false" default="" />
		<cfargument name="idFromUrl" type="string" required="false" default="" />
		<cfscript>
			var lc = {};
			lc.items = variables.sessTracker.getInfo();
			for (lc.wc in lc.items) {
				for (lc.app in lc.items[lc.wc]) {
					for (lc.i in lc.items[lc.wc][lc.app]) {
						if (Len(arguments.id) Gt 0) {
							if (Not ReFindNoCase(arguments.id, lc.i)) {
								StructDelete(lc.items[lc.wc][lc.app], lc.i);
							}
						}
						if (Len(arguments.clientIp) Gt 0) {
							if (Not ReFindNoCase(arguments.clientIp, lc.items[lc.wc][lc.app][lc.i].clientIp)) {
								StructDelete(lc.items[lc.wc][lc.app], lc.i);
							}
						}
						if (Len(arguments.expired) Gt 0) {
							if (arguments.expired Neq lc.items[lc.wc][lc.app][lc.i].expired) {
								StructDelete(lc.items[lc.wc][lc.app], lc.i);
							}
						}
						if (Len(arguments.idFromUrl) Gt 0) {
							if (arguments.idFromUrl Neq lc.items[lc.wc][lc.app][lc.i].idFromUrl) {
								StructDelete(lc.items[lc.wc][lc.app], lc.i);
							}
						}
						if (Len(arguments.created) Gt 0 And Len(arguments.createdOp) Gt 0) {
							if (arguments.createdOp Eq 'before' And ParseDateTime(arguments.created) Lte lc.items[lc.wc][lc.app][lc.i].created) {
								StructDelete(lc.items[lc.wc][lc.app], lc.i);
							} else if (arguments.createdOp Eq 'on' And ParseDateTime(arguments.created) Neq lc.items[lc.wc][lc.app][lc.i].created) {
								StructDelete(lc.items[lc.wc][lc.app], lc.i);
							} else if (arguments.createdOp Eq 'after' And ParseDateTime(arguments.created) Gte lc.items[lc.wc][lc.app][lc.i].created) {
								StructDelete(lc.items[lc.wc][lc.app], lc.i);
							}
						}
						if (Len(arguments.lastaccessed) Gt 0 And Len(arguments.lastaccessedOp) Gt 0) {
							if (arguments.lastaccessedOp Eq 'before' And ParseDateTime(arguments.lastaccessed) Lte lc.items[lc.wc][lc.app][lc.i].lastaccessed) {
								StructDelete(lc.items[lc.wc][lc.app], lc.i);
							} else if (arguments.lastaccessedOp Eq 'on' And ParseDateTime(arguments.lastaccessed) Neq lc.items[lc.wc][lc.app][lc.i].lastaccessed) {
								StructDelete(lc.items[lc.wc][lc.app], lc.i);
							} else if (arguments.lastaccessedOp Eq 'after' And ParseDateTime(arguments.lastaccessed) Gte lc.items[lc.wc][lc.app][lc.i].lastaccessed) {
								StructDelete(lc.items[lc.wc][lc.app], lc.i);
							}
						}
						if (Len(arguments.timeout) Gt 0 And Len(arguments.timeoutOp) Gt 0) {
							if (arguments.timeoutOp Eq 'before' And ParseDateTime(arguments.timeout) Lte lc.items[lc.wc][lc.app][lc.i].timeout) {
								StructDelete(lc.items[lc.wc][lc.app], lc.i);
							} else if (arguments.timeoutOp Eq 'on' And ParseDateTime(arguments.timeout) Neq lc.items[lc.wc][lc.app][lc.i].timeout) {
								StructDelete(lc.items[lc.wc][lc.app], lc.i);
							} else if (arguments.timeoutOp Eq 'after' And ParseDateTime(arguments.timeout) Gte lc.items[lc.wc][lc.app][lc.i].timeout) {
								StructDelete(lc.items[lc.wc][lc.app], lc.i);
							}
						}
					}
				}
			}
			return lc.items;
		</cfscript>
	</cffunction>

	<cffunction name="stopBy" output="false">
		<cfscript>
			var lc = {};
			if (StructKeyExists(arguments, 'Processing')) {
				lc.result = application.validateThis.validate(
					objectType = 'Session',
					theObject = form
				);
				if (lc.result.getIsSuccess()) {
					// filter method is not scoped as CF8 cannot use named arguments if scoped.
					lc.items = filter(argumentCollection = arguments);
					for (lc.wc in lc.items) {
						for (lc.app in lc.items[lc.wc]) {
							for (lc.i in lc.items[lc.wc][lc.app]) {
								variables.sessTracker.stop(lc.wc, lc.app, lc.i);
							}
						}
					}
				}
				lc.resultData = {
					uniFormErrors = lc.result.getFailuresForUniForm(),
					success = lc.result.getIsSuccess()
				};
				return lc.resultData;
			}
		</cfscript>
	</cffunction>

	<cffunction name="refreshBy" output="false">
		<cfscript>
			var lc = {};
			if (StructKeyExists(arguments, 'Processing')) {
				lc.result = application.validateThis.validate(
					objectType = 'Session',
					theObject = form
				);
				if (lc.result.getIsSuccess()) {
					// filter method is not scoped as CF8 cannot use named arguments if scoped.
					lc.items = filter(argumentCollection = arguments);
					for (lc.wc in lc.items) {
						for (lc.app in lc.items[lc.wc]) {
							for (lc.i in lc.items[lc.wc][lc.app]) {
								variables.sessTracker.touch(lc.wc, lc.app, lc.i);
							}
						}
					}
				}
				lc.resultData = {
					uniFormErrors = lc.result.getFailuresForUniForm(),
					success = lc.result.getIsSuccess()
				};
				return lc.resultData;
			}
		</cfscript>
	</cffunction>
</cfcomponent>