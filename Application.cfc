<cfcomponent extends="framework"><cfscript>
	this.name = 'cftracker-20100705';
	this.sessionManagement = true;
	this.sessionTimeout = CreateTimeSpan(0, 0, 30, 0);
</cfscript>

<cffunction name="setupApplication" output="false">
	<cfset var settings = {} />
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