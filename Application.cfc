<cfcomponent extends="org.corfield.framework"><cfscript>
	this.name = 'cftracker';
	this.sessionManagement = true;
	this.sessionTimeout = CreateTimeSpan(0, 0, 30, 0);
	
	function customizeViewOrLayoutPath( pathInfo, type, fullPath ) {
		var defaultPath = '#type#s/#pathInfo.path#.cfm';
		var skin = 'default';
		request.cfideAdminPath = '../CFIDE/administrator/';
		// Please enter your the path to cfide/administrator if CFTracker is located
		// elsewhere and you are using URL rewriting to put it in the admin
		if (ReFindNoCase('^/cfide/administrator/', cgi.script_name)) {
			skin = 'cfide';
		}
		
		if (FileExists(ExpandPath(request.subsystembase & '/skins/' & skin & '/' & defaultPath))) {
			return request.subsystembase & 'skins/' & skin & '/' & defaultPath;
		} else {
			return request.subsystembase & 'skins/default/' & defaultPath;
		}
	}
</cfscript></cfcomponent>