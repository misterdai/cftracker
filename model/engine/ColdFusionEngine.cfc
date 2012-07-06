<cfcomponent extends="CFMLEngineDecorator" output="false">
	<cfscript>
	
	/* -------------------------- CONTRUCTOR -------------------------- */
	
	ColdFusionEngine function init( required CFMLEngine ){
		
		super.init( arguments.CFMLEngine );
		
		// ColdFusion specific...
		variables.jAppTracker = CreateObject( 'java', 'coldfusion.runtime.ApplicationScopeTracker' );
		variables.jSessTracker = CreateObject( 'java', 'coldfusion.runtime.SessionTracker' );
		
		var mirror = [];
		variables.class = mirror.getClass().forName( 'coldfusion.runtime.ApplicationScope' );
		return this;
	}
	
	/* -------------------------- PUBLIC -------------------------- */
	
	string function getFullProductname(){
		return server.coldfusion.productname & " " & server.coldfusion.productversion & " " & server.coldfusion.productlevel;
	}
	
	string function getApplicationServer(){
		return server.coldfusion.appserver;
	}
	
	numeric function getMajorVersion(){
		return Val( ListFirst( getVersion(), "," ) );
	}
	
	string function getVersion(){
		return server.coldfusion.productversion;
	}

	/**
	* returns an array of running application names on this server
	**/
	array function getApplicationNames(){
		var result = [];
		var ApplicationKeys = variables.jAppTracker.getApplicationKeys();
		while ( ApplicationKeys.hasMoreElements() ){
			result.add( ApplicationKeys.nextElement() );
		}
		return result;
	}
	
	/* -------------------------- PRIVATE -------------------------- */

	
	</cfscript>
</cfcomponent>