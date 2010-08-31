<cfdump var="#expandPath('cftrackerbase')#" />
<cfscript>
	cfcStats = CreateObject('component', 'cftrackerbase.stats').init();

	rrdPath = ExpandPath('./rrd/garbage.rrd');
	cfcRrdDb = CreateObject('component', 'rrdDb').init(rrdPath);
	if (Not FileExists(rrdPath)) {
		datasources = [
			'DS:type1:DERIVE:600:0:U',
			'DS:type2:DERIVE:600:0:U'
		];
		
		archives = [
			'RRA:AVERAGE:0.5:1:576',
			'RRA:AVERAGE:0.5:6:672',
			'RRA:AVERAGE:0.5:24:732',
			'RRA:AVERAGE:0.5:144:1460',
			'RRA:MIN:0.5:1:576',
			'RRA:MIN:0.5:6:672',
			'RRA:MIN:0.5:24:732',
			'RRA:MIN:0.5:144:1460',
			'RRA:MAX:0.5:1:576',
			'RRA:MAX:0.5:6:672',
			'RRA:MAX:0.5:24:732',
			'RRA:MAX:0.5:144:1460'
		];
		
		cfcRrdDb.create(
			Now(),
			datasources,
			archives
		);
	}
	
	gcInfo = cfcStats.getGarbage();
	
	data = [
		Round(GetTickCount() / 1000)
		& ':' & gcInfo[1].collections
		& ':' & gcInfo[2].collections
	];
	cfcRrdDb.addData(data);
	
	rrdPath = ExpandPath('./rrd/memory.rrd');
	cfcRrdDb.setFilename(rrdPath);
	if (Not FileExists(rrdPath)) {
		datasources = [
			'DS:heapused:GAUGE:600:0:U',
			'DS:heapfree:GAUGE:600:0:U',
			'DS:heapallo:GAUGE:600:0:U',
			'DS:heapmax:GAUGE:600:0:U',
			'DS:nonheapused:GAUGE:600:0:U',
			'DS:nonheapfree:GAUGE:600:0:U',
			'DS:nonheapallo:GAUGE:600:0:U',
			'DS:nonheapmax:GAUGE:600:0:U'
		];
		
		archives = [
			'RRA:AVERAGE:0.5:1:576',
			'RRA:AVERAGE:0.5:6:672',
			'RRA:AVERAGE:0.5:24:732',
			'RRA:AVERAGE:0.5:144:1460',
			'RRA:MIN:0.5:1:576',
			'RRA:MIN:0.5:6:672',
			'RRA:MIN:0.5:24:732',
			'RRA:MIN:0.5:144:1460',
			'RRA:MAX:0.5:1:576',
			'RRA:MAX:0.5:6:672',
			'RRA:MAX:0.5:24:732',
			'RRA:MAX:0.5:144:1460'
		];
		
		cfcRrdDb.create(
			Now(),
			datasources,
			archives
		);
	}
	
	memInfo = cfcStats.getMemory();
	
	temp = [
		Round(GetTickCount() / 1000),
		memInfo.heap.usage.used,
		memInfo.heap.usage.free,
		memInfo.heap.usage.committed,
		memInfo.heap.usage.max,
		memInfo.nonheap.usage.used,
		memInfo.nonheap.usage.free,
		memInfo.nonheap.usage.committed,
		memInfo.nonheap.usage.max
	];
	data = [ArrayToList(temp, ':')];
	cfcRrdDb.addData(data);
	
	rrdPath = ExpandPath('./rrd/misc.rrd');
	cfcRrdDb.setFilename(rrdPath);
	if (Not FileExists(rrdPath)) {
		datasources = [
			'DS:comptime:DERIVE:600:0:U',
			'DS:classload:GAUGE:600:0:U',
			'DS:classtotal:DERIVE:600:0:U',
			'DS:classunload:DERIVE:600:0:U',
			'DS:cpuUsage:DERIVE:600:0:U'
		];
		
		archives = [
			'RRA:AVERAGE:0.5:1:576',
			'RRA:AVERAGE:0.5:6:672',
			'RRA:AVERAGE:0.5:24:732',
			'RRA:AVERAGE:0.5:144:1460',
			'RRA:MIN:0.5:1:576',
			'RRA:MIN:0.5:6:672',
			'RRA:MIN:0.5:24:732',
			'RRA:MIN:0.5:144:1460',
			'RRA:MAX:0.5:1:576',
			'RRA:MAX:0.5:6:672',
			'RRA:MAX:0.5:24:732',
			'RRA:MAX:0.5:144:1460'
		];
		
		cfcRrdDb.create(
			Now(),
			datasources,
			archives
		);
	}
	
	classInfo = cfcStats.getClassLoading();
	
	temp = [
		Round(GetTickCount() / 1000),
		cfcStats.getCompilationTime(),
		classInfo.current,
		classInfo.total,
		classInfo.unloaded,
		cfcStats.getProcessCpuTime()
	];
	data = [ArrayToList(temp, ':')];
	cfcRrdDb.addData(data);

</cfscript>