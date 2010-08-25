<cfcomponent output="false">
	<cffunction name="init" access="public" output="false">
		<cfreturn this />
	</cffunction>

	<cffunction name="getClassHitRatio" access="public" output="false" returntype="numeric">
		<cfreturn application.demo.templates.hitRatio />
	</cffunction>
</cfcomponent>