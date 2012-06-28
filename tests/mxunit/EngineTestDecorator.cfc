<cfcomponent extends="mxunit.framework.TestDecorator" output="false" hint="Excludes tests depending on environment">
	<cfscript>
		function invokeTestMethod( methodName, args ){
			var CFMLEngine = UCase( ListFirst( server.coldfusion.productname, " " ) ); // RAILO|COLDFUSION
			var excludeEngine = UCase( getAnnotation(methodName, "excludeEngine") );
			var result = ""; 
			if ( excludeEngine != CFMLEngine ) {
				// test is applicable to engine so run it 
				result = getTarget().invokeTestMethod( argumentCollection=arguments );
			}
			// note excluded tests show as green
			return result;
		}
	</cfscript>
</cfcomponent>