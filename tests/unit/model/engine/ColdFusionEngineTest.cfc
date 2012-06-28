<cfcomponent extends="mxunit.framework.TestCase" output="false">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests (only for Coldfusion Server)
	---------------------------------------------------------------
	*/
	
	/**
	* @excludeEngine RAILO
	*/
	function getApplicationNames()  {
		var result = CUT.getApplicationNames();
		debug( result );
		assertIsArray( result );
		assertTrue( ArrayContains( result, thisApplicationName ) );
	}
	
	/**
	* @excludeEngine RAILO
	*/
	function getFullProductname(){
		assertEquals( "ColdFusion", ListFirst( CUT.getProductName(), " " ) );
	}

	/**
	* @excludeEngine RAILO
	*/
	function getApplicationServer(){
		assertEquals( "JRUN4", CUT.getApplicationServer() );
	}
	
	/**
	* @excludeEngine RAILO
	*/
	function getMajorVersion(){
		assertEquals( 9, CUT.getMajorVersion() );
	}
	
	/**
	* @excludeEngine RAILO
	*/
	function getVersion(){
		assertEquals( 9, ListFirst( CUT.getVersion() ) );
	}
	
	/*
	---------------------------------------------------------------
	MXUnit helper methods
	---------------------------------------------------------------
	*/
	function setUp(){
		CUT = createObject( "component","cftracker.model.engine.ColdFusionEngine" ).init();
		thisApplicationName = application.metadata.name;
	}
	function tearDown(){
	}
	</cfscript>
	
</cfcomponent>