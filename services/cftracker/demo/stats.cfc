<cfcomponent output="false">
	<cffunction name="init" output="false" access="public">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getCompilationTime" access="public" output="false" returntype="any">
		<cfreturn application.demo.stats.compilationTime />
	</cffunction>
	
	<cffunction name="getClassLoading" access="public" output="false" returntype="struct">
		<cfreturn application.demo.stats.classLoading />
	</cffunction>
	
	<cffunction name="getProcessCpuTime" access="public" output="false" returntype="numeric">
		<cfreturn application.demo.stats.cpuProcessTime />
	</cffunction>
	
	<cffunction name="getMemory" access="public" output="false" returntype="struct">
		<cfset var mem = application.demo.stats.memory />
		<cfset mem.os = application.demo.stats.os />
		<cfreturn mem />
	</cffunction>
	
	<cffunction name="resetMemoryPeaks" access="public" output="false">
		<cfreturn true />
	</cffunction>
	
	<cffunction name="runGarbageCollection" access="public" output="false" returntype="boolean">
		<cfargument name="final" type="boolean" required="false" default="false" />
		<cfreturn true />
	</cffunction>
	
	<cffunction name="getGarbage" access="public" output="false" returntype="array">
		<cfreturn application.demo.stats.garbage />
	</cffunction>
	
	<cffunction name="getJdbcStats" access="public" output="false" returntype="struct">
		<cfreturn application.demo.stats.jdbc />
	</cffunction>
	
	<!--- Server --->
	<cffunction name="getUptime" access="public" output="false" returntype="numeric">
		<cfreturn DateDiff('s', server.coldfusion.expiration, Now()) />
	</cffunction>

	<cffunction name="getOs" access="public" output="false" returntype="struct">
		<cfreturn application.demo.stats.os />
	</cffunction>
	
	<cffunction name="getCf" access="public" output="false" returntype="struct">
		<cfreturn application.demo.stats.cfm />
	</cffunction>
 
	<cffunction name="getServerInfo" access="public" output="false" returntype="struct">
		<cfscript>
			var lc = {};
			lc.info = {};
			lc.info.perfmon = {};
			lc.info.requests = {};
			return lc.info;
		</cfscript>
	</cffunction>
</cfcomponent>