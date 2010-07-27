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
			variables.jRuntimeBean = variables.jMgmt.getRuntimeMXBean();
			variables.jCompilation = variables.jMgmt.getCompilationMXBean();
			variables.jJdbcManager = CreateObject('java', 'coldfusion.server.j2ee.sql.pool.JDBCManager').getInstance();
			variables.jRuntime = CreateObject('java', 'java.lang.Runtime').getRuntime();
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
			var lc = {};
			lc.data = {
				current = variables.jClassLoading.getLoadedClassCount(),
				total = variables.jClassLoading.getTotalLoadedClassCount(),
				unloaded = variables.jClassLoading.getUnloadedClassCount()
			};
			return lc.data;
		</cfscript>
	</cffunction>
	
	<cffunction name="getProcessCpuTime" access="public" output="false" returntype="numeric">
		<cfscript>
			return variables.jOs.getProcessCpuTime();
		</cfscript>
	</cffunction>
	
	<cffunction name="getMemory" access="public" output="false" returntype="struct">
		<cfscript>
			var lc = {};
			lc.data = {};
			// OS
			lc.data.os = {
				vmCommitted = variables.jOs.getCommittedVirtualMemorySize(),
				physicalFree = variables.jOs.getFreePhysicalMemorySize(),
				swapFree = variables.jOs.getFreeSwapSpaceSize(),
				physicalTotal = variables.jOs.getTotalPhysicalMemorySize(),
				swapTotal = variables.jOs.getTotalSwapSpaceSize()
			};
			lc.data.os.swapUsed = lc.data.os.swapTotal - lc.data.os.swapFree;
			lc.data.os.physicalUsed = lc.data.os.physicalTotal - lc.data.os.physicalFree;
			// HEAP
			lc.heap = variables.jMem.getHeapMemoryUsage();
			lc.data.heap = {};
			lc.data.heap.usage = {
				committed = 0,
				inital = lc.heap.getInit(),
				max = lc.heap.getMax(),
				used = 0,
				free = 0
			};
			lc.data.heap.peakUsage = {
				committed = 0,
				inital = lc.heap.getInit(),
				max = lc.heap.getMax(),
				used = 0,
				free = 0
			};
			// NON HEAP
			lc.nonHeap = variables.jMem.getNonHeapMemoryUsage();
			lc.data.nonHeap = {};
			lc.data.nonHeap.usage = {
				committed = 0,
				inital = lc.nonHeap.getInit(),
				max = lc.nonHeap.getMax(),
				used = 0,
				free = 0
			};
			lc.data.nonHeap.peakUsage = {
				committed = 0,
				inital = lc.nonHeap.getInit(),
				max = lc.nonHeap.getMax(),
				used = 0,
				free = 0
			};
			// POOLS (Calculate heap / non-heap totals from the pools)
			lc.data.heap.pools = {};
			lc.data.nonheap.pools = {};
			lc.len = ArrayLen(variables.jMemPools);
			for (lc.i = 1; lc.i Lte lc.len; lc.i++) {
				lc.pName = variables.jMemPools[lc.i].getName();
				lc.pool = {
					name = variables.jMemPools[lc.i].getName(),
					garbageCollectors = variables.jMemPools[lc.i].getMemoryManagerNames()
				};
				lc.usage = variables.jMemPools[lc.i].getUsage();
				lc.pool.usage = {
					committed = lc.usage.getCommitted(),
					initial = lc.usage.getInit(),
					used = lc.usage.getUsed(),
					max = lc.usage.getMax()
				};
				lc.pool.usage.free = lc.pool.usage.max - lc.pool.usage.used;
				lc.usage = variables.jMemPools[lc.i].getPeakUsage();
				lc.pool.peakUsage = {
					committed = lc.usage.getCommitted(),
					initial = lc.usage.getInit(),
					used = lc.usage.getUsed(),
					max = lc.usage.getMax()
				};
				lc.pool.peakUsage.free = lc.pool.peakUsage.max - lc.pool.peakUsage.used;
				if (variables.jMemPools[lc.i].getType().toString() == 'Heap memory') {
					lc.data.heap.pools[lc.pName] = lc.pool;
					// Calculate Heap usage
					lc.data.heap.usage.committed += lc.pool.usage.committed;
					lc.data.heap.usage.used += lc.pool.usage.used;
					lc.data.heap.usage.free += lc.pool.usage.free;
					lc.data.heap.peakUsage.committed += lc.pool.peakUsage.committed;
					lc.data.heap.peakUsage.used += lc.pool.peakUsage.used;
					lc.data.heap.peakUsage.free += lc.pool.peakUsage.free;
				} else {
					lc.data.nonheap.pools[lc.pName] = lc.pool;
					// Calculate Non heap usage
					lc.data.nonheap.usage.committed += lc.pool.usage.committed;
					lc.data.nonheap.usage.used += lc.pool.usage.used;
					lc.data.nonheap.usage.free += lc.pool.usage.free;
					lc.data.nonheap.peakUsage.committed += lc.pool.peakUsage.committed;
					lc.data.nonheap.peakUsage.used += lc.pool.peakUsage.used;
					lc.data.nonheap.peakUsage.free += lc.pool.peakUsage.free;
				}
			}
			lc.data.objectsPendingFinal = variables.jMem.getObjectPendingFinalizationCount();
			return lc.data;
		</cfscript>
	</cffunction>
	
	<cffunction name="resetMemoryPeaks" access="public" output="false">
		<cfscript>
			var lc = {};
			lc.len = ArrayLen(variables.jMemPools);
			for (lc.i = 1; lc.i Lte lc.len; lc.i++) {
				variables.jMemPools[lc.i].resetPeakUsage();
			}
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="runGarbageCollection" access="public" output="false" returntype="boolean">
		<cfargument name="final" type="boolean" required="false" default="false" />
		<cfscript>
			if (arguments.final) {
				variables.jRuntime.runFinalization();
			}
			variables.jRuntime.gc();
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="getGarbage" access="public" output="false" returntype="array">
		<cfscript>
			var lc = {};
			lc.startTime = DateAdd('s', variables.jRuntimeBean.getStartTime() / 1000, CreateDate(1970, 1, 1));
			lc.data = [];
			lc.len = ArrayLen(variables.jGarbage);
			for (lc.i = 1; lc.i Lte lc.len; lc.i++) {
				lc.gcInfo = variables.jGarbage[lc.i].getLastGcInfo();
				lc.usage = {
					before = lc.gcInfo.getMemoryUsageBeforeGc(),
					after = lc.gcInfo.getMemoryUsageAfterGc()
				};
				lc.temp = {
					collections = variables.jGarbage[lc.i].getCollectionCount(),
					totalDuration = variables.jGarbage[lc.i].getCollectionTime(),
					name = variables.jGarbage[lc.i].getName(),
					valid = variables.jGarbage[lc.i].isValid(),
					pools = variables.jGarbage[lc.i].getMemoryPoolNames(),
					startTime = DateAdd('s', lc.gcInfo.getStartTime() / 1000, lc.startTime),
					duration = lc.gcInfo.getDuration(),
					endTime = DateAdd('s', lc.gcInfo.getEndTime() / 1000, lc.startTime)
				};
				lc.temp.usage = {};
				lc.pLen = ArrayLen(lc.temp.pools);
				for (lc.p = 1; lc.p Lte lc.pLen; lc.p++) {
					lc.pool = lc.temp.pools[lc.p];
					lc.temp.usage[lc.pool] = {};
					for (lc.when in lc.usage) {
						lc.temp.usage[lc.pool][lc.when] = {
							committed = lc.usage[lc.when][lc.pool].getCommitted(),
							initial = lc.usage[lc.when][lc.pool].getInit(),
							used = lc.usage[lc.when][lc.pool].getUsed(),
							max = lc.usage[lc.when][lc.pool].getMax()
						};
						lc.temp.usage[lc.pool][lc.when].free = lc.temp.usage[lc.pool][lc.when].max - lc.temp.usage[lc.pool][lc.when].used;
					}
				}
				ArrayAppend(lc.data, lc.temp);
			}
			//lc.data.a = variables.jMem.getObjectPendingFinalizationCount();
			return lc.data;
		</cfscript>
	</cffunction>
	
	<cffunction name="getJdbcStats" access="public" output="false" returntype="struct">
		<cfscript>
			var lc = {};
			lc.jPools = variables.jJdbcManager.getPools();
			lc.data = {};
			while (lc.jPools.hasMoreElements()) {
				lc.jPool = lc.jPools.nextElement();
				lc.meta = lc.jPool.getMetaData();
				lc.data[lc.jPool.getPoolName()] = {
					open = lc.jPool.getCheckedOutCount(),
					total = lc.jPool.getPoolCount(),
					database = lc.meta.getDbname(),
					description = lc.meta.getDescription()
				};
			}
			return lc.data;
		</cfscript>
	</cffunction>
	
	<!--- Server --->
	<cffunction name="getUptime" access="public" output="false" returntype="numeric">
		<cfreturn DateDiff('s', server.coldfusion.expiration, Now()) />
	</cffunction>

	<cffunction name="getOs" access="public" output="false" returntype="struct">
		<cfscript>
			var lc = {};
			lc.data = {
				vmCommitted = variables.jOs.getCommittedVirtualMemorySize(),
				physicalFree = variables.jOs.getFreePhysicalMemorySize(),
				swapFree = variables.jOs.getFreeSwapSpaceSize(),
				cpuTime = jOs.getProcessCpuTime(),
				physicalTotal = jOs.getTotalPhysicalMemorySize(),
				swapTotal = jOs.getTotalSwapSpaceSize()
			};
			lc.data.swapUsed = lc.data.swapTotal - lc.data.swapFree;
			lc.data.physicalUsed = lc.data.physicalTotal - lc.data.physicalFree;
			return lc.data;
		</cfscript>
	</cffunction>
 
	<cffunction name="getServerInfo" access="public" output="false" returntype="struct">
		<cfscript>
			var lc = {};
			lc.info = {};
			lc.info.perfmon = {};
			lc.info.requests = {};
		</cfscript>
		<cftry>
			<cfscript>
				lc.info.load = GetMetricData('simple_load');
				lc.info.perfmon = GetMetricData('perf_monitor');
				lc.info.requests.averageTime = GetMetricData('avg_req_time');
				lc.info.requests.previousTime = GetMetricData('prev_req_time');
			</cfscript>
			<cfcatch type="any">
				<!--- Multi Server ColdFusion doesn't support GetMetricData() --->
			</cfcatch>
		</cftry>
		<cfreturn lc.info />
	</cffunction>
</cfcomponent>