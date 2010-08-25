<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfargument name="fw" />
		<cfset variables.fw = arguments.fw />
		<cfreturn this />
	</cffunction>

	<cffunction name="before" output="false">
		<cfif application.settings.demo>
			<cfset variables.fw.redirect('main.default') />
		</cfif>
	</cffunction>
</cfcomponent>