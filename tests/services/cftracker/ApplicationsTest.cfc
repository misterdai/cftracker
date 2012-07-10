<cfcomponent extends="mxunit.framework.TestCase" mxunit:decorators="cftracker.tests.mxunit.EngineTestDecorator" output="false">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests
	---------------------------------------------------------------
	*/
	function getAppsInfo(){
		var result = CUT.getAppsInfo(); // returns all applications running on this server 
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "Adobe" ) );
		assertTrue( StructKeyExists( result.Adobe, appname ) );
		assertTrue( StructKeyExists( result.Adobe[ appname ], "exists" ) );
		assertTrue( StructKeyExists( result.Adobe[ appname ], "expired" ) );
		assertTrue( StructKeyExists( result.Adobe[ appname ], "idlepercent" ) );
		assertTrue( StructKeyExists( result.Adobe[ appname ], "idletimeout" ) );
		assertTrue( StructKeyExists( result.Adobe[ appname ], "isinited" ) );
		assertTrue( StructKeyExists( result.Adobe[ appname ], "lastaccessed" ) );
		assertTrue( StructKeyExists( result.Adobe[ appname ], "sessioncount" ) );
		assertTrue( StructKeyExists( result.Adobe[ appname ], "timealive" ) );
	}
	
	function getScopeKeys(){
		var result = CUT.getScopeKeys( appname );
		assertIsArray( result );
		assertTrue( ArrayFindNoCase( result, key ) );
	}
	
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getAppsRailo(){
		makePublic( CUT, "getAppsRailo" );
		var result = CUT.getAppsRailo(); // returns a struct containing an array of application names
		AssertTrue( IsStruct( result ) );
		AssertTrue( IsArray( result.Railo ) );
		AssertTrue( ArrayContains( result.Railo, appname ) );
	}
	
	/**
	* @excludeEngine RAILO
	*/
	function getAppsAdobe(){
		makePublic( CUT, "getAppsAdobe" );
		var result = CUT.getAppsAdobe(); // returns a struct containing an array of application names
		AssertTrue( IsStruct( result ) );
		AssertTrue( IsArray( result.Adobe ) );
		AssertTrue( ArrayContains( result.Adobe, appname ) );
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
	* @excludeEngine COLDFUSION
	*/
	function getScopeRailo(){
		makePublic( CUT, "getScopeRailo" );
		var result = CUT.getScopeRailo( appname, 'Railo' );
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
	* @excludeEngine RAILO
	*/
	function stopAdobe(){
		makePublic( CUT, "stopAdobe" );
		var result = CUT.stopAdobe( appname, 'Adobe' );
		assertTrue( result );
		var result = CUT.stopAdobe( 'fhfgsocmasdasdjh', 'Adobe' );
		assertFalse( result );
	}
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function stopRailo(){
		makePublic( CUT, "stopRailo" );
		var result = CUT.stopRailo( appname, 'Railo' );
		assertTrue( result );
		var result = CUT.stopRailo( 'fhfgsocmasdasdjh', 'Railo' );
		assertFalse( result );
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
	function restartAdobe(){
		makePublic( CUT, "restartAdobe" );
		var result = CUT.restartAdobe( appname, 'Adobe' );
		assertTrue( result );
		var result = CUT.restartAdobe( 'fhfgsocmasdasdjh', 'Adobe' );
		assertFalse( result );
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