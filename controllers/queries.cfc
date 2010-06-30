<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfargument name="fw" />
		<cfset variables.fw = arguments.fw />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="default" output="false"> 
		<cfargument name="rc" />
	</cffunction>

	<cffunction name="getResult" output="false">
		<cfargument name="rc" />
	</cffunction>

	<cffunction name="purge" output="false">
		<cfargument name="rc" />
		<cfscript>
			var local = {};
			local.data = getPageContext().getRequest().getParameterMap();
			if (StructKeyExists(local.data, 'queries')) {
				rc.queries = local.data['queries'];
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="endpurge" output="false">
		<cfargument name="rc" />
		<cfset variables.fw.redirect('queries.default') />
	</cffunction>
	
	<cffunction name="refresh" output="false">
		<cfargument name="rc" />
		<cfset variables.purge(arguments.rc) />
	</cffunction>
	
	<cffunction name="endrefresh" output="false">
		<cfargument name="rc" />
		<cfset variables.endpurge(arguments.rc) />
	</cffunction>

	<cffunction name="purgeBy" output="false">
		<cfargument name="rc" />
	</cffunction>
	
	<cffunction name="endPurgeBy" output="false">
		<cfargument name="rc" />

		<cfset variables.endpurge(arguments.rc) />
	</cffunction>

	<cffunction name="refreshBy" output="false">
		<cfargument name="rc" />
	</cffunction>
	
	<cffunction name="endRefreshBy" output="false">
		<cfargument name="rc" />
		<cfset variables.endpurge(arguments.rc) />
	</cffunction>
</cfcomponent>