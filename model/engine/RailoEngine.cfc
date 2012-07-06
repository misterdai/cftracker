<cfcomponent extends="CFMLEngineDecorator" output="false">
	<cfscript>
	
	/* -------------------------- CONTRUCTOR -------------------------- */
	
	RailoEngine function init( required CFMLEngine, password='' ){
		super.init( arguments.CFMLEngine );
		variables.password = arguments.password;
		return this;
	}
	
	/* -------------------------- PUBLIC -------------------------- */
	
	string function getFullProductname(){
		return server.coldfusion.productname & " " & server.railo.version & " " & server.railo.versionName;
	}
	
	string function getApplicationServer(){
		return server.servlet.name;
	}
	
	numeric function getMajorVersion(){
		return ArrayToList( ArraySlice( ListToArray( getVersion(), "." ), 1, 2 ), "." );
	}
		
	string function getVersion(){
		return server.railo.version;
	}
	
	/**
	* returns an array of running application names on this server
	**/
	array function getApplicationNames(){
		var result = [];
		var hashMap = CreateObject( "java", "java.util.HashMap" );
		var configs = getConfigWebs();
		for ( var config in configs ){
			hashMap.putAll( config.getFactory().getScopeContext().getAllApplicationScopes() );
		}
		return StructKeyArray( hashMap );
	}
	
	/* -------------------------- PRIVATE -------------------------- */
	
	private array function getConfigWebs(){
		if ( variables.password != "" ){
			return getPageContext().getConfig().getConfigServer( variables.password ).getConfigWebs();	
		}
		else {
			return [ getPageContext().getConfig() ];	
		}
	}

	
	</cfscript>
</cfcomponent>