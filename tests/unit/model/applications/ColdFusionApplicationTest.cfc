<cfcomponent extends="mxunit.framework.TestCase" output="false">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests
	---------------------------------------------------------------
	*/
	function getInfo(){
		var result = CUT.getInfo(); // gets information about the application's life
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
		var result = CUT.getScope(); // gets the application scope
		debug(result);
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "applicationname" ) );
		assertTrue( StructKeyExists( result, key ) );
	}
	
	/*
	function getScopeValues(){
		var result = CUT.getScopeValues();
		debug(result);
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "applicationname" ) );
	}
	*/
	
	function getSettings(){
		var result = CUT.getSettings(); // gets the application settings
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "name" ) );
		assertTrue( StructKeyExists( result, "sessiontimeout" ) );
		assertTrue( StructKeyExists( result, "sessionmanagement" ) );
		assertTrue( StructKeyExists( result, "applicationtimeout" ) );
	}
	
	function getSessionCount(){
		var result = CUT.getSessionCount();
		assertTrue( isNumeric( result ) );
		assertTrue( result gt 0 );
	}
	
	function getExpired(){
		var result = CUT.getExpired();
		debug(result);
		assertFalse( result );
	}
	
	function getIdlePercent(){
		var result = CUT.getIdlePercent();
		assertTrue( IsNumeric( result ) );
	}
	
	function getIdleTimeout(){
		var result = CUT.getIdleTimeout();
		assertTrue( IsDate( result ) );
	}
	
	function getLastAccessed(){
		var result = CUT.getLastAccessed();
		assertTrue( IsDate( result ) );
	}
	
	function touch(){
		// Session Keys are "sometimes" case sensitive
		var sessionid = session.getSessionId();
		var result = CUT.touch( sessId=sessionid );
		assertTrue( result );
		result = CUT.touch( sessId='abc123' );
		assertFalse( result );
	}

	function stop(){
		// Session Keys are "sometimes" case sensitive
		var sessionid = session.getSessionId();
		var result = CUT.stop( sessid=sessionid );
		assertTrue( IsBoolean( result ) );
	}
	
	function getSessions(){ 
		var result = CUT.getSessions(); // gets all sessions for this application
		debug( result );
		assertIsStruct( result );	
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
		thisApplicationName = application.metadata.name;
		CUT = createObject( "component","cftracker.model.applications.ColdFusionApplication" ).init( thisApplicationName );
	}
	
	function tearDown(){
	}
	
	function afterTests(){
		StructDelete( application, key );
	}
	</cfscript>
</cfcomponent>