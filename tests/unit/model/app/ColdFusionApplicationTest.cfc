<cfcomponent extends="mxunit.framework.TestCase" output="false">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests
	---------------------------------------------------------------
	*/
	function getScope(){
		result = CUT.getScope();
		assertIsStruct( result );
		assertTrue( StructKeyExists( result, "applicationname" ) );
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
		CUT = createObject( "component","cftracker.model.app.ColdFusionApplication" ).init( thisApplicationName );
	}
	function tearDown(){
	}
	</cfscript>
</cfcomponent>