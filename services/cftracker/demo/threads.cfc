<cfcomponent output="false">
	<cffunction name="init" output="false" access="public">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getThreads" access="public" output="false">
		<cfargument name="groupName" type="string" required="false" />
		<cfreturn application.demo.threads.items />
	</cffunction>
	
	<cffunction name="countByGroup" access="public" output="false">
		<cfreturn application.demo.threads.groups />
	</cffunction>
</cfcomponent>