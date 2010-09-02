<style type="text/css">
	.body img {vertical-align:top; padding:5px;}
</style>
<div class="body">
<cfscript>
	rrdPath = ExpandPath('./rrd/garbage.rrd');
	cfcRrdGraph = CreateObject('component', 'rrdGraph').init('-');
	ts = GetTickCount() / 1000;
	start = DateAdd('h', -12, Now());
	end = DateAdd('s', -ts % 300, Now());
	
	cfcRrdGraph.setTimeSpan(start, end);
	
	cfcRrdGraph.addDatasource('type1', rrdPath, 'type1', 'average');
	cfcRrdGraph.addDatasource('type2', rrdPath, 'type2', 'average');
	
	cfcRrdGraph.comment('               Maximum     Average     Minimum  ', true);
	
	cfcRrdGraph.line(itemName = 'type1', colour = '007700aa', legend = 'Normal    ', width = 2);
	cfcRrdGraph.gprint('type1', 'max', '%8.2lf %s');
	cfcRrdGraph.gprint('type1', 'average', '%8.2lf %s');
	cfcRrdGraph.gprint('type1', 'min', '%8.2lf %s', true);
	cfcRrdGraph.line(itemName = 'type2', colour = 'ff0000aa', legend = 'Full      ', width = 2);
	cfcRrdGraph.gprint('type2', 'max', '%8.2lf %s');
	cfcRrdGraph.gprint('type2', 'average', '%8.2lf %s');
	cfcRrdGraph.gprint('type2', 'min', '%8.2lf %s', true);

	cfcRrdGraph.setMinValue(0);
	cfcRrdGraph.setTitle('GC Usage');
	cfcRrdGraph.setHeight('200');
	cfcRrdGraph.setBase(1000);
	
	cfcRrdGraph.render();
	WriteOutput(cfcRrdGraph.imageTag());
	
	rrdPath = ExpandPath('./rrd/memory.rrd');
	cfcRrdGraph = CreateObject('component', 'rrdGraph').init('-');
	cfcRrdGraph.setTimeSpan(start, end);
	
	cfcRrdGraph.addDatasource('heapused', rrdPath, 'heapused', 'average');
	cfcRrdGraph.addDatasource('heapfree', rrdPath, 'heapfree', 'average');
	cfcRrdGraph.addDatasource('heapallo', rrdPath, 'heapallo', 'average');
	cfcRrdGraph.addDatasource('heapmax', rrdPath, 'heapmax', 'average');
	cfcRrdGraph.addDatasource('nonheapused', rrdPath, 'nonheapused', 'average');
	cfcRrdGraph.addDatasource('nonheapfree', rrdPath, 'nonheapfree', 'average');
	cfcRrdGraph.addDatasource('nonheapallo', rrdPath, 'nonheapallo', 'average');
	cfcRrdGraph.addDatasource('nonheapmax', rrdPath, 'nonheapmax', 'average');
	
	cfcRrdGraph.comment('               Maximum     Average     Minimum  ', true);
	
	cfcRrdGraph.line(itemName = 'heapused', colour = '007700aa', legend = 'Heap Used ', width = 2);
	cfcRrdGraph.gprint('heapused', 'max', '%8.2lf %s');
	cfcRrdGraph.gprint('heapused', 'average', '%8.2lf %s');
	cfcRrdGraph.gprint('heapused', 'min', '%8.2lf %s', true);
	cfcRrdGraph.line(itemName = 'heapfree', colour = 'ff0000aa', legend = 'Heap Free ', width = 2);
	cfcRrdGraph.gprint('heapfree', 'max', '%8.2lf %s');
	cfcRrdGraph.gprint('heapfree', 'average', '%8.2lf %s');
	cfcRrdGraph.gprint('heapfree', 'min', '%8.2lf %s', true);
	cfcRrdGraph.line(itemName = 'nonheapused', colour = '000077aa', legend = 'Non Used  ', width = 2);
	cfcRrdGraph.gprint('nonheapused', 'max', '%8.2lf %s');
	cfcRrdGraph.gprint('nonheapused', 'average', '%8.2lf %s');
	cfcRrdGraph.gprint('nonheapused', 'min', '%8.2lf %s', true);
	cfcRrdGraph.line(itemName = 'nonheapfree', colour = 'ff00ffaa', legend = 'Non Free  ', width = 2);
	cfcRrdGraph.gprint('nonheapfree', 'max', '%8.2lf %s');
	cfcRrdGraph.gprint('nonheapfree', 'average', '%8.2lf %s');
	cfcRrdGraph.gprint('nonheapfree', 'min', '%8.2lf %s', true);

	cfcRrdGraph.setMinValue(0);
	cfcRrdGraph.setTitle('Memory');
	cfcRrdGraph.setHeight('200');
	cfcRrdGraph.setBase(1024);
	
	cfcRrdGraph.render();
	WriteOutput(cfcRrdGraph.imageTag());
	
	rrdPath = ExpandPath('./rrd/misc.rrd');
	cfcRrdGraph = CreateObject('component', 'rrdGraph').init('-');
	cfcRrdGraph.setTimeSpan(start, end);
	
	cfcRrdGraph.addDatasource('comptime', rrdPath, 'comptime', 'average');
	cfcRrdGraph.comment('               Maximum     Average     Minimum  ', true);
	
	cfcRrdGraph.line(itemName = 'comptime', colour = '007700aa', legend = 'Compilation ', width = 2);
	cfcRrdGraph.gprint('comptime', 'max', '%8.2lf %s');
	cfcRrdGraph.gprint('comptime', 'average', '%8.2lf %s');
	cfcRrdGraph.gprint('comptime', 'min', '%8.2lf %s', true);

	cfcRrdGraph.setMinValue(0);
	cfcRrdGraph.setTitle('Compilation Time');
	cfcRrdGraph.setHeight('200');
	cfcRrdGraph.setBase(1000);
	
	cfcRrdGraph.render();
	WriteOutput(cfcRrdGraph.imageTag());
	
	rrdPath = ExpandPath('./rrd/misc.rrd');
	cfcRrdGraph = CreateObject('component', 'rrdGraph').init('-');
	cfcRrdGraph.setTimeSpan(start, end);
	
	cfcRrdGraph.addDatasource('cpuUsage', rrdPath, 'cpuUsage', 'average');
	cfcRrdGraph.comment('               Maximum     Average     Minimum  ', true);
	
	cfcRrdGraph.line(itemName = 'cpuUsage', colour = '007700aa', legend = 'CPU ', width = 2);
	cfcRrdGraph.gprint('cpuUsage', 'max', '%8.2lf %s');
	cfcRrdGraph.gprint('cpuUsage', 'average', '%8.2lf %s');
	cfcRrdGraph.gprint('cpuUsage', 'min', '%8.2lf %s', true);

	cfcRrdGraph.setMinValue(0);
	cfcRrdGraph.setTitle('CPU Time');
	cfcRrdGraph.setHeight('200');
	cfcRrdGraph.setBase(1000);
	
	cfcRrdGraph.render();
	WriteOutput(cfcRrdGraph.imageTag());

	cfcRrdGraph = CreateObject('component', 'rrdGraph').init('-');
	cfcRrdGraph.setTimeSpan(start, end);
	
	cfcRrdGraph.addDatasource('classload', rrdPath, 'classload', 'average');
	cfcRrdGraph.comment('               Maximum     Average     Minimum  ', true);
	
	cfcRrdGraph.line(itemName = 'classload', colour = '007700aa', legend = 'Classes ', width = 2);
	cfcRrdGraph.gprint('classload', 'max', '%8.2lf %s');
	cfcRrdGraph.gprint('classload', 'average', '%8.2lf %s');
	cfcRrdGraph.gprint('classload', 'min', '%8.2lf %s', true);

	cfcRrdGraph.setMinValue(0);
	cfcRrdGraph.setTitle('Total Classes Loaded');
	cfcRrdGraph.setHeight('200');
	cfcRrdGraph.setBase(1000);
	
	cfcRrdGraph.render();
	WriteOutput(cfcRrdGraph.imageTag());

	cfcRrdGraph = CreateObject('component', 'rrdGraph').init('-');

	cfcRrdGraph.addDatasource('classtotal', rrdPath, 'classtotal', 'average');
	cfcRrdGraph.addDatasource('classunload', rrdPath, 'classunload', 'average');
	cfcRrdGraph.addCDef('classun', 'classunload,-1,*');
	cfcRrdGraph.comment('               Maximum     Average     Minimum  ', true);

	cfcRrdGraph.line(itemName = 'classtotal', colour = '770000aa', legend = 'Loading ', width = 2);
	cfcRrdGraph.gprint('classtotal', 'max', '%8.2lf %s');
	cfcRrdGraph.gprint('classtotal', 'average', '%8.2lf %s');
	cfcRrdGraph.gprint('classtotal', 'min', '%8.2lf %s', true);
	cfcRrdGraph.line(itemName = 'classun', colour = '000077aa', legend = 'Unloading ', width = 2);
	cfcRrdGraph.gprint('classun', 'max', '%8.2lf %s');
	cfcRrdGraph.gprint('classun', 'average', '%8.2lf %s');
	cfcRrdGraph.gprint('classun', 'min', '%8.2lf %s', true);

	cfcRrdGraph.setTimeSpan(start, end);
	cfcRrdGraph.setMinValue(0);
	cfcRrdGraph.setTitle('Class Loading rates');
	cfcRrdGraph.setHeight('200');
	cfcRrdGraph.setBase(1000);
	
	cfcRrdGraph.render();
	WriteOutput(cfcRrdGraph.imageTag());
</cfscript>
</div>