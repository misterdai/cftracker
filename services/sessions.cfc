<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfscript>
			if (Not application.settings.demo) {
				variables.sessTracker = CreateObject('component', 'cftracker.sessions').init(application.settings.security.password);
			}
		</cfscript>
	</cffunction>

	<cffunction name="default" output="false">
		<cfscript>
			var lc = {};
			if (application.settings.demo) {
				lc.sessions = {};
				for (lc.app in application.data.apps) {
					for (lc.sess in application.data.apps[lc.app].sessions) {
						lc.sessions[lc.sess] = application.data.apps[lc.app].sessions[lc.sess].metadata;
					}
				}
			} else {
				lc.sessions = variables.sessTracker.getInfo();
			}
			return lc.sessions;
		</cfscript> 
	</cffunction>

	<cffunction name="application" output="false">
		<cfargument name="name" type="string" required="true">
		<cfscript>
			var lc = {};
			if (application.settings.demo) {
				lc.sessions = {};
				for (lc.sess in application.data.apps[arguments.name].sessions) {
					lc.sessions[lc.sess] = application.data.apps[arguments.name].sessions[lc.sess].metadata;
				}
			} else {
				lc.sessions = variables.sessTracker.getInfo(variables.sessTracker.getSessions(arguments.name));
			}
			return lc.sessions;
		</cfscript> 
	</cffunction>

	<cffunction name="getScope" output="false">
		<cfargument name="wc" type="string" required="true" />
		<cfargument name="app" type="string" required="true" />
		<cfargument name="name" type="string" required="true" />
		<cfscript>
			var lc = {};
			if (application.settings.demo) {
				for (lc.app in application.data.apps) {
					for (lc.sess in application.data.apps[lc.app].sessions) {
						if (lc.sess Eq arguments.name) {
							return application.data.apps[lc.app].sessions[lc.sess].scope;
						}
					}
				}
				return false;
			} else {
				return variables.sessTracker.getScope(arguments.wc, arguments.app, arguments.name);
			}
		</cfscript>
	</cffunction>

	<cffunction name="stop" output="false">
		<cfargument name="sessions" />
		<cfset var lc = {} />
		<cfif Not application.settings.demo>
			<cfloop array="#arguments.sessions#" index="lc.s">
				<cfset variables.sessTracker.stop(lc.s) />
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="refresh" output="false">
		<cfargument name="sessions" />
		<cfset var lc = {} />
		<cfif Not application.settings.demo>
			<cfloop array="#arguments.sessions#" index="lc.s">
				<cfset variables.sessTracker.touch(lc.s) />
			</cfloop>
		</cfif>
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
			for (lc.i in lc.items) {
				if (Len(arguments.id) Gt 0) {
					if (Not ReFindNoCase(arguments.id, lc.i)) {
						StructDelete(lc.items, lc.i);
					}
				}
				if (Len(arguments.clientIp) Gt 0) {
					if (Not ReFindNoCase(arguments.clientIp, lc.items[lc.i].clientIp)) {
						StructDelete(lc.items, lc.i);
					}
				}
				if (Len(arguments.expired) Gt 0) {
					if (arguments.expired Neq lc.items[lc.i].expired) {
						StructDelete(lc.items, lc.i);
					}
				}
				if (Len(arguments.idFromUrl) Gt 0) {
					if (arguments.idFromUrl Neq lc.items[lc.i].idFromUrl) {
						StructDelete(lc.items, lc.i);
					}
				}
				if (Len(arguments.created) Gt 0 And Len(arguments.createdOp) Gt 0) {
					if (arguments.createdOp Eq 'before' And ParseDateTime(arguments.created) Lte lc.items[lc.i].created) {
						StructDelete(lc.items, lc.i);
					} else if (arguments.createdOp Eq 'on' And ParseDateTime(arguments.created) Neq lc.items[lc.i].created) {
						StructDelete(lc.items, lc.i);
					} else if (arguments.createdOp Eq 'after' And ParseDateTime(arguments.created) Gte lc.items[lc.i].created) {
						StructDelete(lc.items, lc.i);
					}
				}
				if (Len(arguments.lastaccessed) Gt 0 And Len(arguments.lastaccessedOp) Gt 0) {
					if (arguments.lastaccessedOp Eq 'before' And ParseDateTime(arguments.lastaccessed) Lte lc.items[lc.i].lastaccessed) {
						StructDelete(lc.items, lc.i);
					} else if (arguments.lastaccessedOp Eq 'on' And ParseDateTime(arguments.lastaccessed) Neq lc.items[lc.i].lastaccessed) {
						StructDelete(lc.items, lc.i);
					} else if (arguments.lastaccessedOp Eq 'after' And ParseDateTime(arguments.lastaccessed) Gte lc.items[lc.i].lastaccessed) {
						StructDelete(lc.items, lc.i);
					}
				}
				if (Len(arguments.timeout) Gt 0 And Len(arguments.timeoutOp) Gt 0) {
					if (arguments.timeoutOp Eq 'before' And ParseDateTime(arguments.timeout) Lte lc.items[lc.i].timeout) {
						StructDelete(lc.items, lc.i);
					} else if (arguments.timeoutOp Eq 'on' And ParseDateTime(arguments.timeout) Neq lc.items[lc.i].timeout) {
						StructDelete(lc.items, lc.i);
					} else if (arguments.timeoutOp Eq 'after' And ParseDateTime(arguments.timeout) Gte lc.items[lc.i].timeout) {
						StructDelete(lc.items, lc.i);
					}
				}
			}
			return lc.items;
		</cfscript>
	</cffunction>

	<cffunction name="stopBy" output="false">
		<cfscript>
			var lc = {};
			if (Not application.settings.demo) {
				lc.items = filter(argumentCollection = arguments);
				for (lc.i in lc.items) {
					variables.sessTracker.stop(lc.i);
				}
			}
		</cfscript>
	</cffunction>

	<cffunction name="refreshBy" output="false">
		<cfscript>
			var lc = {};
			if (Not application.settings.demo) {
				lc.items = filter(argumentCollection = arguments);
				for (lc.i in lc.items) {
					variables.sessTracker.refresh(lc.i);
				}
			}
		</cfscript>
	</cffunction>
</cfcomponent>