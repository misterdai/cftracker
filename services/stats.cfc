<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfscript>
			if (Not application.settings.demo) {
				variables.appTracker = CreateObject('component', 'cftracker.applications').init();
				variables.queryTracker = CreateObject('component', 'cftracker.querycache').init();
				variables.sessTracker = CreateObject('component', 'cftracker.sessions').init();
				variables.statTracker = CreateObject('component', 'cftracker.stats').init();
				variables.templateTracker = CreateObject('component', 'cftracker.templatecache').init();
				variables.threadTracker = CreateObject('component', 'cftracker.threads').init();
			}
		</cfscript>
	</cffunction>

	<cffunction name="default" output="false">
		<cfscript>
			var local = {};
			local.data = {};
			if (application.settings.demo) {
				local.data = application.data.stats;
			} else {
				local.data.server = variables.statTracker.getServerInfo();
				local.data.jdbc = variables.statTracker.getJdbcStats();
				local.data.compilation = variables.statTracker.getCompilationTime();
				local.data.classLoading = variables.statTracker.getClassLoading();
				local.data.cpuTime = variables.statTracker.getProcessCpuTime();
			}
			return local.data;
		</cfscript> 
	</cffunction>

	<cffunction name="graphs" output="false">
		<cfscript>
			var local = {};
			local.graphs = {};
			local.graphs.ts = DateFormat(Now(), 'yyyy-mm-dd ') & TimeFormat(Now(), 'hh:mm:ss');
			// Application sessions
			local.graphs['appsess'] = {};
			if (application.settings.demo) {
				local.apps = StructKeyArray(application.data.apps);
			} else {
				local.apps = variables.appTracker.getApps();
			}
			local.count = ArrayLen(local.apps);
			for (local.a = 1; local.a Lte local.count; local.a++) {
				if (application.settings.demo) {
					//local.graphs.appsess[local.apps[local.a]] = application.data.apps[local.apps[local.a]].metadata.sessionCount;
				} else {
					local.graphs.appsess[Replace(local.apps[local.a], '\', '\\', 'all')] = variables.sessTracker.getCount(local.apps[local.a]);
				}
			}
			// Memory
			local.graphs['memory'] = ';';
			if (application.settings.demo) {
				local.mem = application.data.stats.mem;
			} else {
				local.mem = variables.statTracker.getMemory();
			}
			// Divide all values into MiB for easier graphical display
			local.graphs.memory &= NumberFormat(local.mem.heap.usage.used / 1024^2, '.00');
			local.graphs.memory &= ';' & NumberFormat(local.mem.heap.usage.max / 1024^2, '.00');
			local.graphs.memory &= ';' & NumberFormat(local.mem.heap.usage.committed / 1024^2, '.00');
			// Cache hits
			local.graphs['caches'] = '';
			if (application.settings.demo) {
				local.graphs.caches &= ';' & NumberFormat(application.data.templateCache.hitRatio, '.000');
				local.graphs.caches &= ';' & NumberFormat(application.data.queryCache.hitRatio, '.000');
			} else {
				local.graphs.caches &= ';' & NumberFormat(variables.templateTracker.getClassHitRatio(), '.000');
				local.graphs.caches &= ';' & NumberFormat(variables.queryTracker.getHitRatio(), '.000');
			}
			// Threads
			local.graphs['threads'] = {};
			if (application.settings.demo) {
				local.items = application.data.threadGroups;
			} else {
				local.items = variables.threadTracker.countByGroup();
			}
			for (local.key in local.items) {
				local.graphs.threads[local.key] = local.items[local.key];
			}
			// Return data
			return local.graphs;
		</cfscript>
	</cffunction>
</cfcomponent>