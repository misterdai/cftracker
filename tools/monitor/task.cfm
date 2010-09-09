<cfset timer = GetTickCount() />
<cfset log = application.logbox.getLogger('Task') />
<cfset log.info('Monitor Task started') />
<cfif server.coldfusion.productName Eq 'BlueDragon'>
	<cfset ts = DateDiff('s', CreateDate(1970, 1, 1), Now()) />
<cfelse>
	<cfset ts = Round(GetTickCount() / 1000) />
</cfif>
<cflock name="#application.applicationName#-Monitoring-Task" timeout="1" throwOnTimeout="true">
	<cfif StructKeyExists(application, 'last') And ts - application.last Lte 30>
		Not Executed, more time needs to elapse between executions.
		<cfset log.warn('Task executed too soon (' & ts - application.last & ' seconds) from last execution.') />
		<cfabort>
	</cfif>
	<cfset application.last = ts />
</cflock>
<cfscript>
	cfcStats = CreateObject('component', 'cftrackerbase.stats').init();
	gcInfo = cfcStats.getGarbage();
	memInfo = cfcStats.getMemory();
	classInfo = cfcStats.getClassLoading();
	cpuInfo = cfcStats.getProcessCpuTime();
	compInfo = cfcStats.getCompilationTime();
	log.info('Retrieved Statistics');
	
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
		log.setCategory('Task');
		log.info('Garbage RRD file created');
	}
		
	data = [
		ts
		& ':' & gcInfo[1].collections
		& ':' & gcInfo[2].collections
	];
	cfcRrdDb.addData(data);
	log.setCategory('Data');
	log.info('TS:normalCollections:fullCollections');
	log.info(data[1]);
	
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
		log.category('Task');
		log.info('Memory RRD file created');
	}
	
	temp = [
		ts,
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
	log.setCategory('Data');
	log.info('TS:heapUsed:heapFree:heapAllocated:heapMax:nonheapUsed:nonheapFree:nonheapAllocated:nonheapMax');
	log.info(data[1]);
	
	rrdPath = ExpandPath('./rrd/os.rrd');
	cfcRrdDb.setFilename(rrdPath);
	if (Not FileExists(rrdPath)) {
		datasources = [
			'DS:vmcommit:GAUGE:600:0:U',
			'DS:phyfree:GAUGE:600:0:U',
			'DS:phyused:GAUGE:600:0:U',
			'DS:phytotal:GAUGE:600:0:U',
			'DS:swapfree:GAUGE:600:0:U',
			'DS:swapused:GAUGE:600:0:U',
			'DS:swaptotal:GAUGE:600:0:U'
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
		log.setCategory('Task');
		log.info('OS RRD file created');
	}

	temp = [
		ts,
		memInfo.os.vmCommitted,
		memInfo.os.physicalFree,
		memInfo.os.physicalUsed,
		memInfo.os.physicalTotal,
		memInfo.os.swapFree,
		memInfo.os.swapUsed,
		memInfo.os.swapTotal
	];
	data = [ArrayToList(temp, ':')];
	cfcRrdDb.addData(data);
	log.setCategory('Data');
	log.info('TS:vmCommitted:physicalFree:physicalUsed:physicalTotal:swapFree:swapUsed:swapTotal');
	log.info(data[1]);
	
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
		log.setCategory('Task');
		log.info('Misc RRD file created');
	}

	temp = [
		ts,
		compInfo,
		classInfo.current,
		classInfo.total,
		classInfo.unloaded,
		cpuInfo
	];
	data = [ArrayToList(temp, ':')];
	cfcRrdDb.addData(data);
	log.setCategory('Data');
	log.info('TS:Compilation Time:Class Loaded:Class Total:Class Unloaded:CPU Time');
	log.info(data[1]);

	log.setCategory('Task');
	log.info('Monitor Task complete (' & NumberFormat(GetTickCount() - timer) & ' ms)');
</cfscript>Ok