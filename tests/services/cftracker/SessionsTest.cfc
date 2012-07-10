<cfcomponent extends="mxunit.framework.TestCase" mxunit:decorators="cftracker.tests.mxunit.EngineTestDecorator" output="false">
	
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
	
	/**
	* @excludeEngine RAILO
	*/
	function getInfoAdobe(){
		makePublic( CUT, "getInfoAdobe" );
		var result = CUT.getInfoAdobe();
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "Adobe" ) );
		assertTrue( StructKeyExists( result.Adobe, appname ) );
		assertIsStruct( result.Adobe[ appname ] );
		assertTrue( StructCount( result.Adobe[ appname] ) > 0 );
	}
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getInfoRailo(){
		makePublic( CUT, "getInfoRailo" );
		var result = CUT.getInfoRailo();
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "Railo" ) );
		assertTrue( StructKeyExists( result.Railo, appname ) );
		assertIsStruct( result.Railo[ appname ] );
		assertTrue( StructCount( result.Railo[ appname ] ) > 0 );
		
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
	
	/**
	* @excludeEngine RAILO
	*/
	function getCountAdobe(){
		makePublic( CUT, "getCountAdobe" );
		var result = CUT.getCountAdobe();
		assertTrue( result > 0 );
		var result = CUT.getCountAdobe( appname );
		assertTrue( result > 0 );
		var result = CUT.getCountAdobe( 'pkmasdhasdkjah' );
		assertTrue( result == 0 );
	}
	
	/**
	* @excludeEngine RAILO
	*/
	function getScopeAdobe(){
		makePublic( CUT, "getScopeAdobe" );
		// Session Keys are "sometimes" case sensitive
		var sessionid = session.getSessionId();
		var result = CUT.getScopeAdobe( sessid=sessionid );
		assertIsStruct( result );
		assertTrue( structKeyExists( result, "cfid" ) );
		assertTrue( structKeyExists( result, "cftoken" ) );
		assertTrue( structKeyExists( result, "sessionid" ) );
		assertTrue( structKeyExists( result, "urltoken" ) );
	}
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getScopeRailo(){
		makePublic( CUT, "getScopeRailo" );
		// Session Keys are "sometimes" case sensitive
		var sessionid = session.getSessionId();
		var result = CUT.getScopeRailo( sessid=sessionid );
		assertIsStruct( result );
		assertTrue( structKeyExists( result, "cfid" ) );
		assertTrue( structKeyExists( result, "cftoken" ) );
		assertTrue( structKeyExists( result, "sessionid" ) );
		assertTrue( structKeyExists( result, "urltoken" ) );
	}
	
	
	function touch(){
		// Session Keys are "sometimes" case sensitive
		var sessionid = session.getSessionId();
		var result = CUT.touch( sessid=sessionid );
		assertTrue( result );
		result = CUT.touch( sessid='abc123' );
		assertFalse( result );
	}

	function stop(){
		// Session Keys are "sometimes" case sensitive
		var sessionid = session.getSessionId();
		var result = CUT.stop( sessid=sessionid );
		debug( result );
		assertTrue( IsBoolean( result ) );
		assertTrue( result );
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