<cfcomponent output="false">
	<cffunction name="init" output="false" access="public">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getThreads" access="public" output="false">
		<cfargument name="groupName" type="string" required="false" />
		<cfscript>
			var lc = {};
			lc.data = [];
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
				//abort(lc.cThread.getClass().getSuperClass().getName(), lc.groups[lc.g].activeCount());
				lc.threads = CreateObject('java', 'java.lang.reflect.Array').newInstance(lc.cThread.getClass().getSuperClass(), lc.groups[lc.g].activeCount());
				lc.groups[lc.g].enumerate(lc.threads);
				lc.tLen = ArrayLen(lc.threads);
				for (lc.t = 1; lc.t Lte lc.tLen; lc.t++) {
					lc.class = lc.threads[lc.t].getClass().getName();
					lc.tInfo = {};
					lc.tInfo.group = lc.groupName;
					lc.tInfo.class = lc.class;
					lc.tInfo.name = lc.threads[lc.t].getName();
					lc.tInfo.id = lc.threads[lc.t].getId();
					lc.tInfo.priority = lc.threads[lc.t].getPriority();
					lc.tInfo.state = lc.threads[lc.t].getState().toString();
					lc.tInfo.isAlive = lc.threads[lc.t].isAlive();
					lc.tInfo.isDaemon = lc.threads[lc.t].isDaemon();
					lc.tInfo.isInterrupted = lc.threads[lc.t].isInterrupted();
					lc.tInfo.currentTimeMillis = '';
					lc.tInfo.isShutdown = '';
					lc.tInfo.startTime = '';
					lc.tInfo.methodTiming = '';
					lc.tInfo.file = '';
					if (lc.class Eq 'jrunx.scheduler.WorkerThread') {
						lc.tInfo.currentTimeMillis = lc.threads[lc.t].currentTimeMillis();
						lc.tInfo.isShutdown = lc.threads[lc.t].isShutdown();
					} else if (lc.class Eq 'coldfusion.scheduling.WorkerThread') {
						lc.tInfo.currentTimeMillis = lc.threads[lc.t].currentTimeMillis();
						lc.tInfo.isShutdown = lc.threads[lc.t].isShutdown();
						lc.tInfo.methodTiming = lc.threads[lc.t].isMethodTimingEnabled();
						lc.tInfo.startTime = lc.threads[lc.t].getStartTime();
					}
					if (lc.groups[lc.g].getName() Eq 'jrpp') {
						lc.st = lc.threads[lc.t].getStackTrace();
						lc.sLen = ArrayLen(lc.st);
						for (lc.s = 1; lc.s Lte lc.sLen; lc.s++) {
							if (lc.st[lc.s].getMethodName() Eq 'runPage') {
								lc.tInfo.file = lc.st[lc.s].getFileName();
							}
						}
					}
					ArrayAppend(lc.data, lc.tInfo);
				}
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