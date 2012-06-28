<cfcomponent extends="CFMLEngine" output="false">
	<cfscript>
	
	/* -------------------------- CONTRUCTOR -------------------------- */
	
	RailoEngine function init(){
		super.init();
		return this;
	}
	
	/* -------------------------- PUBLIC -------------------------- */
	
	string function getFullProductname(){
		return server.coldfusion.productname & " " & server.railo.version & " " & server.railo.versionName;
	}
	
	numeric function getMajorVersion(){
		return Val( ListFirst( getVersion(), "." ) );
	}
		
	string function getVersion(){
		return server.railo.version;
	}
	
	string function getServlet(){
		return server.railo.servlet;
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