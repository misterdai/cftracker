<cfcomponent hint="CfTracker" extends="railo-context.admin.plugin.Plugin">
	<cfset variables.fw1 = CreateObject('component', 'FakeApplication').init() />
	
	<cffunction name="init" hint="this function will be called to initalize">
		<cfargument name="lang" type="struct">
		<cfargument name="app" type="struct">
	</cffunction>

	<cffunction name="overview" output="true" hint="this is the main display action">
		<cfargument name="lang" type="struct">
		<cfargument name="app" type="struct">
		<cfargument name="req" type="struct">
		<cfscript>
			variables.fw1.configApplication();
			url.action = url.pluginAction;
			if (Not StructKeyExists(url, 'fw1action')) {
				url.action = 'main.default';
			} else {
				url.action = url.fw1action;
			}
			variables.fw1.onRequestStart('');
			variables.fw1.onRequest('');
		</cfscript>
	</cffunction>
</cfcomponent>