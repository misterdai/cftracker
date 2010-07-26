<cfcomponent extends="framework"><cfscript>
	this.name = 'cftracker-20100705';
	this.applicationTimeout = CreateTimeSpan(1, 0, 0, 0);
	this.sessionManagement = true;
	this.sessionTimeout = CreateTimeSpan(0, 0, 30, 0);
</cfscript>

<cffunction name="setupApplication" output="false">
<cffunction name="setupApplication" output="false">
	<cfset var settings = {} />
	<cfset var fake = {} />
	<cfset var temp = {} />
	<cfinclude template="config.cfm" />
	<cfset application.settings = settings />
	<cfset application.loginAttempts = 0 />
	<cfset application.loginDate = Now() />
	<cfif ReFindNoCase('^/cfide/administrator/', cgi.script_name)>
		<cfset application.cfide = true />
	<cfelse>
		<cfset application.cfide = false />
	</cfif>
	<cfset application.server = ListFirst(server.coldfusion.productName, ' ') />
	<cfif application.settings.demo>
		<cfinclude template="demodata.cfm" />
		<cfset application.data = fake />
	</cfif>
</cffunction>

<cffunction name="siPrefix" output="false" returntype="string">
	<cfargument name="value" required="true" type="numeric" />
	<cfargument name="base" required="false" type="numeric" default="1000" />
	<cfargument name="nonstandard" required="false" type="boolean" default="true" />
	<cfscript>
		var local = {};
		if (arguments.value Eq 0) {
			return '0 ';
		}
		local.prefixes = [];
		local.scale = ['Y', 'Z', 'E', 'P', 'T', 'G', 'M', 'K', '', 'm', 'µ', 'n' ,'p', 'f', 'a' ,'z', 'y'];
		local.power = 8;
		if (arguments.nonstandard) {
			ArrayPrepend(local.scale, 'X');
			ArrayPrepend(local.scale, 'W');
			ArrayPrepend(local.scale, 'V');
			ArrayPrepend(local.scale, 'U');
			ArrayAppend(local.scale, 'x');
			ArrayAppend(local.scale, 'w');
			ArrayAppend(local.scale, 'v');
			ArrayAppend(local.scale, 'u');
			local.power = 12;
		}
		local.sLen = ArrayLen(local.scale);
		local.finished = false;
		local.output = '';
		for (local.i = 1; local.i Lte local.sLen And Len(local.output) Eq 0; local.i++) {
			local.pow = arguments.base ^ local.power;
			if (arguments.value Gte local.pow) {
				local.output = NumberFormat(arguments.value / local.pow, '.00') & ' ' & local.scale[local.i];
				if (arguments.base Eq '1024' And local.pow Neq 1) {
					local.output &= 'i';
				}
			}
			local.power--;
		}
		if (Len(local.output) Eq 0) {
			local.output = arguments.value / local.pow & ' ' & local.scale[local.sLen];
			if (arguments.base Eq '1024' And local.pow Neq 1) {
				local.output &= 'i';
			}
		}
		return local.output;
	</cfscript>
</cffunction>

<cfscript>
	function setupSession() {
		if (Not application.cfide) {
			controller( 'security.session' );
		}
	}

	function setupRequest() {
		if (Not application.cfide) {
			controller( 'security.authorize' );
		}
	}
	
	function customizeViewOrLayoutPath( pathInfo, type, fullPath ) {
		var defaultPath = '#type#s/#pathInfo.path#.cfm';
		var skin = 'default';
		request.cfideAdminPath = '../CFIDE/administrator/';
		// Please enter your the path to cfide/administrator if CFTracker is located
		// elsewhere and you are using URL rewriting to put it in the admin
		if (application.cfide) {
			skin = 'cfide';
		}
		
		if (FileExists(ExpandPath(request.subsystembase & '/skins/' & skin & '/' & defaultPath))) {
			return request.subsystembase & 'skins/' & skin & '/' & defaultPath;
		} else {
			return request.subsystembase & 'skins/default/' & defaultPath;
		}
	}
</cfscript></cfcomponent>