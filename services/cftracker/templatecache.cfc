<cfcomponent output="false">
	<cffunction name="init" access="public" output="false">
		<cfscript>
			variables.server = server.coldfusion.productName;
			variables.version = server.coldfusion.productVersion;
			
			if (ListFirst(variables.server, ' ') Eq 'ColdFusion') {
				variables.jTemplates = CreateObject('java', 'coldfusion.runtime.TemplateClassLoader');
				this.getClassHitRatio = variables.getClassHitRatioAdobe;
			}
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="getClassHitRatioAdobe" access="private" output="false" returntype="numeric">
		<cfreturn variables.jTemplates.getClassCacheHitRatio() />
	</cffunction>
</cfcomponent>