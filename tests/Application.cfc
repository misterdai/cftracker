<cfcomponent output="false">
	
	<cfscript>
	this.root = GetDirectoryFromPath( GetCurrentTemplatePath() );
	this.name = "cftrackertests";
	this.sessionManagement = true;
	this.sessionTimeout = CreateTimeSpan(0, 0, 30, 0);
	this.mappings["/services"] = this.root & "/services";
	
	function onRequestStart(){
		// put some useful keys in the application scope to use in tests
		lock scope="Application" timeout="10" {
			if( IsNull( application.metadata ) ) { 
				application.metadata = this;
			}
		}
	}

	</cfscript>
	
</cfcomponent>