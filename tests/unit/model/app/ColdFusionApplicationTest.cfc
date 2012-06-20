<cfcomponent extends="mxunit.framework.TestCase" output="false">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests
	---------------------------------------------------------------
	*/
	function getInfo(){
		result = CUT.getInfo();
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
	
	function getScope(){
		result = CUT.getScope();
		debug( result );
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "applicationname" ) );
		assertTrue( StructKeyExists( result, "testkey" ) );
	}
	
	function getScopeValues(){
		result = CUT.getScopeValues();
		debug(result);
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "applicationname" ) );
	}
	
	function getSettings(){
		result = CUT.getSettings();
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "name" ) );
		assertTrue( StructKeyExists( result, "sessiontimeout" ) );
		assertTrue( StructKeyExists( result, "sessionmanagement" ) );
		assertTrue( StructKeyExists( result, "applicationtimeout" ) );
	}
	
	function getSessionCount(){
		result = CUT.getSessionCount();
		assertTrue( isNumeric( result ) );
		assertTrue( result gt 0 );
	}
	
	function getExpired(){
		result = CUT.getExpired();
		debug(result);
		assertFalse( result );
	}
	
	function getIdlePercent(){
		result = CUT.getIdlePercent();
		assertTrue( IsNumeric( result ) );
	}
	
	function getIdleTimeout(){
		result = CUT.getIdleTimeout();
		assertTrue( IsDate( result ) );
	}
	
	function getLastAccessed(){
		result = CUT.getLastAccessed();
		assertTrue( IsDate( result ) );
	}
	
	function touch(){
		result = CUT.touch();
		assertTrue( IsBoolean( result ) );	
	}
	
	function stop(){
		result = CUT.stop();
		assertTrue( IsBoolean( result ) );	
	}
	
	
	/*
	---------------------------------------------------------------
	MXUnit helper methods
	---------------------------------------------------------------
	*/
	function setUp(){
		thisApplicationName = request.appname;
		
		application.testkey = "foo";
		
		CUT = createObject( "component","cftracker.model.app.ColdFusionApplication" ).init( thisApplicationName );
	}
	function tearDown(){
	}
	</cfscript>
</cfcomponent>