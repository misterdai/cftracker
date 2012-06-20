<cfcomponent output="false">
	<cfscript>
		
	/* -------------------------- CONSTRUCTOR -------------------------- */
	
	private any function init(){
		variables.JavaRuntime = CreateObject( "java", "java.lang.Runtime" );
		variables.ManagementFactory = CreateObject( "java", "java.lang.management.ManagementFactory" );
		variables.JavaVersion = CreateObject( "java", "java.lang.System" ).getProperty( "java.version" );
		variables.OperatingSystem = variables.ManagementFactory.getOperatingSystemMXBean();
		variables.File = CreateObject( "java", "java.io.File" );

		return this;
	} 
	
	/* -------------------------- PUBLIC -------------------------- */
	
	struct function getApplicationNames(){
		throw( message="abstract method" );
	}
	
	string function getProductName(){
		return UCase( ListFirst( server.coldfusion.productname, " " ) );
	}
	numeric function getMajorVersion(){
		return Val( ListFirst( server.coldfusion.productversion, "," ) );
	}
	string function getVersion(){
		return server.coldfusion.productversion;
	}
	
	/* returns a struct of drives */
	struct function getDrivesInfo(){
		var result = {};
		var Roots = variables.File.listRoots();
		for ( var i=1; i< ArrayLen( Roots ); i++ ) {
			result[ Roots[ i ].getAbsolutePath() ] = {
				totalspace = bytesToMBytes( Roots[ i ].getTotalSpace() ),
				freespace = bytesToMBytes( Roots[ i ].getFreeSpace() ),
				usaablespace = bytesToMBytes( Roots[ i ].getUsableSpace() ),
				canread = Roots[ i ].canRead(),
				canwrite = Roots[ i ].canWrite()
			};
		}
		return result;
	}
	

	
	/* returns free swap space in MBytes */ 
	numeric function getSwapFreeSpace(){
		return bytesToMBytes( variables.OperatingSystem.getFreeSwapSpaceSize() );
	}
	
	/* returns total swap space size in MBytes */ 
	numeric function getSwapTotalSpace(){
		return bytesToMBytes( variables.OperatingSystem.getTotalSwapSpaceSize() );
	}
	
	/* returns total swap space size in MBytes */ 
	numeric function getSwapUsedSpace(){
		return getSwapTotalSpace() - getSwapFreeSpace();
	}
	
	/* returns total physical memory in MBytes */ 
	numeric function getOSTotalMemory(){
		return bytesToMBytes( variables.OperatingSystem.getTotalPhysicalMemorySize() );
	}
	
	/* returns total used physical memory in use in MBytes */ 
	numeric function getOSUsedMemory(){
		return getOSTotalMemory() - getOSFreeMemory();
	}
	
	/* returns total physical free memory in MBytes */ 
	numeric function getOSFreeMemory(){
		return bytesToMBytes( variables.OperatingSystem.getFreePhysicalMemorySize() );
	}
		
	/* returns number of processors JVM can use */
	numeric function getJVMProcessors(){
		return bytesToMBytes( variables.javaRuntime.getRuntime().availableProcessors() );
	}
	
	/* returns free JVM memory in MBytes */
	numeric function getJVMFreeMemory(){
		return bytesToMBytes( variables.javaRuntime.getRuntime().freeMemory() );
	}
	
	/* returns used JVM memory in MBytes */
	numeric function getJVMUsedMemory(){
		return getJVMTotalMemory() - getJVMFreeMemory();
	}
	
	/* returns Maximum amount of memory JVM can use in MBytes */
	numeric function getJVMMaxMemory(){
		var result = bytesToMBytes( variables.javaRuntime.getRuntime().maxMemory() );
		if ( IsNull( result ) ) {
			return 0;
		}
		else {
			return result;			
		}
	}
	
	/* returns total JVM memory in use in MBytes */
	numeric function getJVMTotalMemory(){
		return bytesToMBytes( variables.javaRuntime.getRuntime().totalMemory() );
	}
	
	/* returns JVM version */
	any function getJavaVersion(){
		return variables.JavaVersion;
	}
	
	/* -------------------------- PRIVATE -------------------------- */
	
	private function bytesToMBytes( bytes ){
		var mb = 1024*1024;
		return Round( bytes / mb );
	}
	
	</cfscript>
</cfcomponent>