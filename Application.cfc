<cfcomponent extends="framework"><cfscript>
	this.name = 'CfTracker-App.20100929';
	this.applicationTimeout = CreateTimeSpan(1, 0, 0, 0);
	this.sessionManagement = true;
	this.sessionTimeout = CreateTimeSpan(0, 0, 30, 0);
	this.base = GetDirectoryFromPath(GetCurrentTemplatePath());
	this.mappings['/javaloader'] = this.base & 'libraries/javaloader';
	this.mappings['/ValidateThis'] = this.base & 'libraries/ValidateThis';
	this.customTagPaths = this.base & 'libraries/tags/forms/cfUniForm';
	
	this.railoPlugin = false;
	this.assetBegin = '';
	this.assetEnd = '';

	//variables.framework = {reloadApplicationOnEveryRequest = true};
</cfscript>

<cffunction name="upgradeSettings" output="false">
	<cfargument name="current" type="struct" required="true" />
	<cfargument name="default" type="struct" required="true" />
	<cfscript>
		var lc = {};
		for (lc.key in arguments.current) {
			if (Not StructKeyExists(arguments.default, lc.key)) {
				// Key no longer exists in new version
				StructDelete(arguments.current, lc.key);
			} else if (IsStruct(arguments.current[lc.key])) {
				arguments.current[lc.key] = upgradeSettings(arguments.current[lc.key], arguments.default[lc.key]);
				StructDelete(arguments.default, lc.key);
			} else {
				StructDelete(arguments.default, lc.key);
			}
		}
		for (lc.key in arguments.default) {
			if (Not StructKeyExists(arguments.current, lc.key)) {
				arguments.current[lc.key] = Duplicate(arguments.default[lc.key]);
			}
		}
		return arguments.current;
	</cfscript>
</cffunction>

<cffunction name="setupApplication" output="false">
	<cfscript>
		var settings = {};
		var temp = {};
		var lc = {};
		var cftracker = {};
		lc.oldConfig = this.base & 'config.cfm';
		application.config = this.base & 'config.json.cfm';
	</cfscript>
	<cfset application.base = this.base />
	<cfset application.railoplugin = this.railoplugin />
	<cfset application.cfcBase = ListChangeDelims(GetDirectoryFromPath(cgi.script_name), '.', '/') & '.' />
	<!--- Unique ID for Java Loader, same as in the monitor task application.cfc, so we only have one instance --->
	<cfset application.uuid = 'Q2ZUcmFja2VyIChodHRwOi8vd3d3LmNmdHJhY2tlci5uZXQp' />
	<!--- Setup JavaLoader to use the rrd4j library --->
	<cfset lc.paths = [
		GetDirectoryFromPath(GetCurrentTemplatePath()) & 'libraries/java/rrd4j-2.0.5.jar',
		GetDirectoryFromPath(GetCurrentTemplatePath()) & 'libraries/java/sqlitejdbc-v056.jar'
	] />
	<cfif NOT StructKeyExists(server, application.uuid)>
		<cflock name="CfTracker.server.JavaLoader" throwontimeout="true" timeout="60">
			<cfif Not StructKeyExists(server, application.uuid)>
				<cfset server[application.uuid] = CreateObject("component", "javaloader.JavaLoader").init(lc.paths) />
			</cfif>
		</cflock>
	</cfif>
	<cftry>
		<!--- Setup schedule task, MUST happen after JavaLoader does it's job --->
		<cfif application.railoPlugin>
			<cfset lc.rp = 'plugin/CfTracker/' />
		<cfelse>
			<cfset lc.rp = '' />
		</cfif>
		<cfschedule action="update" task="CfTracker" interval="300" operation="HTTPRequest" startDate="#Now()#" startTime="00:00:00" endTime="23:59:59" url="http://#cgi.http_host##GetContextRoot()##GetDirectoryFromPath(cgi.script_name)##lc.rp#tools/monitor/task.cfm" requestTimeout="240" />
		<cfif Not FileExists(this.base & 'tools/monitor/rrd/garbage.rrd')>
			<cfschedule action="run" task="CfTracker" />
		</cfif>
		<cfcatch type="any">
		</cfcatch>
	</cftry>
	<cfif FileExists(lc.oldConfig)>
		<!--- Old config present, convert it --->
		<cfinclude template="./config.cfm" />
		<cfset FileDelete(lc.oldConfig) />
		<cfif FileExists(application.config)>
			<cfset FileDelete(application.config) />
		</cfif>
		<cfset FileWrite(application.config, '<cfsavecontent variable="settings">#SerializeJson(settings)#</cfsavecontent>') />
	<cfelseif FileExists(application.config)>
		<!--- Config present, load it --->
		<cfinclude template="./config.json.cfm" />
		<cfset settings = DeserializeJson(settings) />
	<cfelse>
		<!--- No config present, use the default --->
		<cfinclude template="./config.default.cfm" />
		<cfset FileWrite(application.config, '<cfsavecontent variable="settings">#SerializeJson(settings)#</cfsavecontent>') />
	</cfif>

	<cfinclude template="./cftracker.cfm" />
	<cfset application.cftracker = cftracker />
	<cfif application.railoPlugin>
		<!--- Correct cfuniform config for Railo Plugin --->
		<cfloop collection="#application.cftracker.uniform#" item="lc.item">
			<cfset application.cftracker.uniform[lc.item] = this.assetBegin & application.cftracker.uniform[lc.item] & this.assetEnd />
		</cfloop>
	</cfif>
	<cfset application.settings = settings />
	<cfif Not StructKeyExists(application.settings, 'version') Or application.settings.version Lt application.cftracker.config.version>
		<cfinclude template="./config.default.cfm" />
		<cfset application.settings = upgradeSettings(application.settings, settings) />
		<cfset FileWrite(application.config, '<cfsavecontent variable="settings">#SerializeJson(application.settings)#</cfsavecontent>') />
	</cfif>
	<cfset application.loginAttempts = 0 />
	<cfset application.loginDate = Now() />
	<cfset application.server = ListFirst(server.coldfusion.productName, ' ') />
	<cfif application.settings.demo>
		<cfset application.cfcDemo = CreateObject('component', 'services.cftracker.demo.demo').init() />
		<cfset application.cfcDemo.reset() />
	</cfif>
	<cfset application.cfcGraphs = CreateObject('component', 'tools.monitor.graphs').init(application.base) />
	<cfset lc.validateThisConfig = {
		definitionPath = application.base & "services/validation/",
		JSRoot = "assets/js/",
		extraRuleValidatorComponentPaths = application.cfcBase & "services.validation.server",
		extraClientScriptWriterComponentPaths = application.cfcBase & "services.validation.client"
	} />
	<cfset application.ValidateThis = createObject("component","ValidateThis.ValidateThis").init(lc.ValidateThisConfig) />
	<cfif application.railoplugin>
		<cfset application.settings.security.password = session['password' & request.adminType] />
	</cfif>
