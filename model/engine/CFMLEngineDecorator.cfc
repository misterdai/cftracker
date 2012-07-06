<cfcomponent output="false" extends="CFMLEngine">
	<cfscript>
		
	/* -------------------------- CONSTRUCTOR -------------------------- */
	
	any function init( required CFMLEngine ){
		variables.CFMLEngine = arguments.CFMLEngine;
		return this;
	}
	
	/* -------------------------- PUBLIC -------------------------- */
	
	string function getApplicationServer(){
		throw( message="abstract" );
	}
	
	/* returns a struct of drives */
	struct function getDrivesInfo(){
		return variables.CFMLEngine.getDrivesInfo();
	}
	
	string function getFullProductname(){
		throw( message="abstract" );
	}
		
	/* returns JVM version */
	any function getJavaVersion(){
		return variables.CFMLEngine.getJavaVersion();
	}
	
	/* returns free JVM memory in MBytes */
	numeric function getJVMFreeMemory(){
		return variables.CFMLEngine.getJVMFreeMemory();
	}
	
	/* returns Maximum amount of memory JVM can use in MBytes */
	numeric function getJVMMaxMemory(){
		return variables.CFMLEngine.getJVMMaxMemory();
	}
	
	/* returns number of processors JVM can use */
	numeric function getJVMProcessors(){
		return variables.CFMLEngine.getJVMProcessors();
	}

	/* returns JVM started datetime */
	date function getJVMStartedDateTime(){
		return variables.CFMLEngine.getJVMStartedDateTime();
	}
	
	/* returns total JVM memory in use in MBytes */
	numeric function getJVMTotalMemory(){
		return variables.CFMLEngine.getJVMTotalMemory();
	}
	
	/* returns JVM uptime in milliseconds */
	numeric function getJVMUptime(){
		return variables.CFMLEngine.getJVMUptime();
	}

	/* returns used JVM memory in MBytes */
	numeric function getJVMUsedMemory(){
		return variables.CFMLEngine.getJVMUsedMemory();
	}
	
	numeric function getMajorVersion(){
		throw( message="abstract" );
	}
	
	/* returns total physical free memory in MBytes */ 
	numeric function getOSFreeMemory(){
		return variables.CFMLEngine.getOSFreeMemory();
	}

	/* returns total physical memory in MBytes */ 
	numeric function getOSTotalMemory(){
		return variables.CFMLEngine.getOSTotalMemory();
	}
	
	/* returns total used physical memory in use in MBytes */ 
	numeric function getOSUsedMemory(){
		return variables.CFMLEngine.getOSUsedMemory();
	}
	
	string function getProductName(){
		return variables.CFMLEngine.getProductName();
	}

	/* returns free swap space in MBytes */ 
	numeric function getSwapFreeSpace(){
		return variables.CFMLEngine.getSwapFreeSpace();
	}
	
	/* returns total swap space size in MBytes */ 
	numeric function getSwapTotalSpace(){
		return variables.CFMLEngine.getSwapTotalSpace();
	}
	
	/* returns total swap space size in MBytes */ 
	numeric function getSwapUsedSpace(){
		return variables.CFMLEngine.getSwapUsedSpace();
	}
	
	string function getVersion(){
		throw( message="abstract" );
	}
		
	</cfscript>
</cfcomponent>