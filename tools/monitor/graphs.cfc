<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfargument name="baseDir" type="string" required="true" />
		<cfset variables.baseDir = arguments.baseDir />
		<cfset variables.imagePath = variables.baseDir & '/tools/monitor/images' />
		<cfset variables.rrdPath = variables.baseDir & '/tools/monitor/rrd' />
		<cfset variables.cfcRrdGraph = CreateObject('component', 'rrdGraph') />
		<cfset variables.height = 200 />
		<cfset variables.width = 350 />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="regenerate" output="false">
		<cflock name="#application.applicationName#-graphGen" type="exclusive" timeout="10">
			<cfif Not StructKeyExists(variables, 'lastUpdated') Or DateDiff('s', variables.lastUpdated, Now()) Gte application.cftracker.graphs.interval>
				<cfset variables.lastUpdated = Now() />
				<cfset variables.ts = DateDiff('s', CreateDate(1970, 1, 1), variables.lastUpdated) />
				<cfset variables.end = DateAdd('s', -ts % 300, variables.lastUpdated) />
				<cfset variables.start = {} />
				<cfset variables.start['day']   = DateAdd('d',    -1, variables.lastUpdated) />
				<cfset variables.start['week']  = DateAdd('ww',   -1, variables.lastUpdated) />
				<cfset variables.start['month'] = DateAdd('m',    -1, variables.lastUpdated) />
				<cfset variables.start['year']  = DateAdd('yyyy', -1, variables.lastUpdated) />
				<cfset variables.garbage() />
				<cfset variables.memory() />
				<cfset variables.misc() />
			</cfif>
		</cflock>
	</cffunction>
	
	<cffunction name="garbage" output="false">
		<cfscript>
			var lc = {};
			variables.cfcRrdGraph.init('-');
			variables.cfcRrdGraph.addDatasource('type1', variables.rrdPath & '/garbage.rrd', 'type1', 'average');
			variables.cfcRrdGraph.addDatasource('type2', variables.rrdPath & '/garbage.rrd', 'type2', 'average');

			variables.cfcRrdGraph.comment('               Maximum     Average     Minimum  ', true);
			
			variables.cfcRrdGraph.line(itemName = 'type1', colour = '007700aa', legend = 'Normal    ', width = 2);
			variables.cfcRrdGraph.gprint('type1', 'max', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('type1', 'average', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('type1', 'min', '%8.2lf %s', true);
			variables.cfcRrdGraph.line(itemName = 'type2', colour = 'ff0000aa', legend = 'Full      ', width = 2);
			variables.cfcRrdGraph.gprint('type2', 'max', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('type2', 'average', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('type2', 'min', '%8.2lf %s', true);

			variables.cfcRrdGraph.setMinValue(0);
			variables.cfcRrdGraph.setTitle('Garbage Collection activity');
			variables.cfcRrdGraph.setHeight(variables.height);
			variables.cfcRrdGraph.setWidth(variables.width);
			variables.cfcRrdGraph.setBase(1000);

			for (lc.view in variables.start) {
				variables.cfcRrdGraph.setFilename(variables.imagePath & '/garbage-' & lc.view & '.png');
				variables.cfcRrdGraph.setTimeSpan(variables.start[lc.view], variables.end);
				variables.cfcRrdGraph.render();
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="memory" output="false">
		<cfscript>
			var lc = {};
			lc.rrdPath = variables.rrdPath & '/memory.rrd';
			variables.cfcRrdGraph.init('-');
			variables.cfcRrdGraph.addDatasource('heapused', lc.rrdPath, 'heapused', 'average');
			variables.cfcRrdGraph.addDatasource('heapfree', lc.rrdPath, 'heapfree', 'average');
			variables.cfcRrdGraph.addDatasource('heapallo', lc.rrdPath, 'heapallo', 'average');
			variables.cfcRrdGraph.addDatasource('heapmax', lc.rrdPath, 'heapmax', 'average');

			variables.cfcRrdGraph.comment('               Maximum     Average     Minimum  ', true);
			
			variables.cfcRrdGraph.line(itemName = 'heapused', colour = '007777aa', legend = 'Used      ', width = 2);
			variables.cfcRrdGraph.gprint('heapused', 'max', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('heapused', 'average', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('heapused', 'min', '%8.2lf %s', true);
			variables.cfcRrdGraph.line(itemName = 'heapfree', colour = '00ff00aa', legend = 'Free      ', width = 2);
			variables.cfcRrdGraph.gprint('heapfree', 'max', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('heapfree', 'average', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('heapfree', 'min', '%8.2lf %s', true);
			variables.cfcRrdGraph.line(itemName = 'heapallo', colour = '0000ffaa', legend = 'Allocated ', width = 2);
			variables.cfcRrdGraph.gprint('heapallo', 'max', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('heapallo', 'average', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('heapallo', 'min', '%8.2lf %s', true);
			variables.cfcRrdGraph.line(itemName = 'heapmax', colour = 'ff0000aa', legend = 'Max       ', width = 2);
			variables.cfcRrdGraph.gprint('heapmax', 'max', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('heapmax', 'average', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('heapmax', 'min', '%8.2lf %s', true);

			variables.cfcRrdGraph.setMinValue(0);
			variables.cfcRrdGraph.setTitle('Heap memory usage');
			variables.cfcRrdGraph.setHeight(variables.height);
			variables.cfcRrdGraph.setWidth(variables.width);
			variables.cfcRrdGraph.setBase(1024);

			for (lc.view in variables.start) {
				variables.cfcRrdGraph.setFilename(variables.imagePath & '/memory-heap-' & lc.view & '.png');
				variables.cfcRrdGraph.setTimeSpan(variables.start[lc.view], variables.end);
				variables.cfcRrdGraph.render();
			}

			variables.cfcRrdGraph.init('-');
			variables.cfcRrdGraph.addDatasource('nonheapused', lc.rrdPath, 'nonheapused', 'average');
			variables.cfcRrdGraph.addDatasource('nonheapfree', lc.rrdPath, 'nonheapfree', 'average');
			variables.cfcRrdGraph.addDatasource('nonheapallo', lc.rrdPath, 'nonheapallo', 'average');
			variables.cfcRrdGraph.addDatasource('nonheapmax', lc.rrdPath, 'nonheapmax', 'average');

			variables.cfcRrdGraph.comment('               Maximum     Average     Minimum  ', true);
			
			variables.cfcRrdGraph.line(itemName = 'nonheapused', colour = '007777aa', legend = 'Used      ', width = 2);
			variables.cfcRrdGraph.gprint('nonheapused', 'max', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('nonheapused', 'average', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('nonheapused', 'min', '%8.2lf %s', true);
			variables.cfcRrdGraph.line(itemName = 'nonheapfree', colour = '00ff00aa', legend = 'Free      ', width = 2);
			variables.cfcRrdGraph.gprint('nonheapfree', 'max', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('nonheapfree', 'average', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('nonheapfree', 'min', '%8.2lf %s', true);
			variables.cfcRrdGraph.line(itemName = 'nonheapallo', colour = '0000ffaa', legend = 'Allocated ', width = 2);
			variables.cfcRrdGraph.gprint('nonheapallo', 'max', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('nonheapallo', 'average', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('nonheapallo', 'min', '%8.2lf %s', true);
			variables.cfcRrdGraph.line(itemName = 'nonheapmax', colour = 'ff0000aa', legend = 'Max       ', width = 2);
			variables.cfcRrdGraph.gprint('nonheapmax', 'max', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('nonheapmax', 'average', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('nonheapmax', 'min', '%8.2lf %s', true);

			variables.cfcRrdGraph.setMinValue(0);
			variables.cfcRrdGraph.setTitle('Non-Heap memory usage');
			variables.cfcRrdGraph.setHeight(variables.height);
			variables.cfcRrdGraph.setWidth(variables.width);
			variables.cfcRrdGraph.setBase(1024);

			for (lc.view in variables.start) {
				variables.cfcRrdGraph.setFilename(variables.imagePath & '/memory-nonheap-' & lc.view & '.png');
				variables.cfcRrdGraph.setTimeSpan(variables.start[lc.view], variables.end);
				variables.cfcRrdGraph.render();
			}
		</cfscript>
	</cffunction>

	<cffunction name="misc" output="false">
		<cfscript>
			var lc = {};
			lc.rrdPath = variables.rrdPath & '/misc.rrd';
			
			// Compilation Time
			variables.cfcRrdGraph.init('-');
			variables.cfcRrdGraph.addDatasource('comptime', lc.rrdPath, 'comptime', 'average');
			variables.cfcRrdGraph.comment('                 Maximum     Average     Minimum  ', true);
			
			variables.cfcRrdGraph.line(itemName = 'comptime', colour = '007700aa', legend = 'Compilation ', width = 2);
			variables.cfcRrdGraph.gprint('comptime', 'max', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('comptime', 'average', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('comptime', 'min', '%8.2lf %s', true);

			variables.cfcRrdGraph.setMinValue(0);
			variables.cfcRrdGraph.setTitle('Compilation activity');
			variables.cfcRrdGraph.setHeight(variables.height);
			variables.cfcRrdGraph.setWidth(variables.width);
			variables.cfcRrdGraph.setBase(1000);

			for (lc.view in variables.start) {
				variables.cfcRrdGraph.setFilename(variables.imagePath & '/compilation-' & lc.view & '.png');
				variables.cfcRrdGraph.setTimeSpan(variables.start[lc.view], variables.end);
				variables.cfcRrdGraph.render();
			}

			// CPU Usage
			variables.cfcRrdGraph.init('-');
			variables.cfcRrdGraph.addDatasource('cpuUsage', lc.rrdPath, 'cpuUsage', 'average');
			variables.cfcRrdGraph.addCDef('cputime', 'cpuUsage,1000000000,/');
			variables.cfcRrdGraph.comment('               Maximum     Average     Minimum  ', true);
			
			variables.cfcRrdGraph.line(itemName = 'cputime', colour = '007700aa', legend = 'CPU Usage ', width = 2);
			variables.cfcRrdGraph.gprint('cputime', 'max', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('cputime', 'average', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('cputime', 'min', '%8.2lf %s', true);

			variables.cfcRrdGraph.setMinValue(0);
			variables.cfcRrdGraph.setTitle('CPU usage');
			variables.cfcRrdGraph.setHeight(variables.height);
			variables.cfcRrdGraph.setWidth(variables.width);
			variables.cfcRrdGraph.setBase(1000);
			

			for (lc.view in variables.start) {
				variables.cfcRrdGraph.setFilename(variables.imagePath & '/cpu-' & lc.view & '.png');
				variables.cfcRrdGraph.setTimeSpan(variables.start[lc.view], variables.end);
				variables.cfcRrdGraph.render();
			}

			// Classes loaded
			variables.cfcRrdGraph.init('-');

			variables.cfcRrdGraph.addDatasource('classload', lc.rrdPath, 'classload', 'average');
			variables.cfcRrdGraph.comment('               Maximum     Average     Minimum  ', true);
			
			variables.cfcRrdGraph.line(itemName = 'classload', colour = '007700aa', legend = 'Classes   ', width = 2);
			variables.cfcRrdGraph.gprint('classload', 'max', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('classload', 'average', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('classload', 'min', '%8.2lf %s', true);

			variables.cfcRrdGraph.setMinValue(0);
			variables.cfcRrdGraph.setTitle('Total Classes Loaded');
			variables.cfcRrdGraph.setHeight(variables.height);
			variables.cfcRrdGraph.setWidth(variables.width);
			variables.cfcRrdGraph.setBase(1000);
			
			for (lc.view in variables.start) {
				variables.cfcRrdGraph.setFilename(variables.imagePath & '/class-total-' & lc.view & '.png');
				variables.cfcRrdGraph.setTimeSpan(variables.start[lc.view], variables.end);
				variables.cfcRrdGraph.render();
			}
			
			// Classes loading activity
			variables.cfcRrdGraph.init('-');

			variables.cfcRrdGraph.addDatasource('classtotal', lc.rrdPath, 'classtotal', 'average');
			variables.cfcRrdGraph.addDatasource('classunload', lc.rrdPath, 'classunload', 'average');
			variables.cfcRrdGraph.addCDef('classun', 'classunload,-1,*');
			variables.cfcRrdGraph.comment('               Maximum     Average     Minimum  ', true);

			variables.cfcRrdGraph.line(itemName = 'classtotal', colour = '770000aa', legend = 'Loading   ', width = 2);
			variables.cfcRrdGraph.gprint('classtotal', 'max', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('classtotal', 'average', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('classtotal', 'min', '%8.2lf %s', true);
			variables.cfcRrdGraph.line(itemName = 'classun', colour = '000077aa', legend = 'Unloading ', width = 2);
			variables.cfcRrdGraph.gprint('classun', 'max', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('classun', 'average', '%8.2lf %s');
			variables.cfcRrdGraph.gprint('classun', 'min', '%8.2lf %s', true);
			
			variables.cfcRrdGraph.setMinValue(0);
			variables.cfcRrdGraph.setTitle('Class Loading rates');
			variables.cfcRrdGraph.setHeight(variables.height);
			variables.cfcRrdGraph.setWidth(variables.width);
			variables.cfcRrdGraph.setBase(1000);
			
			for (lc.view in variables.start) {
				variables.cfcRrdGraph.setFilename(variables.imagePath & '/class-activity-' & lc.view & '.png');
				variables.cfcRrdGraph.setTimeSpan(variables.start[lc.view], variables.end);
				variables.cfcRrdGraph.render();
			}
		</cfscript>
	</cffunction>
</cfcomponent>