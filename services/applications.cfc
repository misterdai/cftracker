<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfscript>
			if (Not application.settings.demo) {
				variables.appTracker = CreateObject('component', 'cftracker.applications').init(application.settings.adminpassword);
			}
		</cfscript>
	</cffunction>

	<cffunction name="default" output="false">
		<cfscript>
			var local = {};
			local.apps = {};
			if (application.settings.demo) {
				for (local.app in application.data.apps) {
					local.apps[local.app] = application.data.apps[local.app].metaData;
				}
			} else {
				local.apps = variables.appTracker.getAppsInfo();
			}
			return local.apps;
		</cfscript> 
	</cffunction>
	
	<cffunction name="getInfo" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfscript>
			if (application.settings.demo) {
				return application.data.apps[arguments.name].metaData;
			} else {
				return variables.appTracker.getInfo(arguments.name);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getApps" output="false">
		<cfscript>
			if (application.settings.demo) {
				return StructKeyArray(application.data.apps);
			} else {
				return variables.appTracker.getApps();
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getScope" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfscript>
			if (application.settings.demo) {
				return application.data.apps[arguments.name].scope;
			} else {
				return variables.appTracker.getScope(arguments.name);
			}
		</cfscript>
	</cffunction>

	<cffunction name="getSettings" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfscript>
			if (application.settings.demo) {
				return application.data.apps[arguments.name].settings;
			} else {
				return variables.appTracker.getSettings(arguments.name);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="stop" output="false">
		<cfargument name="apps" />
		<cfset var local = {} />
		<cfif Not application.settings.demo>
			<cfloop array="#arguments.apps#" index="local.a">
				<cfset variables.appTracker.stop(local.a) />
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="restart" output="false">
		<cfargument name="apps" />
		<cfset var local = {} />
		<cfif Not application.settings.demo>
			<cfloop array="#arguments.apps#" index="local.a">
				<cfset variables.appTracker.restart(local.a) />
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="refresh" output="false">
		<cfargument name="apps" />
		<cfset var local = {} />
		<cfif Not application.settings.demo>
			<cfloop array="#arguments.apps#" index="local.a">
				<cfset variables.appTracker.touch(local.a) />
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="graph" output="false">
		<cfscript>
			var local = {};
			if (application.settings.demo) {
				local.apps = StructKeyArray(application.data.apps);
			} else {
				local.apps = variables.appTracker.getApps();
			}
			local.count = ArrayLen(local.apps);
			local.data = [];
			for (local.a = 1; local.a Lte local.count; local.a++) {
				local.info = {};
				local.info.label = local.apps[local.a];
				local.info.description = local.apps[local.a];
				if (application.settings.demo) {
					local.info.data = [GetTickCount(), application.data.apps[local.apps[local.a]].metadata.sessionCount];
				} else {
					local.info.data = [GetTickCount(), variables.appTracker.getSessionCount(local.apps[local.a]).sessionCount];
				}
				ArrayAppend(local.data, local.info);
			}
			return local.data;
		</cfscript>
	</cffunction>
</cfcomponent>