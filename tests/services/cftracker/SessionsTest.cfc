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
		var sessionid = LCase( session.sessionid ); // note session keys in ACF are lowercase
		var result = CUT.getScope( sessid=sessionid );
		assertIsStruct( result );
		assertTrue( structKeyExists( result, "cfid" ) );
		assertTrue( structKeyExists( result, "cftoken" ) );
		assertTrue( structKeyExists( result, "sessionid" ) );
		assertTrue( structKeyExists( result, "urltoken" ) );
	}
	
	function getScopeAdobe(){
		makePublic( CUT, "getScopeAdobe" );
		var sessionid = LCase( session.sessionid ); // note session keys in ACF are lowercase
		var result = CUT.getScopeAdobe( sessid=sessionid );
		debug( result );
		assertIsStruct( result );
		assertTrue( structKeyExists( result, "cfid" ) );
		assertTrue( structKeyExists( result, "cftoken" ) );
		assertTrue( structKeyExists( result, "sessionid" ) );
		assertTrue( structKeyExists( result, "urltoken" ) );
	}
	
	function stop(){
		var sessionid = LCase( session.sessionid ); // note session keys in ACF are lowercase
		var result = CUT.stop( sessid=sessionid );
		assertTrue( IsBoolean( result ) );
	}
	
	function touch(){
		var sessionid = LCase( session.sessionid ); // note session keys in ACF are lowercase
		var result = CUT.stop( sessId=sessionid );
		assertTrue( result );
		var result = CUT.stop( sessId='abc123' );
		assertFalse( result );
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