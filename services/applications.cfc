<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfscript>
			var lc = {};
			lc.cfcPath = 'cftracker.';
			if (application.settings.demo) {
				lc.cfcPath &= 'demo.';
			}
			variables.appTracker = CreateObject('component', lc.cfcPath & 'applications').init(application.settings.security.password);
			variables.sessTracker = CreateObject('component', lc.cfcPath & 'sessions').init(application.settings.security.password);
		</cfscript>
	</cffunction>

	<cffunction name="default" output="false">
		<cfscript>
			var lc = {};
			lc.apps = {};
			lc.apps = variables.appTracker.getAppsInfo();
			return lc.apps;
		</cfscript> 
	</cffunction>
	
	<cffunction name="getInfo" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="wc" type="string" required="true" />
		<cfreturn variables.appTracker.getInfo(arguments.name, arguments.wc) />
	</cffunction>
	
	<cffunction name="getApps" output="false">
		<cfreturn variables.appTracker.getApps() />
	</cffunction>
	
	<cffunction name="getScope" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="wc" type="string" required="true" />
		<cfreturn variables.appTracker.getScope(arguments.name, arguments.wc) />
	</cffunction>

	<cffunction name="getSettings" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfreturn variables.appTracker.getSettings(arguments.name) />
	</cffunction>

	<cffunction name="stopsessions" output="false">
		<cfargument name="apps" />
		<cfset var lc = {} />
		<cfloop array="#arguments.apps#" index="lc.a">
			<cfset lc.wc = ListFirst(lc.a, Chr(9)) />
			<cfset lc.app = ListDeleteAt(lc.a, 1, Chr(9)) />
			<cfset variables.sessTracker.stopByApp(lc.app, lc.wc) />
		</cfloop>
	</cffunction>

	<cffunction name="stopboth" output="false">
		<cfargument name="apps" />
		<cfset var lc = {} />
		<cfloop array="#arguments.apps#" index="lc.a">
			<cfset lc.wc = ListFirst(lc.a, Chr(9)) />
			<cfset lc.app = ListDeleteAt(lc.a, 1, Chr(9)) />
			<cfset variables.appTracker.stop(lc.app, lc.wc) />
			<cfset variables.sessTracker.stopByApp(lc.app, lc.wc) />
		</cfloop>
	</cffunction>
	
	<cffunction name="stop" output="false">
		<cfargument name="apps" />
		<cfset var lc = {} />
		<cfloop array="#arguments.apps#" index="lc.a">
			<cfset lc.wc = ListFirst(lc.a, Chr(9)) />
			<cfset lc.app = ListDeleteAt(lc.a, 1, Chr(9)) />
			<cfset variables.appTracker.stop(lc.app, lc.wc) />
		</cfloop>
	</cffunction>

	<cffunction name="restart" output="false">
		<cfargument name="apps" />
		<cfset var lc = {} />
		<cfloop array="#arguments.apps#" index="lc.a">
			<cfset lc.wc = ListFirst(lc.a, Chr(9)) />
			<cfset lc.app = ListDeleteAt(lc.a, 1, Chr(9)) />
			<cfset variables.appTracker.restart(lc.app, lc.wc) />
		</cfloop>
	</cffunction>

	<cffunction name="refresh" output="false">
		<cfargument name="apps" />
		<cfset var lc = {} />
		<cfloop array="#arguments.apps#" index="lc.a">
			<cfset lc.wc = ListFirst(lc.a, Chr(9)) />
			<cfset lc.app = ListDeleteAt(lc.a, 1, Chr(9)) />
			<cfset variables.appTracker.touch(lc.app, lc.wc) />
		</cfloop>
	</cffunction>
</cfcomponent>