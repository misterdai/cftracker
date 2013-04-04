component {
	public Threads function init() {
		variables.jThreadMXBean = CreateObject('java', 'java.lang.management.ManagementFactory').getThreadMXBean();
		variables.support = {
			cpuTime = variables.jThreadMXBean.isThreadCpuTimeSupported() && variables.jThreadMXBean.isThreadCpuTimeEnabled(),
			contentionMonitoring = variables.jThreadMXBean.isThreadContentionMonitoringSupported()
		};
		variables.jInteger = CreateObject('java', 'java.lang.Integer');
		return this;
	}

	public array function getThreads(
		required array filters,
		string sort = 'id',
		string direction = 'asc',
		numeric from = 1,
		numeric amount = 10
	) {
		/*
			The following code is probably overkill for threads, but wanted to
			be sure it'd scale as much as possible.
		*/
		
		/*
			This variable holds a information on each flag aspect.  Should it
			be retrieved for use in filtering or sorting and the type of sort
			required (number vs. text).
		 */
		local.aspects = {
			blockedCount = {
				retrieve = false,
				sortType = 'numeric'
			},
			blockedTime = {
				retrieve = false,
				sortType = 'numeric'
			},
			lockName = {
				retrieve = false,
				sortType = 'textnocase'
			},
			lockOwnerId = {
				retrieve = false,
				sortType = 'numeric'
			},
			id = {
				retrieve = true, // ID always required for sorting
				sortType = 'numeric'
			},
			name = {
				retrieve = false,
				sortType = 'textnocase'
			},
			state = {
				retrieve = false,
				sortType = 'textnocase'
			},
			waitedCount = {
				retrieve = false,
				sortType = 'numeric'
			},
			waitedTime = {
				retrieve = false,
				sortType = 'numeric'
			},
			isInNative = {
				retrieve = false,
				sortType = 'textnocase'
			},
			isSuspended = {
				retrieve = false,
				sortType = 'textnocase'
			},
			cpuTime = {
				retrieve = false,
				sortType = 'numeric'
			},
			userTime = {
				retrieve = false,
				sortType = 'numeric'
			}
		};

		// Iterate the filters to check which we need to retrieve
		for (local.f = ArrayLen(arguments.filters); local.f; local.f--) {
			local.aspects[arguments.filters[local.f].aspect].retrieve = true;
		}
		// Also retrieve the sort aspect
		local.aspects[arguments.sort].retrieve = true;

		local.preSort = {};
		local.threads = variables.jThreadMXBean.getThreadInfo(variables.jThreadMXBean.getAllThreadIds());
		local.count = ArrayLen(local.threads);
		// TODO: Filtering goes here
		for (local.i = local.count; local.i; local.i--) {
			local.temp = {
				id = local.threads[local.i].getThreadId(),
				row = local.i
			};
			if (local.aspects.blockedCount.retrieve)
				local.temp['blockedCount'] = local.threads[local.i].getBlockedCount();
			if (local.aspects.blockedTime.retrieve)
				local.temp['blockedTime'] = local.threads[local.i].getBlockedTime();
			if (local.aspects.lockName.retrieve)
				local.temp['lockName'] = local.threads[local.i].getLockName();
			if (local.aspects.lockOwnerId.retrieve)
				local.temp['lockOwnerId'] = local.threads[local.i].getLockOwnerId();
			if (local.aspects.name.retrieve)
				local.temp['name'] = local.threads[local.i].getThreadName();
			if (local.aspects.state.retrieve)
				local.temp['state'] = local.threads[local.i].getThreadState().toString();
			if (local.aspects.waitedCount.retrieve)
				local.temp['waitedCount'] = local.threads[local.i].getWaitedCount();
			if (local.aspects.waitedTime.retrieve)
				local.temp['waitedTime'] = local.threads[local.i].getWaitedTime();
			if (local.aspects.isInNative.retrieve)
				local.temp['isInNative'] = local.threads[local.i].isInNative();
			if (local.aspects.isSuspended.retrieve)
				local.temp['isSuspended'] = local.threads[local.i].isSuspended();
			if (local.aspects.cpuTime.retrieve)
				local.temp['cpuTime'] = variables.jThreadMXBean.getThreadCpuTime(local.threads[local.i].getThreadId());
			if (local.aspects.userTime.retrieve)
				local.temp['userTime'] = variables.jThreadMXBean.getThreadUserTime(local.threads[local.i].getThreadId());

			/*
				Run the filters against the thread information collected so
				far.  If anything doesn't match, throw it out.
			 */
			local.failed = false;
			for (local.f = ArrayLen(arguments.filters); local.f; local.f--) {
				local.filter = arguments.filters[local.f];

				if (local.aspects[local.filter.aspect].sortType == 'numeric') {
					// Numeric
					if (local.filter.condition == '>' && !(local.filter.value > local.temp[local.filter.aspect])) {
						local.failed = true;
					} else if (local.filter.condition == '<' && !(local.filter.value < local.temp[local.filter.aspect])) {
						local.failed = true;
					} else if (local.filter.condition == '>=' && !(local.filter.value >= local.temp[local.filter.aspect])) {
						local.failed = true;
					} else if (local.filter.condition == '<=' && !(local.filter.value <= local.temp[local.filter.aspect])) {
						local.failed = true;
					} else if (local.filter.condition == '==' && !(local.filter.value == local.temp[local.filter.aspect])) {
						local.failed = true;
					} else if (local.filter.condition == '!=' && !(local.filter.value != local.temp[local.filter.aspect])) {
						local.failed = true;
					}
				} else {
					// String
					if (local.filter.condition == 'regex' && !ReFindNoCase(local.filter.value, local.temp[local.filter.aspect])) {
						local.failed = true;
					} else if (local.filter.condition == 'equal' && local.filter.value != local.temp[local.filter.aspect]) {
						local.failed = true;
					} else if (local.filter.condition == 'contains' && !(local.temp[local.filter.aspect] CONTAINS local.filter.value)) {
						local.failed = true;
					}
				}

				if (local.failed) {
					StructDelete(local, 'temp');
					break;
				}
			}

			if (StructKeyExists(local, 'temp')) {
				// The thread wasn't filtered out so store the data.
				local.preSort[local.temp.id] = Duplicate(local.temp);
			}
		}

		// Perform sorting against the required thread infomation.
		local.keys = StructSort(
			local.preSort,
			local.aspects[arguments.sort].sortType,
			arguments.direction,
			arguments.sort
		);
		// Slice the array of sorted thread ID's for pagination.
		if (arguments.from > ArrayLen(local.keys)) {
			return [];
		}
		local.paged = local.keys.subList(arguments.from, Min(arguments.from + arguments.amount, ArrayLen(local.keys)));
		// Array used to return the data collected.		
		local.data = [];

		/*
			Loop over each thread ID left from being filtered, sorted and 
			paginated.  Grab any remaining data for those threads and copy into
			the return array.
		 */
		for (local.i = ArrayLen(local.paged); local.i; local.i--) {
			local.temp = local.preSort[local.paged[local.i]];
			if (Not local.aspects.blockedCount.retrieve)
				local.temp['blockedCount'] = local.threads[local.temp.row].getBlockedCount();
			if (Not local.aspects.blockedTime.retrieve)
				local.temp['blockedTime'] = local.threads[local.temp.row].getBlockedTime();
			if (Not local.aspects.lockName.retrieve)
				local.temp['lockName'] = local.threads[local.temp.row].getLockName();
			if (Not local.aspects.lockOwnerId.retrieve)
				local.temp['lockOwnerId'] = local.threads[local.temp.row].getLockOwnerId();
			if (Not local.aspects.name.retrieve)
				local.temp['name'] = local.threads[local.temp.row].getThreadName();
			if (Not local.aspects.state.retrieve)
				local.temp['state'] = local.threads[local.temp.row].getThreadState().toString();
			if (Not local.aspects.waitedCount.retrieve)
				local.temp['waitedCount'] = local.threads[local.temp.row].getWaitedCount();
			if (Not local.aspects.waitedTime.retrieve)
				local.temp['waitedTime'] = local.threads[local.temp.row].getWaitedTime();
			if (Not local.aspects.isInNative.retrieve)
				local.temp['isInNative'] = local.threads[local.temp.row].isInNative();
			if (Not local.aspects.isSuspended.retrieve)
				local.temp['isSuspended'] = local.threads[local.temp.row].isSuspended();
			if (Not local.aspects.cpuTime.retrieve)
				local.temp['cpuTime'] = variables.jThreadMXBean.getThreadCpuTime(local.temp.id);
			if (Not local.aspects.userTime.retrieve)
				local.temp['userTime'] = variables.jThreadMXBean.getThreadUserTime(local.temp.id);
			local.data[local.i] = local.temp;
			//local.data[local.i].stacktrace = local.threads[local.temp.row].getStackTrace();
		}
		return local.data;
	}

	public any function getStackTrace(
		required numeric threadId,
		boolean cfml=false,
		numeric maxDepth=variables.jInteger.MAX_VALUE
	) {
		local.stackTrace = variables.jThreadMXBean.getThreadInfo(arguments.threadId, JavaCast('int', arguments.maxDepth)).getStackTrace();
		local.processed = [];
		for (local.i = ArrayLen(local.stackTrace); local.i; local.i--) {
			local.methodName = local.stackTrace[local.i].getMethodName();
			local.className = local.stackTrace[local.i].getClassName();
			// TODO: May be different for Railo / OpenBD
			if (!arguments.cfml || (ListFindNoCase('runPage,runFunction', local.methodName) && Left(local.className, 2) == 'cf')) {
				ArrayPrepend(local.processed, {
					'className' = local.className,
					'fileName' = local.stackTrace[local.i].getFileName(),
					'lineNumber' = local.stackTrace[local.i].getLineNumber(),
					'methodName' = local.methodName,
					'nativeMethod' = local.stackTrace[local.i].isNativeMethod()
				});
			}
		}

		return local.processed;
	}

	public numeric function getDaemonCount() {
		return variables.jThreadMXBean.getDaemonThreadCount();
	}

	public numeric function getPeakCount() {
		return variables.jThreadMXBean.getPeakThreadCount();
	}

	public void function resetPeakCount() {
		variables.jThreadMXBean.resetPeakThreadCount();
	}

	public numeric function getCount() {
		return variables.jThreadMXBean.getThreadCount();
	}

	public numeric function getTotalStartedCount() {
		return variables.jThreadMXBean.getTotalStartedThreadCount();
	}

	public struct function getStats() {
		return {
			'Count' = variables.jThreadMXBean.getThreadCount(),
			'PeakCount' = variables.jThreadMXBean.getPeakThreadCount(),
			'DaemonCount' = variables.jThreadMXBean.getDaemonThreadCount(),
			'TotalStartedCount' = variables.jThreadMXBean.getTotalStartedThreadCount()
		};
	}
}


/*

variables.jThreadMXBean
	.findMonitorDeadlockedThreads()
	.findDeadlockedThreads()

coldfusion.server.jrun4.metrics.CfstatServer
 */