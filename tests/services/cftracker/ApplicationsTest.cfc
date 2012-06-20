<cfcomponent extends="mxunit.framework.TestCase" output="false">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests
	---------------------------------------------------------------
	*/
	function getScopeKeys(){
		result = CUT.getScopeKeys( appname );
		assertIsArray( result );
		assertTrue( ArrayFindNoCase( result, key ) );
	}
	
	function getExpired(){
		result = CUT.getExpired( appname );
		assertFalse( result );
	}
	
	function getIdlePercent(){
		result = CUT.getIdlePercent( appname );
		assertTrue( IsNumeric( result ) );
	}
	
	function getIdleTimeout(){
		result = CUT.getIdleTimeout( appname );
		assertTrue( IsDate( result ) );
	}
	
	function getInfoAdobe(){
		makePublic( CUT, "getInfoAdobe" );
		result = CUT.getInfoAdobe( appname );
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
	
	function getLastAccessed(){
		result = CUT.getLastAccessed( appname );
		assertTrue( IsDate( result ) );
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
		CUT = createObject("component","cftracker.services.cftracker.applications").init();
		appname = request.appname;
	}
	
	function tearDown(){
	}
	
	function afterTests(){
		StructDelete( application, key );
	}
	</cfscript>
	
</cfcomponent>