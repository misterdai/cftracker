<cfcomponent output="false">
	<cffunction name="init" output="false" access="public">
		<cfscript>
			// Memory tracking
			variables.jRuntime = CreateObject('java', 'java.lang.Runtime').getRuntime();
			variables.jMgmtFactory = CreateObject('java', 'java.lang.management.ManagementFactory');
			variables.jPools = variables.jMgmtFactory.getMemoryPoolMxBeans();
			variables.jHeap = variables.jMgmtFactory.getMemoryMXBean(); 
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="getMemFree" access="public" output="false" returntype="numeric">
		<cfreturn (variables.jRuntime.maxMemory() - variables.jRuntime.totalMemory() + variables.jRuntime.freeMemory()) / 1024^2 />
	</cffunction>
	
	<cffunction name="getMemAllocated" access="public" output="false" returntype="numeric">
		<cfreturn variables.jRuntime.totalMemory() / 1024^2 />
	</cffunction>

	<cffunction name="getMemFreeAllocated" access="public" output="false" returntype="numeric">
		<cfreturn variables.jRuntime.freeMemory() / 1024^2 />
	</cffunction>

	<cffunction name="getMemUsed" access="public" output="false" returntype="numeric">
		<cfreturn (variables.jRuntime.totalMemory() - variables.jRuntime.freeMemory()) / 1024^2 />
	</cffunction>
	
	<cffunction name="getMemMax" access="public" output="false" returntype="numeric">
		<cfreturn jRuntime.maxMemory() / 1024^2 />
	</cffunction>
	
	<cffunction name="getMemInfo" access="public" output="false" returntype="struct">
		<cfscript>
			var local = {};
			local.info = {};
			local.info.free = variables.getMemFree();
			local.info.allocated = variables.getMemAllocated();
			local.info.freeAllocated = variables.getMemFreeAllocated();
			local.info.used = variables.getMemUsed();
			local.info.max = variables.getMemMax();
			local.info.percentFree = local.info.free / local.info.max * 100;
			local.info.percentUsed = 100 - local.info.percentFree;
			return local.info;
		</cfscript>
	</cffunction>
	
	<!--- Server --->
	<cffunction name="getUptime" access="public" output="false" returntype="numeric">
		<cfreturn DateDiff('s', server.coldfusion.expiration, Now()) />
	</cffunction>

	<cffunction name="getServerInfo" access="public" output="false" returntype="struct">
		<cfscript>
			var local = {};
			local.info = {};
			local.info.perfmon = {};
			local.info.requests = {};
		</cfscript>
		<cftry>
			<cfscript>
				local.info.load = GetMetricData('simple_load');
				local.info.perfmon = GetMetricData('perf_monitor');
				local.info.requests.averageTime = GetMetricData('avg_req_time');
				local.info.requests.previousTime = GetMetricData('prev_req_time');
			</cfscript>
			<cfcatch type="any">
				<!--- Multi Server ColdFusion doesn't support GetMetricData() --->
			</cfcatch>
		</cftry>
		<cfreturn local.info />
	</cffunction>
</cfcomponent>