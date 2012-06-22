<cfcomponent extends="mxunit.framework.TestCase" output="false">
	
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
	
	function getScopeAdobe(){
		makePublic( CUT, "getScopeAdobe" );
		var result = CUT.getScopeAdobe( appname );
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
	
	/* private methods */
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
		appname = application.metadata.name;
	}
	
	function tearDown(){
	}
	
	function afterTests(){
		StructDelete( application, key );
	}
	</cfscript>
	
</cfcomponent>