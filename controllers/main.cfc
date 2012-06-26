<cfcomponent output="false">
	<cffunction name="init" output="false" >
		<cfargument name="fw" />
		<cfset variables.fw = arguments.fw />
		<cfreturn this />
	</cffunction>

	<cffunction name="default" output="false" hint="the dashboard view">
		<cfargument name="rc" />
	</cffunction>
	
	<cffunction name="error" output="false" access="public">
		<cfargument name="rc" />
	</cffunction>
</cfcomponent>