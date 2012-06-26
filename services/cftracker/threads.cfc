<cfcomponent output="false">
	<cffunction name="init" output="false" access="public">
		<cfset variables.jMgmt = CreateObject('java', 'java.lang.management.ManagementFactory') />
		<cfset variables.jThreads = variables.jMgmt.getThreadMXBean() />
		<cfset variables.int = CreateObject('java', 'java.lang.Integer') />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getThreads" access="public" output="false">
		<cfscript>
			var lc = {};
			lc.expected = ['blockedCount', 'blockedTime', 'lockName', 'lockOwnerId', 'threadId', 'threadName', 'threadState', 'waitedCount', 'waitedTime', 'isInNative', 'isSuspended', 'threadCputime', 'threadUserTime'];
			lc.eLen = ArrayLen(lc.expected);
			lc.data = [];
			lc.threads = variables.jThreads.getThreadInfo(variables.jThreads.getAllThreadIds(), variables.int.MAX_VALUE);
			lc.tLen = ArrayLen(lc.threads);
			for (lc.i = 1; lc.i Lte lc.tLen; lc.i++) {
				lc.temp = {
					blockedCount	= lc.threads[lc.i].getBlockedCount(),
					blockedTime		= lc.threads[lc.i].getBlockedTime(),
					lockName		= lc.threads[lc.i].getLockName(),
					lockOwnerId		= lc.threads[lc.i].getLockOwnerId(),
					threadId		= lc.threads[lc.i].getThreadId(),
					threadName		= lc.threads[lc.i].getThreadName(),
					threadState		= lc.threads[lc.i].getThreadState().toString(),
					waitedCount		= lc.threads[lc.i].getWaitedCount(),
					waitedTime		= lc.threads[lc.i].getWaitedTime(),
					isInNative		= lc.threads[lc.i].isInNative(),
					isSuspended		= lc.threads[lc.i].isSuspended(),
					ThreadCpuTime	= variables.jThreads.getThreadCpuTime(lc.threads[lc.i].getThreadId()),
					ThreadUserTime	= variables.jThreads.getThreadUserTime(lc.threads[lc.i].getThreadId())
				};
				for (lc.e = 1; lc.e Lte lc.eLen; lc.e++) {
					if (Not StructKeyExists(lc.temp, lc.expected[lc.e])) {
						lc.temp[lc.expected[lc.e]] = '';
					}
				}
				lc.temp.stackTrace = [];
				lc.temp.cfFiles = [];
				lc.stackTrace = lc.threads[lc.i].getStackTrace();
				lc.sLen = ArrayLen(lc.stackTrace);
				for (lc.s = 1; lc.s Lte lc.sLen; lc.s++) {
					lc.temp2 = {
						className		= lc.stackTrace[lc.s].getClassName(),
						fileName		= lc.stackTrace[lc.s].getFileName(),
						lineNumber		= lc.stackTrace[lc.s].getLineNumber(),
						methodName		= lc.stackTrace[lc.s].getMethodName(),
						isNativeMethod	= lc.stackTrace[lc.s].isNativeMethod()
					};
					if (Not StructKeyExists(lc.temp2, 'fileName')) {
						lc.temp2.fileName = '';
					}
					ArrayAppend(lc.temp.stackTrace, lc.temp2);
					if (ListFindNoCase('cfc,cfm', ListLast(lc.temp2.fileName, '.'))) {
						ArrayAppend(lc.temp.cfFiles, lc.temp2.fileName & '@' & lc.temp2.lineNumber);
					}
				}
				ArrayAppend(lc.data, lc.temp);
			}
			return lc.data;
		</cfscript>
	</cffunction>
	
	<cffunction name="countByGroup" access="public" output="false">
		<cfscript>
			var lc = {};
			lc.data = {};
			// Retrieve current thread
			lc.cThread = CreateObject('java', 'java.lang.Thread').currentThread();
			// Get it's thread group
			lc.tempGroup = lc.cThread.getThreadGroup();
			while (StructKeyExists(lc, 'tempGroup')) {
				lc.tGroup = lc.tempGroup;
				lc.tempGroup = lc.tempGroup.getParent();
			}
			// Setup an array of a thread group class
			lc.groups = CreateObject('java', 'java.lang.reflect.Array').newInstance(lc.tGroup.getClass(), lc.tGroup.activeGroupCount());
			// Retrieve an array of groups
			lc.tGroup.enumerate(lc.groups);
			lc.gLen = ArrayLen(lc.groups);
			for (lc.g = 1; lc.g Lte lc.gLen; lc.g++) {
				lc.groupName = lc.groups[lc.g].getName();
				lc.data[lc.groupName] = lc.groups[lc.g].activeCount();
			}
			return lc.data;
		</cfscript>
	</cffunction>
</cfcomponent>