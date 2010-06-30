<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfargument name="fw" />
		<cfset variables.fw = arguments.fw />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="default" output="false"> 
		<cfargument name="rc" />
		<cfset variables.fw.service('applications.getApps', 'apps', request.context, true) />
	</cffunction>

	<cffunction name="application" output="false">
		<cfargument name="rc" />
		<cfset variables.fw.service('applications.getApps', 'apps', request.context, true) />
		<cfset variables.fw.service('applications.getinfo', 'appinfo', request.context, true) />
	</cffunction>

	<cffunction name="getScope" output="false">
		<cfargument name="rc" />
	</cffunction>
	
	<cffunction name="stop" output="false">
		<cfargument name="rc" />
		<cfscript>
			var local = {};
			local.data = getPageContext().getRequest().getParameterMap();
			if (StructKeyExists(local.data, 'sessions')) {
				rc.sessions = local.data['sessions'];
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="endstop" output="false">
		<cfargument name="rc" />
		<cfscript>
			if (StructKeyExists(rc, 'app') And Len(rc.app) Gt 0) {
				variables.fw.redirect('sessions.application?name=' & rc.app);
			} else {
				variables.fw.redirect('sessions.default');
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="refresh" output="false">
		<cfargument name="rc" />
		<cfset variables.stop(arguments.rc) />
	</cffunction>
	
	<cffunction name="endrefresh" output="false">
		<cfargument name="rc" />
		<cfset variables.endstop(arguments.rc) />
	</cffunction>

	<cffunction name="endStopBy" output="false">
		<cfargument name="rc" />
		<cfset variables.endstop(arguments.rc) />
	</cffunction>

	<cffunction name="endRefreshBy" output="false">
		<cfargument name="rc" />
		<cfset variables.endstop(arguments.rc) />
	</cffunction>
</cfcomponent>