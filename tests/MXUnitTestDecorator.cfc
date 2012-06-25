<cfcomponent extends="mxunit.framework.TestDecorator" output="false" hint="Excludes tests depending on environment">
	<cfscript>
		function getRunnableMethods(){
			var allMethods = getTarget().getRunnableMethods();
			var CFMLEngine = ListFirst( server.coldfusion.)
			for ( method in allMethods ) {
				
			}
		}
	</cfscript>
</cfcomponent>