<cfcomponent output="false">
	<cffunction name="init" access="public" output="false">
		<cfscript>
			variables.jTemplates = CreateObject('java', 'coldfusion.runtime.TemplateClassLoader');
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="getClassHitRatio" access="public" output="false" returntype="numeric">
		<cfreturn variables.jTemplates.getClassCacheHitRatio() />
	</cffunction>
</cfcomponent>