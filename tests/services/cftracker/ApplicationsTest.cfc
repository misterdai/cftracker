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
		assertTrue( ArrayFind( result, "foo" ) );
	}
	
	function getExpired(){
		result = CUT.getExpired( appname );
	}
	
	function getIdlePercent(){
		result = CUT.getIdlePercent( appname );
	}
	
	function getIdleTimeout(){
		result = CUT.getIdleTimeout( appname );
	}
	
	function getLastAccessed(){
		result = CUT.getLastAccessed( appname );
	}
	
	/*
	---------------------------------------------------------------
	MXUnit helper methods
	---------------------------------------------------------------
	*/
	function setUp(){
		CUT = createObject("component","cftracker.services.cftracker.applications").init();
		application.foo = "bar";
		appname = request.appname;
	}
	function tearDown(){
		StructDelete( application, "foo" );
	}
	</cfscript>
	
</cfcomponent>