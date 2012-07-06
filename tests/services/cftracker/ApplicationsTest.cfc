<cfcomponent extends="mxunit.framework.TestCase" mxunit:decorators="cftracker.tests.mxunit.EngineTestDecorator" output="false">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests
	---------------------------------------------------------------
	*/
	function getScopeKeys(){
		var result = CUT.getScopeKeys( appname );
		assertIsArray( result );
		assertTrue( ArrayFindNoCase( result, key ) );
	}
	
	/**
	* @excludeEngine RAILO
	*/
	function getScopeAdobe(){
		makePublic( CUT, "getScopeAdobe" );
		var result = CUT.getScopeAdobe( appname );
		debug( result );
		assertIsStruct( result );
	}

	/**
	* @excludeEngine RAILO
	*/
	function getSettingsAdobe(){
		makePublic( CUT, "getSettingsAdobe" );
		var result = CUT.getSettingsAdobe( appname );
		debug( result );
		assertIsStruct( result );
	}

	/**
	* @excludeEngine COLDFUSION
	*/
	function getScopeRailo(){
		makePublic( CUT, "getScopeRailo" );
		var result = CUT.getScopeRailo( appname, wc );
		debug( result );
		assertIsStruct( result );
	}
	
	function getExpired(){
		var result = CUT.getExpired( appname );
		assertFalse( result );
	}
	
	function getIdlePercent(){
		var result = CUT.getIdlePercent( appname );
		assertTrue( IsNumeric( result ) );
	}
	
	function getIdleTimeout(){
		var result = CUT.getIdleTimeout( appname );
		assertTrue( IsDate( result ) );
	}
	
	function getLastAccessed(){
		var result = CUT.getLastAccessed( appname );
		assertTrue( IsDate( result ) );
	}
	
	/**
	* @excludeEngine RAILO
	*/
	function getInfoAdobe(){
		makePublic( CUT, "getInfoAdobe" );
		var result = CUT.getInfoAdobe( appname );
		debug(result);
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "EXISTS" ) );
		assertTrue( StructKeyExists( result, "IDLEPERCENT" ) );
		assertTrue( StructKeyExists( result, "EXPIRED" ) );
		assertTrue( StructKeyExists( result, "IDLETIMEOUT" ) );
		assertTrue( StructKeyExists( result, "ISINITED" ) );
		assertTrue( StructKeyExists( result, "LASTACCESSED" ) );
		assertTrue( StructKeyExists( result, "TIMEALIVE" ) );
	}
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getInfoRailo(){
		makePublic( CUT, "getInfoRailo" );
		var result = CUT.getInfoRailo( appname, wc );
		debug(result);
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "EXISTS" ) );
		assertTrue( StructKeyExists( result, "IDLEPERCENT" ) );
		assertTrue( StructKeyExists( result, "EXPIRED" ) );
		assertTrue( StructKeyExists( result, "IDLETIMEOUT" ) );
		assertTrue( StructKeyExists( result, "LASTACCESSED" ) );
	}
	
	/*
	---------------------------------------------------------------
	MXUnit helper methods
	---------------------------------------------------------------
	*/
	function beforeTests(){
		key = "getScopeKeys_" & RandRange(1000,9999);
		application[ key ] = Now();
	}
	
	function setUp(){
		var engine = UCase( ListFirst( server.coldfusion.productname, " " ) );
		if (engine == "RAILO") {
			var config = { password='', adminType='web' };
			CUT = createObject("component","cftracker.services.cftracker.applications").init( argumentCollection=config );
			wc = server.coldfusion.rootdir; // Railo web context path for example 'D:\webserver\htdocs'
		}
		else{
			CUT = createObject("component","cftracker.services.cftracker.applications").init();
		}
		appname = application.metadata.name;
	}
	
	function tearDown(){
	}
	
	function afterTests(){
		StructDelete( application, key );
	}
	</cfscript>
	
</cfcomponent>