</cffunction>

<cffunction name="siPrefix" output="false" returntype="string">
	<cfargument name="value" required="true" type="numeric" />
	<cfargument name="base" required="false" type="numeric" default="1000" />
	<cfargument name="nonstandard" required="false" type="boolean" default="true" />
	<cfscript>
		var lc = {};
		if (arguments.value Eq 0) {
			return '0 ';
		}
		lc.prefixes = [];
		lc.scale = ['Y', 'Z', 'E', 'P', 'T', 'G', 'M', 'K', '', 'm', 'µ', 'n' ,'p', 'f', 'a' ,'z', 'y'];
		lc.power = 8;
		if (arguments.nonstandard) {
			ArrayPrepend(lc.scale, 'X');
			ArrayPrepend(lc.scale, 'W');
			ArrayPrepend(lc.scale, 'V');
			ArrayPrepend(lc.scale, 'U');
			ArrayAppend(lc.scale, 'x');
			ArrayAppend(lc.scale, 'w');
			ArrayAppend(lc.scale, 'v');
			ArrayAppend(lc.scale, 'u');
			lc.power = 12;
		}
		lc.sLen = ArrayLen(lc.scale);
		lc.finished = false;
		lc.output = '';
		for (lc.i = 1; lc.i Lte lc.sLen And Len(lc.output) Eq 0; lc.i++) {
			lc.pow = arguments.base ^ lc.power;
			if (arguments.value Gte lc.pow) {
				lc.output = NumberFormat(arguments.value / lc.pow, '.00') & ' ' & lc.scale[lc.i];
				if (arguments.base Eq '1024' And lc.pow Neq 1) {
					lc.output &= 'i';
				}
			}
			lc.power--;
		}
		if (Len(lc.output) Eq 0) {
			lc.output = arguments.value / lc.pow & ' ' & lc.scale[lc.sLen];
			if (arguments.base Eq '1024' And lc.pow Neq 1) {
				lc.output &= 'i';
			}
		}
		return lc.output;
	</cfscript>
</cffunction>

<cfscript>
	function setupSession() {
		if (Not application.railoPlugin) {
			super.controller( 'security.session' );
		}
	}

	function setupRequest() {
		if (Not application.railoPlugin) {
			request.adminType = 'server';
			super.controller('security.authorize');
		}
		if (application.settings.demo) {
			application.cfcDemo.tick();
		}
		application.cfcGraphs.regenerate();
	}
</cfscript></cfcomponent>