<cfcomponent extends="mxunit.framework.TestCase" output="false">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests
	---------------------------------------------------------------
	Note: Only testing methods called from the service
	---------------------------------------------------------------
	*/
	function getAllSessions(){
		var result = CUT.getInfo(); // returns a struct of all sessions
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "Adobe" ) );
		assertTrue( StructKeyExists( result.Adobe, "cftrackertests" ) );
		assertIsStruct( result.Adobe.cftrackertests );
		assertTrue( StructCount( result.Adobe.cftrackertests ) > 0 );
		var sessId = StructKeyArray( result.Adobe.cftrackertests );
		assertTrue( StructKeyExists( result.Adobe.cftrackertests, sessId[1] ) );
		assertTrue( StructKeyExists( result.Adobe.cftrackertests[sessId[1]], 'exists' ) );
		assertTrue( result.Adobe.cftrackertests[sessId[1]].exists );
	}
	
	function getInfoAdobe(){
		makePublic( CUT, "getInfoAdobe" );
		var result = CUT.getInfoAdobe();
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "Adobe" ) );
		assertTrue( StructKeyExists( result.Adobe, "cftrackertests" ) );
		assertIsStruct( result.Adobe.cftrackertests );
		assertTrue( StructCount( result.Adobe.cftrackertests ) > 0 );
	}
	
	function getScope(){
		// Session Keys are "sometimes" case sensitive
		var sessionid = session.getSessionId();
		var result = CUT.getScope( sessid=sessionid );
		assertIsStruct( result );
		assertTrue( structKeyExists( result, "cfid" ) );
		assertTrue( structKeyExists( result, "cftoken" ) );
		assertTrue( structKeyExists( result, "sessionid" ) );
		assertTrue( structKeyExists( result, "urltoken" ) );
	}
	
	function getScopeAdobe(){
		makePublic( CUT, "getScopeAdobe" );
		// Session Keys are "sometimes" case sensitive
		var sessionid = session.getSessionId();
		var result = CUT.getScopeAdobe( sessid=sessionid );
		debug( result );
		assertIsStruct( result );
		assertTrue( structKeyExists( result, "cfid" ) );
		assertTrue( structKeyExists( result, "cftoken" ) );
		assertTrue( structKeyExists( result, "sessionid" ) );
		assertTrue( structKeyExists( result, "urltoken" ) );
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
		CUT = createObject("component","cftracker.services.cftracker.sessions").init();
		appname = application.metadata.name;
	}
	
	function tearDown(){
	}
	
	function afterTests(){
		StructDelete( application, key );
	}
	</cfscript>
	
</cfcomponent>