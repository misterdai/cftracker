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
		assertEquals( true, ReFindNoCase( "(Apache Tomcat|jetty)", CUT.getApplicationServer() ) > 0 );
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
		assertTrue( ReFindNoCase( "^3\.3\.[2-9]\.[0-9]{1,}$", CUT.getVersion() ) > 0 );
	}

	/**
	* @excludeEngine COLDFUSION
	*/
	function getConfigWebs(){
		makePublic( CUT, "getConfigWebs" );
		debug( CUT.getConfigWebs() );
		assertEquals( true, IsArray( CUT.getConfigWebs() ) );
	}
	
	/*
	---------------------------------------------------------------
	MXUnit helper methods
	---------------------------------------------------------------
	*/
	function setUp(){
		var enginename = UCase( ListFirst( server.coldfusion.productname, " " ) );
		var $CFMLEngine = mock().getProductName().returns( enginename );
		CUT = createObject( "component","cftracker.model.engine.RailoEngine" ).init( $CFMLEngine );
		thisApplicationName = application.metadata.name;
	}
	function tearDown(){
	}
	</cfscript>
	
</cfcomponent>