<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfscript>
			if (Not application.settings.demo) {
				variables.sessTracker = CreateObject('component', 'cftracker.sessions').init();
			}
		</cfscript>
	</cffunction>

	<cffunction name="default" output="false">
		<cfscript>
			var local = {};
			if (application.settings.demo) {
				local.sessions = {};
				for (local.app in application.data.apps) {
					for (local.sess in application.data.apps[local.app].sessions) {
						local.sessions[local.sess] = application.data.apps[local.app].sessions[local.sess].metadata;
					}
				}
			} else {
				local.sessions = variables.sessTracker.getInfo();
			}
			return local.sessions;
		</cfscript> 
	</cffunction>

	<cffunction name="application" output="false">
		<cfargument name="name" type="string" required="true">
		<cfscript>
			var local = {};
			if (application.settings.demo) {
				local.sessions = {};
				for (local.sess in application.data.apps[arguments.name].sessions) {
					local.sessions[local.sess] = application.data.apps[arguments.name].sessions[local.sess].metadata;
				}
			} else {
				local.sessions = variables.sessTracker.getInfo(variables.sessTracker.getSessions(arguments.name));
			}
			return local.sessions;
		</cfscript> 
	</cffunction>

	<cffunction name="getScope" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfscript>
			var local = {};
			if (application.settings.demo) {
				for (local.app in application.data.apps) {
					for (local.sess in application.data.apps[local.app].sessions) {
						if (local.sess Eq arguments.name) {
							return application.data.apps[local.app].sessions[local.sess].scope;
						}
					}
				}
				return false;
			} else {
				return variables.sessTracker.getScope(arguments.name);
			}
		</cfscript>
	</cffunction>

	<cffunction name="stop" output="false">
		<cfargument name="sessions" />
		<cfset var local = {} />
		<cfif Not application.settings.demo>
			<cfloop array="#arguments.sessions#" index="local.s">
				<cfset variables.sessTracker.stop(local.s) />
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="refresh" output="false">
		<cfargument name="sessions" />
		<cfset var local = {} />
		<cfif Not application.settings.demo>
			<cfloop array="#arguments.sessions#" index="local.s">
				<cfset variables.sessTracker.touch(local.s) />
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
			var local = {};
			local.items = variables.sessTracker.getInfo();
			for (local.i in local.items) {
				if (Len(arguments.id) Gt 0) {
					if (Not ReFindNoCase(arguments.id, local.i)) {
						StructDelete(local.items, local.i);
					}
				}
				if (Len(arguments.clientIp) Gt 0) {
					if (Not ReFindNoCase(arguments.clientIp, local.items[local.i].clientIp)) {
						StructDelete(local.items, local.i);
					}
				}
				if (Len(arguments.expired) Gt 0) {
					if (arguments.expired Neq local.items[local.i].expired) {
						StructDelete(local.items, local.i);
					}
				}
				if (Len(arguments.idFromUrl) Gt 0) {
					if (arguments.idFromUrl Neq local.items[local.i].idFromUrl) {
						StructDelete(local.items, local.i);
					}
				}
				if (Len(arguments.created) Gt 0 And Len(arguments.createdOp) Gt 0) {
					if (arguments.createdOp Eq 'before' And ParseDateTime(arguments.created) Lte local.items[local.i].created) {
						StructDelete(local.items, local.i);
					} else if (arguments.createdOp Eq 'on' And ParseDateTime(arguments.created) Neq local.items[local.i].created) {
						StructDelete(local.items, local.i);
					} else if (arguments.createdOp Eq 'after' And ParseDateTime(arguments.created) Gte local.items[local.i].created) {
						StructDelete(local.items, local.i);
					}
				}
				if (Len(arguments.lastaccessed) Gt 0 And Len(arguments.lastaccessedOp) Gt 0) {
					if (arguments.lastaccessedOp Eq 'before' And ParseDateTime(arguments.lastaccessed) Lte local.items[local.i].lastaccessed) {
						StructDelete(local.items, local.i);
					} else if (arguments.lastaccessedOp Eq 'on' And ParseDateTime(arguments.lastaccessed) Neq local.items[local.i].lastaccessed) {
						StructDelete(local.items, local.i);
					} else if (arguments.lastaccessedOp Eq 'after' And ParseDateTime(arguments.lastaccessed) Gte local.items[local.i].lastaccessed) {
						StructDelete(local.items, local.i);
					}
				}
				if (Len(arguments.timeout) Gt 0 And Len(arguments.timeoutOp) Gt 0) {
					if (arguments.timeoutOp Eq 'before' And ParseDateTime(arguments.timeout) Lte local.items[local.i].timeout) {
						StructDelete(local.items, local.i);
					} else if (arguments.timeoutOp Eq 'on' And ParseDateTime(arguments.timeout) Neq local.items[local.i].timeout) {
						StructDelete(local.items, local.i);
					} else if (arguments.timeoutOp Eq 'after' And ParseDateTime(arguments.timeout) Gte local.items[local.i].timeout) {
						StructDelete(local.items, local.i);
					}
				}
			}
			return local.items;
		</cfscript>
	</cffunction>

	<cffunction name="stopBy" output="false">
		<cfscript>
			var local = {};
			if (Not application.settings.demo) {
				local.items = filter(argumentCollection = arguments);
				for (local.i in local.items) {
					variables.sessTracker.stop(local.i);
				}
			}
		</cfscript>
	</cffunction>

	<cffunction name="refreshBy" output="false">
		<cfscript>
			var local = {};
			if (Not application.settings.demo) {
				local.items = filter(argumentCollection = arguments);
				for (local.i in local.items) {
					variables.sessTracker.refresh(local.i);
				}
			}
		</cfscript>
	</cffunction>
</cfcomponent>