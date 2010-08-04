<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfscript>
			if (Not application.settings.demo) {
				variables.appTracker = CreateObject('component', 'cftracker.applications').init(application.settings.security.password);
				//variables.sessTracker = CreateObject('component', 'cftracker.sessions').init();
			}
		</cfscript>
	</cffunction>

	<cffunction name="default" output="false">
		<cfscript>
			var lc = {};
			lc.apps = {};
			if (application.settings.demo) {
				for (lc.app in application.data.apps) {
					lc.apps[lc.app] = application.data.apps[lc.app].metaData;
				}
			} else {
				lc.apps = variables.appTracker.getAppsInfo();
			}
			return lc.apps;
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
		<cfargument name="wc" type="string" required="true" />
		<cfscript>
			if (application.settings.demo) {
				return application.data.apps[arguments.name].scope;
			} else {
				return variables.appTracker.getScope(arguments.name, arguments.wc);
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

	<cffunction name="stopsessions" output="false">
		<cfargument name="apps" />
		<cfset var lc = {} />
		<cfif Not application.settings.demo>
			<cfloop array="#arguments.apps#" index="lc.a">
				<cfset lc.wc = ListFirst(lc.a) />
				<cfset lc.app = ListDeleteAt(lc.a, 1) />
				<cfset variables.sessTracker.stopByApp(lc.app, lc.wc) />
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="stopboth" output="false">
		<cfargument name="apps" />
		<cfset var lc = {} />
		<cfif Not application.settings.demo>
			<cfloop array="#arguments.apps#" index="lc.a">
				<cfset lc.wc = ListFirst(lc.a) />
				<cfset lc.app = ListDeleteAt(lc.a, 1) />
				<cfset variables.appTracker.stop(lc.app, lc.wc) />
				<cfset variables.sessTracker.stopByApp(lc.app, lc.wc) />
			</cfloop>
		</cfif>
	</cffunction>
	
	<cffunction name="stop" output="false">
		<cfargument name="apps" />
		<cfset var lc = {} />
		<cfif Not application.settings.demo>
			<cfloop array="#arguments.apps#" index="lc.a">
				<cfset lc.wc = ListFirst(lc.a) />
				<cfset lc.app = ListDeleteAt(lc.a, 1) />
				<cfset variables.appTracker.stop(lc.app, lc.wc) />
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="restart" output="false">
		<cfargument name="apps" />
		<cfset var lc = {} />
		<cfif Not application.settings.demo>
			<cfloop array="#arguments.apps#" index="lc.a">
				<cfset lc.wc = ListFirst(lc.a) />
				<cfset lc.app = ListDeleteAt(lc.a, 1) />
				<cfset variables.appTracker.restart(lc.app, lc.wc) />
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="refresh" output="false">
		<cfargument name="apps" />
		<cfset var lc = {} />
		<cfif Not application.settings.demo>
			<cfloop array="#arguments.apps#" index="lc.a">
				<cfset lc.wc = ListFirst(lc.a) />
				<cfset lc.app = ListDeleteAt(lc.a, 1) />
				<cfset variables.appTracker.touch(lc.app, lc.wc) />
			</cfloop>
		</cfif>
	</cffunction>

</cfcomponent>