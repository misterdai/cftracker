<cfscript>
	rrdPath = ExpandPath('./rrd/garbage.rrd');
	cfcRrdGraph = CreateObject('component', 'rrdGraph').init('-');
	cfcRrdGraph.setTimeSpan(DateAdd('h', -6, Now()));
	
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
	cfcRrdGraph.setHeight('300');
	cfcRrdGraph.setBase(1000);
	
	cfcRrdGraph.render();
	WriteOutput(cfcRrdGraph.imageTag());
	
	rrdPath = ExpandPath('./rrd/memory.rrd');
	cfcRrdGraph = CreateObject('component', 'rrdGraph').init('-');
	cfcRrdGraph.setTimeSpan(DateAdd('h', -6, Now()));
	
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
	cfcRrdGraph.setHeight('300');
	cfcRrdGraph.setBase(1024);
	
	cfcRrdGraph.render();
	WriteOutput(cfcRrdGraph.imageTag());
</cfscript>