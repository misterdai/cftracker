component {
	public Memory function init() {
		variables.jManagementFactory = CreateObject('java', 'java.lang.management.ManagementFactory');
		variables.jMemoryMXBean = variables.jManagementFactory.getMemoryMXBean();
		variables.jMemoryPoolMXBeans = variables.jManagementFactory.getMemoryPoolMXBeans();
		variables.jGarbageCollectorMXBeans = variables.jManagementFactory.getGarbageCollectorMXBeans();
		variables.jOperatingSystemMXBean = variables.jManagementFactory.getOperatingSystemMXBean();
		variables.jMemoryManagerMXBeans = variables.jManagementFactory.getMemoryManagerMXBeans();
		return this;
	}

	public struct function getHeap() {
		local.heapUsage = variables.jMemoryMXBean.getHeapMemoryUsage();
		local.stats = {
			committed = local.heapUsage.getCommitted(),
			initial = local.heapUsage.getInit(),
			max = local.heapUsage.getMax(),
			used = local.heapUsage.getUsed()
		};
		return local.stats;
	}

	public struct function getNonHeap() {
		local.nonHeapUsage = variables.jMemoryMXBean.getNonHeapMemoryUsage();
		local.stats = {
			committed = local.nonHeapUsage.getCommitted(),
			initial = local.nonHeapUsage.getInit(),
			max = local.nonHeapUsage.getMax(),
			used = local.nonHeapUsage.getUsed()
		};
		return local.stats;
	}

	public numeric function getObjectPendingFinalizationCount() {
		return variables.jMemoryMXBean.getObjectPendingFinalizationCount();
	}

	public void function resetPoolPeakUsage(
		array poolNames = []
	) {
		if (!ArrayLen(arguments.poolNames)) {
			for (local.i = ArrayLen(variables.jMemoryPoolMXBeans); local.i; local.i--) {
				variables.jMemoryPoolMXBeans[local.i].resetPeakUsage();
			}
		} else {
			for (local.i = ArrayLen(variables.jMemoryPoolMXBeans); local.i; local.i--) {
				if (ArrayContains(arguments.poolNames, variables.jMemoryPoolMXBeans[local.i].getName())) {
					variables.jMemoryPoolMXBeans[local.i].resetPeakUsage();
				}
			}
		}
	}

	public array function getPools(
		string memoryType = ''
	) {
		local.pools = [];
		for (local.i = ArrayLen(variables.jMemoryPoolMXBeans); local.i; local.i--) {
			local.pool = variables.jMemoryPoolMXBeans[local.i];
			local.type = local.pool.getType();
			if (Len(arguments.memoryType) == 0 || arguments.memoryType == local.type.name()) {
				local.usage = local.pool.getUsage();
				local.peakUsage = local.pool.getPeakUsage();
				ArrayPrepend(local.pools, {
					'name' = local.pool.getName(),
					'type' = local.type.name(),
					'description' = local.type.toString(),
					'garbageCollectors' = local.pool.getMemoryManagerNames(),
					'usage' = {
						'current' = {
							'committed' = local.usage.getCommitted(),
							'initial' = local.usage.getInit(),
							'used' = local.usage.getUsed(),
							'max' = local.usage.getMax()
						},
						'peak' = {
							'committed' = local.peakUsage.getCommitted(),
							'initial' = local.peakUsage.getInit(),
							'used' = local.peakUsage.getUsed(),
							'max' = local.peakUsage.getMax()
						}
					}
				});
			}
		}
		return local.pools;
	}

	public array function getGarbageCollectors() {
		local.data = [];
		for (local.i = ArrayLen(variables.jGarbageCollectorMXBeans); local.i; local.i--) {
			local.gc = variables.jGarbageCollectorMXBeans[i];
			local.previous = local.gc.getLastGcInfo();
			local.pools = local.gc.getMemoryPoolNames();
			local.activity = {
				'before' = local.previous.getMemoryUsageBeforeGc(),
				'after' = local.previous.getMemoryUsageBeforeGc()
			};

			local.temp = {
				'count' = local.gc.getCollectionCount(),
				'time' = local.gc.getCollectionTime(),
				'pool' = local.pools,
				'valid' = local.gc.isValid(),
				'previous' = {
					'duration' = local.previous.getDuration(),
					'start' = local.previous.getStartTime(),
					'end' = local.previous.getEndTime(),
					'id' = local.previous.getId(),
					'before' = {},
					'after' = {}
				}
			};

			for (local.when in local.activity) {
				for (local.pool in local.activity[local.when]) {
					// Filter out pools that aren't collected by this collector
					if (ArrayContains(local.pools, local.pool)) {
						local.temp.previous[local.when][local.pool] = {
							'committed' = local.activity[local.when][local.pool].getCommitted(),
							'initial' = local.activity[local.when][local.pool].getInit(),
							'used' = local.activity[local.when][local.pool].getUsed(),
							'max' = local.activity[local.when][local.pool].getMax()
						};
					}
				}
			}

			ArrayAppend(local.data, local.temp);
		}
		return local.data;
	}

	public struct function getOsMemory() {
		local.physicalFree = variables.jOperatingSystemMXBean.getFreePhysicalMemorySize();
		local.physicalTotal = variables.jOperatingSystemMXBean.getTotalPhysicalMemorySize();
		local.swapFree = variables.jOperatingSystemMXBean.getFreeSwapSpaceSize();
		local.swapTotal = variables.jOperatingSystemMXBean.getTotalSwapSpaceSize();
		return {
			'swap' = {
				'used' = local.swapTotal - local.swapFree,
				'max' = local.swapTotal,
				'committed' = variables.jOperatingSystemMXBean.getCommittedVirtualMemorySize()
			},
			'pyhsical' = {
				'used' = local.physicalTotal - local.physicalFree,
				'max' = local.physicalTotal
			}
		};
	}
}