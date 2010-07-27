<cfcomponent output="false">
	<cffunction name="init" output="false" access="public">
		<cfscript>
			// Memory tracking
			variables.jMgmt = CreateObject('java', 'java.lang.management.ManagementFactory');
			variables.jMem = variables.jMgmt.getMemoryMXBean(); 
			variables.jMemPools = variables.jMgmt.getMemoryPoolMXBeans();
			variables.jClassLoading = variables.jMgmt.getClassLoadingMXBean();
			variables.jGarbage = variables.jMgmt.getGarbageCollectorMXBeans();
			variables.jOs = variables.jMgmt.getOperatingSystemMXBean();
			variables.jRuntime = variables.jMgmt.getRuntimeMXBean();
			variables.jCompilation = variables.jMgmt.getCompilationMXBean();
			variables.jJdbcManager = CreateObject('java', 'coldfusion.server.j2ee.sql.pool.JDBCManager').getInstance();
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="getCompilationTime" access="public" output="false" returntype="any">
		<cfscript>
			if (variables.jCompilation.isCompilationTimeMonitoringSupported()) {
				return variables.jCompilation.getTotalCompilationTime();
			} else {
				return false;
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getClassLoading" access="public" output="false" returntype="struct">
		<cfscript>
			var local = {};
			local.data = {
				current = variables.jClassLoading.getLoadedClassCount(),
				total = variables.jClassLoading.getTotalLoadedClassCount(),
				unloaded = variables.jClassLoading.getUnloadedClassCount()
			};
			return local.data;
		</cfscript>
	</cffunction>
	
	<cffunction name="getProcessCpuTime" access="public" output="false" returntype="numeric">
		<cfscript>
			return variables.jOs.getProcessCpuTime();
		</cfscript>
	</cffunction>
	
	<cffunction name="getMemory" access="public" output="false" returntype="struct">
		<cfscript>
			var local = {};
			local.data = {};
			// OS
			local.data.os = {
				vmCommitted = variables.jOs.getCommittedVirtualMemorySize(),
				physicalFree = variables.jOs.getFreePhysicalMemorySize(),
				swapFree = variables.jOs.getFreeSwapSpaceSize(),
				physicalTotal = variables.jOs.getTotalPhysicalMemorySize(),
				swapTotal = variables.jOs.getTotalSwapSpaceSize()
			};
			local.data.os.swapUsed = local.data.os.swapTotal - local.data.os.swapFree;
			local.data.os.physicalUsed = local.data.os.physicalTotal - local.data.os.physicalFree;
			// HEAP
			local.heap = variables.jMem.getHeapMemoryUsage();
			local.data.heap = {};
			local.data.heap.usage = {
				committed = 0,
				inital = local.heap.getInit(),
				max = local.heap.getMax(),
				used = 0,
				free = 0
			};
			local.data.heap.peakUsage = {
				committed = 0,
				inital = local.heap.getInit(),
				max = local.heap.getMax(),
				used = 0,
				free = 0
			};
			// NON HEAP
			local.nonHeap = variables.jMem.getNonHeapMemoryUsage();
			local.data.nonHeap = {};
			local.data.nonHeap.usage = {
				committed = 0,
				inital = local.nonHeap.getInit(),
				max = local.nonHeap.getMax(),
				used = 0,
				free = 0
			};
			local.data.nonHeap.peakUsage = {
				committed = 0,
				inital = local.nonHeap.getInit(),
				max = local.nonHeap.getMax(),
				used = 0,
				free = 0
			};
			// POOLS (Calculate heap / non-heap totals from the pools)
			local.data.heap.pools = {};
			local.data.nonheap.pools = {};
			local.len = ArrayLen(variables.jMemPools);
			for (local.i = 1; local.i Lte local.len; local.i++) {
				local.pName = variables.jMemPools[local.i].getName();
				local.pool = {
					name = variables.jMemPools[local.i].getName(),
					garbageCollectors = variables.jMemPools[local.i].getMemoryManagerNames()
				};
				local.usage = variables.jMemPools[local.i].getUsage();
				local.pool.usage = {
					committed = local.usage.getCommitted(),
					initial = local.usage.getInit(),
					used = local.usage.getUsed(),
					max = local.usage.getMax()
				};
				local.pool.usage.free = local.pool.usage.max - local.pool.usage.used;
				local.usage = variables.jMemPools[local.i].getPeakUsage();
				local.pool.peakUsage = {
					committed = local.usage.getCommitted(),
					initial = local.usage.getInit(),
					used = local.usage.getUsed(),
					max = local.usage.getMax()
				};
				local.pool.peakUsage.free = local.pool.peakUsage.max - local.pool.peakUsage.used;
				if (variables.jMemPools[local.i].getType().toString() == 'Heap memory') {
					local.data.heap.pools[local.pName] = local.pool;
					// Calculate Heap usage
					local.data.heap.usage.committed += local.pool.usage.committed;
					local.data.heap.usage.used += local.pool.usage.used;
					local.data.heap.usage.free += local.pool.usage.free;
					local.data.heap.peakUsage.committed += local.pool.peakUsage.committed;
					local.data.heap.peakUsage.used += local.pool.peakUsage.used;
					local.data.heap.peakUsage.free += local.pool.peakUsage.free;
				} else {
					local.data.nonheap.pools[local.pName] = local.pool;
					// Calculate Non heap usage
					local.data.nonheap.usage.committed += local.pool.usage.committed;
					local.data.nonheap.usage.used += local.pool.usage.used;
					local.data.nonheap.usage.free += local.pool.usage.free;
					local.data.nonheap.peakUsage.committed += local.pool.peakUsage.committed;
					local.data.nonheap.peakUsage.used += local.pool.peakUsage.used;
					local.data.nonheap.peakUsage.free += local.pool.peakUsage.free;
				}
			}
			local.data.objectsPendingFinal = variables.jMem.getObjectPendingFinalizationCount();
			return local.data;
		</cfscript>
	</cffunction>
	
	<cffunction name="resetMemoryPeaks" access="public" output="false">
		<cfscript>
			var local = {};
			local.len = ArrayLen(variables.jMemPools);
			for (local.i = 1; local.i Lte local.len; local.i++) {
				variables.jMemPools[local.i].resetPeakUsage();
			}
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="getGarbage" access="public" output="false" returntype="array">
		<cfscript>
			var local = {};
			local.startTime = DateAdd('s', variables.jRuntime.getStartTime() / 1000, CreateDate(1970, 1, 1));
			local.data = [];
			local.len = ArrayLen(variables.jGarbage);
			for (local.i = 1; local.i Lte local.len; local.i++) {
				local.gcInfo = variables.jGarbage[local.i].getLastGcInfo();
				local.usage = {
					before = local.gcInfo.getMemoryUsageBeforeGc(),
					after = local.gcInfo.getMemoryUsageAfterGc()
				};
				local.temp = {
					collections = variables.jGarbage[local.i].getCollectionCount(),
					totalDuration = variables.jGarbage[local.i].getCollectionTime(),
					name = variables.jGarbage[local.i].getName(),
					valid = variables.jGarbage[local.i].isValid(),
					pools = variables.jGarbage[local.i].getMemoryPoolNames(),
					startTime = DateAdd('s', local.gcInfo.getStartTime() / 1000, local.startTime),
					duration = local.gcInfo.getDuration(),
					endTime = DateAdd('s', local.gcInfo.getEndTime() / 1000, local.startTime)
				};
				local.temp.usage = {};
				local.pLen = ArrayLen(local.temp.pools);
				for (local.p = 1; local.p Lte local.pLen; local.p++) {
					local.pool = local.temp.pools[local.p];
					local.temp.usage[local.pool] = {};
					for (local.when in local.usage) {
						local.temp.usage[local.pool][local.when] = {
							committed = local.usage[local.when][local.pool].getCommitted(),
							initial = local.usage[local.when][local.pool].getInit(),
							used = local.usage[local.when][local.pool].getUsed(),
							max = local.usage[local.when][local.pool].getMax()
						};
						local.temp.usage[local.pool][local.when].free = local.temp.usage[local.pool][local.when].max - local.temp.usage[local.pool][local.when].used;
					}
				}
				ArrayAppend(local.data, local.temp);
			}
			//local.data.a = variables.jMem.getObjectPendingFinalizationCount();
			return local.data;
		</cfscript>
	</cffunction>
	
	<cffunction name="getJdbcStats" access="public" output="false" returntype="struct">
		<cfscript>
			var local = {};
			local.jPools = variables.jJdbcManager.getPools();
			local.data = {};
			while (local.jPools.hasMoreElements()) {
				local.jPool = local.jPools.nextElement();
				local.meta = local.jPool.getMetaData();
				local.data[local.jPool.getPoolName()] = {
					open = local.jPool.getCheckedOutCount(),
					total = local.jPool.getPoolCount(),
					database = local.meta.getDbname(),
					description = local.meta.getDescription()
				};
			}
			return local.data;
		</cfscript>
	</cffunction>
	
	<!--- Server --->
	<cffunction name="getUptime" access="public" output="false" returntype="numeric">
		<cfreturn DateDiff('s', server.coldfusion.expiration, Now()) />
	</cffunction>

	<cffunction name="getOs" access="public" output="false" returntype="struct">
		<cfscript>
			var local = {};
			local.data = {
				vmCommitted = variables.jOs.getCommittedVirtualMemorySize(),
				physicalFree = variables.jOs.getFreePhysicalMemorySize(),
				swapFree = variables.jOs.getFreeSwapSpaceSize(),
				cpuTime = jOs.getProcessCpuTime(),
				physicalTotal = jOs.getTotalPhysicalMemorySize(),
				swapTotal = jOs.getTotalSwapSpaceSize()
			};
			local.data.swapUsed = local.data.swapTotal - local.data.swapFree;
			local.data.physicalUsed = local.data.physicalTotal - local.data.physicalFree;
			return local.data;
		</cfscript>
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