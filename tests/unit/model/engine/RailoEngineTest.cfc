<cfcomponent extends="mxunit.framework.TestCase" output="false" mxunit:decorators="cftracker.tests.mxunit.EngineTestDecorator">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests (only for Railo Server)
	---------------------------------------------------------------
	*/
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getApplicationNames()  {
		var result = CUT.getApplicationNames();
		debug( result );
		assertIsArray( result );
		assertTrue( ArrayContains( result, thisApplicationName ) );
	}
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getFullProductname(){
		assertEquals( "RAILO", ListFirst( CUT.getProductName(), " " ) );
	}

	/**
	* @excludeEngine COLDFUSION
	*/
	function getApplicationServer(){
		assertEquals( "Apache Tomcat", CUT.getApplicationServer() );
	}
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getMajorVersion(){
		assertEquals( 3.3, CUT.getMajorVersion() );
	}
	
	/**
	* @excludeEngine COLDFUSION
	*/
	function getVersion(){
		assertEquals( "3.3.3", ListFirst( CUT.getVersion() ) );
	}
	
	/*
	---------------------------------------------------------------
	MXUnit helper methods
	---------------------------------------------------------------
	*/
	function setUp(){
		CUT = createObject( "component","cftracker.model.engine.RailoEngine" ).init();
		thisApplicationName = application.metadata.name;
	}
	function tearDown(){
	}
	</cfscript>
	
</cfcomponent>