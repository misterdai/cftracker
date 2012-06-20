<cfcomponent extends="mxunit.framework.TestCase" output="false">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests
	---------------------------------------------------------------
	*/
	function getApplicationNames(){
		result = CUT.getApplicationNames();
		assertIsArray( result );
		assertTrue( ArrayContains( result, thisApplicationName ) );
	}

	function getProductName(){
		assertEquals( "ColdFusion", CUT.getProductName() );
	}
	function getMajorVersion(){
		assertEquals( 9, CUT.getMajorVersion() );
	}
	function getVersion(){
		assertEquals( 9, ListFirst( CUT.getVersion() ) );
	}
	
	function getJVMFreeMemory(){
		result = CUT.getJVMFreeMemory();
		assertTrue( result gt 100 );
	}
	
	function getJVMMaxMemory(){
		result = CUT.getJVMMaxMemory();
		assertTrue( result gt 400 );
	}
	
	function getJVMTotalMemory(){
		result = CUT.getJVMTotalMemory();
		assertTrue( result gt 100 );
	}
	
	function getJVMUsedMemory(){
		result = CUT.getJVMUsedMemory();
		assertTrue( result gt 10 );
	}
	
	function getJavaVersion(){
		result = CUT.getJavaVersion();
		assertEquals( "1.6.0_17", result );
	}
	
	function getDrivesInfo(){
		result = CUT.getDrivesInfo();
		assertIsStruct( result );
		assertTrue( StructCount( result ) > 0 );
	}
	
	
	
	function getSwapFreeSpace(){
		assertTrue( CUT.getSwapFreeSpace() > 0 );
	}
	
	function getSwapTotalSpace(){
		assertTrue( CUT.getSwapTotalSpace() > 0 );
	}
	
	function getSwapUsedSpace(){
		assertTrue( CUT.getSwapUsedSpace() > 0 );
	}
	
	function getOSTotalMemory(){
		assertTrue( CUT.getOSTotalMemory() > 0 );
	}
	
	function getOSUsedMemory(){
		assertTrue( CUT.getOSUsedMemory() > 0 );
	}
	
	function getOSFreeMemory(){
		assertTrue( CUT.getOSFreeMemory() > 0 );
	}
	
	/*
	---------------------------------------------------------------
	MXUnit helper methods
	---------------------------------------------------------------
	*/
	function setUp(){
		CUT = createObject( "component","cftracker.model.engine.ColdFusionEngine" ).init();
		thisApplicationName = request.appname;
	}
	function tearDown(){
	}
	</cfscript>
	
</cfcomponent>