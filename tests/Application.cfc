<cfcomponent output="false">
	
	<cfscript>
	this.root = GetDirectoryFromPath( GetCurrentTemplatePath() );
	this.name = "cftrackertests";
	this.sessionManagement = true;
	this.sessionTimeout = CreateTimeSpan(0, 0, 30, 0);
	this.mappings["/services"] = this.root & "/services";
	
	boolean function onRequestStart(){
		// put some useful keys in the request scope to use in tests
		request.appname = this.name;
		return true;
	}
	
	</cfscript>
	
</cfcomponent>b