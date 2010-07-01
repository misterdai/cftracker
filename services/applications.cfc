<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfset variables.appTracker = CreateObject('component', 'cftracker.applications').init() />
	</cffunction>

	<cffunction name="default" output="false">
		<cfscript>
			var local = {};
			local.apps = variables.appTracker.getAppsInfo();
			return local.apps;
		</cfscript> 
	</cffunction>
	
	<cffunction name="getInfo" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfreturn variables.appTracker.getInfo(arguments.name) />
	</cffunction>
	
	<cffunction name="getApps" output="false">
		<cfreturn variables.appTracker.getApps() />
	</cffunction>
	
	<cffunction name="getScope" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfreturn variables.appTracker.getScope(arguments.name) />
	</cffunction>

	<cffunction name="getSettings" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfreturn variables.appTracker.getSettings(arguments.name) />
	</cffunction>
	
	<cffunction name="stop" output="false">
		<cfargument name="apps" />
		<cfset var local = {} />
		<cfloop array="#arguments.apps#" index="local.a">
			<cfset variables.appTracker.stop(local.a) />
		</cfloop>
	</cffunction>

	<cffunction name="restart" output="false">
		<cfargument name="apps" />
		<cfset var local = {} />
		<cfloop array="#arguments.apps#" index="local.a">
			<cfset variables.appTracker.restart(local.a) />
		</cfloop>
	</cffunction>

	<cffunction name="refresh" output="false">
		<cfargument name="apps" />
		<cfset var local = {} />
		<cfloop array="#arguments.apps#" index="local.a">
			<cfset variables.appTracker.touch(local.a) />
		</cfloop>
	</cffunction>

	<cffunction name="graph" output="false">
		<cfscript>
			var local = {};
			local.apps = variables.appTracker.getApps();
			local.count = ArrayLen(local.apps);
			local.data = [];
			for (local.a = 1; local.a Lte local.count; local.a++) {
				local.info.label = local.apps[local.a];
				local.info.description = local.apps[local.a];
				local.info.data = [GetTickCount(), variables.appTracker.getSessionCount(local.apps[local.a]).sessionCount];
				ArrayAppend(local.data, local.info);
			}
			return local.data;
		</cfscript>
	</cffunction>
</cfcomponent>