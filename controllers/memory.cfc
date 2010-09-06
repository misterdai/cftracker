<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfargument name="fw" />
		<cfset variables.fw = arguments.fw />
		<cfreturn this />
	</cffunction>

	<cffunction name="default" output="false">
		<cfargument name="rc" />
		<cfset rc.ts = GetTickCount() / 1000 />
	</cffunction>
</cfcomponent>