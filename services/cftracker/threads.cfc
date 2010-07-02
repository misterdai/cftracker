<cfcomponent output="false">
	<cffunction name="init" output="false" access="public">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getThreads" access="public" output="false">
		<cfargument name="groupName" type="string" required="false" />
		<cfscript>
			var local = {};
			local.data = [];
			// Retrieve current thread
			local.cThread = CreateObject('java', 'java.lang.Thread').currentThread();
			// Get it's thread group
			local.tempGroup = local.cThread.getThreadGroup();
			while (StructKeyExists(local, 'tempGroup')) {
				local.tGroup = local.tempGroup;
				local.tempGroup = local.tempGroup.getParent();
			}
			// Setup an array of a thread group class
			local.groups = CreateObject('java', 'java.lang.reflect.Array').newInstance(local.tGroup.getClass(), local.tGroup.activeGroupCount());
			// Retrieve an array of groups
			local.tGroup.enumerate(local.groups);
			local.gLen = ArrayLen(local.groups);
			for (local.g = 1; local.g Lte local.gLen; local.g++) {
				local.groupName = local.groups[local.g].getName();
				//abort(local.cThread.getClass().getSuperClass().getName(), local.groups[local.g].activeCount());
				local.threads = CreateObject('java', 'java.lang.reflect.Array').newInstance(local.cThread.getClass().getSuperClass(), local.groups[local.g].activeCount());
				local.groups[local.g].enumerate(local.threads);
				local.tLen = ArrayLen(local.threads);
				for (local.t = 1; local.t Lte local.tLen; local.t++) {
					local.class = local.threads[local.t].getClass().getName();
					local.tInfo = {};
					local.tInfo.group = local.groupName;
					local.tInfo.class = local.class;
					local.tInfo.name = local.threads[local.t].getName();
					local.tInfo.id = local.threads[local.t].getId();
					local.tInfo.priority = local.threads[local.t].getPriority();
					local.tInfo.state = local.threads[local.t].getState().toString();
					local.tInfo.isAlive = local.threads[local.t].isAlive();
					local.tInfo.isDaemon = local.threads[local.t].isDaemon();
					local.tInfo.isInterrupted = local.threads[local.t].isInterrupted();
					local.tInfo.currentTimeMillis = '';
					local.tInfo.isShutdown = '';
					local.tInfo.startTime = '';
					local.tInfo.methodTiming = '';
					local.tInfo.file = '';
					if (local.class Eq 'jrunx.scheduler.WorkerThread') {
						local.tInfo.currentTimeMillis = local.threads[local.t].currentTimeMillis();
						local.tInfo.isShutdown = local.threads[local.t].isShutdown();
					} else if (local.class Eq 'coldfusion.scheduling.WorkerThread') {
						local.tInfo.currentTimeMillis = local.threads[local.t].currentTimeMillis();
						local.tInfo.isShutdown = local.threads[local.t].isShutdown();
						local.tInfo.methodTiming = local.threads[local.t].isMethodTimingEnabled();
						local.tInfo.startTime = local.threads[local.t].getStartTime();
					}
					if (local.groups[local.g].getName() Eq 'jrpp') {
						local.st = local.threads[local.t].getStackTrace();
						local.sLen = ArrayLen(local.st);
						for (local.s = 1; local.s Lte local.sLen; local.s++) {
							if (local.st[local.s].getMethodName() Eq 'runPage') {
								local.tInfo.file = local.st[local.s].getFileName();
							}
						}
					}
					ArrayAppend(local.data, local.tInfo);
				}
			}
			return local.data;
		</cfscript>
	</cffunction>
	
	<cffunction name="countByGroup" access="public" output="false">
		<cfscript>
			var local = {};
			local.data = {};
			// Retrieve current thread
			local.cThread = CreateObject('java', 'java.lang.Thread').currentThread();
			// Get it's thread group
			local.tempGroup = local.cThread.getThreadGroup();
			while (StructKeyExists(local, 'tempGroup')) {
				local.tGroup = local.tempGroup;
				local.tempGroup = local.tempGroup.getParent();
			}
			// Setup an array of a thread group class
			local.groups = CreateObject('java', 'java.lang.reflect.Array').newInstance(local.tGroup.getClass(), local.tGroup.activeGroupCount());
			// Retrieve an array of groups
			local.tGroup.enumerate(local.groups);
			local.gLen = ArrayLen(local.groups);
			for (local.g = 1; local.g Lte local.gLen; local.g++) {
				local.groupName = local.groups[local.g].getName();
				local.data[local.groupName] = local.groups[local.g].activeCount();
			}
			return local.data;
		</cfscript>
	</cffunction>
</cfcomponent>