<cfcomponent extends="mxunit.framework.TestCase" output="false">
	
	<cfscript>
	/*
	---------------------------------------------------------------
	Tests
	---------------------------------------------------------------
	*/
	function getApplicationNames(){
		var result = CUT.getApplicationNames();
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
		var result = CUT.getJVMFreeMemory();
		assertTrue( result gt 10 );
	}
	
	function getJVMMaxMemory(){
		var result = CUT.getJVMMaxMemory();
		assertTrue( result gt 400 );
	}
	
	function getJVMTotalMemory(){
		var result = CUT.getJVMTotalMemory();
		assertTrue( result gt 100 );
	}
	
	function getJVMUsedMemory(){
		var result = CUT.getJVMUsedMemory();
		assertTrue( result gt 10 );
	}
	
	function getJavaVersion(){
		var result = CUT.getJavaVersion();
		assertEquals( "1.6.0_17", result );
	}
	
	function getDrivesInfo(){
		var result = CUT.getDrivesInfo();
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
		thisApplicationName = application.metadata.name;
	}
	function tearDown(){
	}
	</cfscript>
	
</cfcomponent>