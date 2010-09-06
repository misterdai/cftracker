<cfscript>
	// Variables: cftracker
	cftracker = {};

	cftracker.server = ListFirst(server.coldfusion.productName, ' ');
	
	cftracker.release = {
		version = '2.2 Beta 1',
		date = CreateDate(2010, 9, 6)
	};

	// Configuration file version.  This is planned for auto upgrading settings.
	cftracker.config.version = 1;

	// The following is every feature.
	cftracker.support = {};
	cftracker.support.apps = {
		enabled			= true
	};
	cftracker.support.apps.data = {
		sessionCount	= true,
		scope			= true,
		settings		= true,
		expired			= true,
		lastAccessed	= true,
		idleTimeout		= true,
		timeAlive		= true,
		isinited		= true
	};
	cftracker.support.apps.actions = {
		stop			= true,
		stopSessions	= true,
		stopBoth		= true,
		restart			= true,
		refresh			= true
	};
	cftracker.support.sess = {
		enabled			= true,
		table			= true,
		form			= true
	};
	cftracker.support.sess.data = {
		scope			= true,
		expired			= true,
		lastAccessed	= true,
		idleTimeout		= true,
		timeAlive		= true,
		isJ2eeSession	= true,
		clientIp		= true,
		idFromUrl		= true
	};
	cftracker.support.sess.actions = {
		stop			= true,
		refresh			= true
	};
	cftracker.support.qc = {
		enabled			= true,
		table			= true,
		form			= true
	};
	cftracker.support.qc.data = {
		queryName		= true,
		creation		= true,
		sql				= true,
		params			= true,
		results			= true
	};
	cftracker.support.qc.actions = {
		purge			= true,
		purgeAll		= true,
		refresh			= true
	};
	cftracker.support.mem = {
		enabled			= true
	};
	cftracker.support.stats = {
		enabled			= true,
		cfmservlet		= true,
		jdbc			= true,
		other			= true,
		mdLoad			= true,
		gmdAvgReqTime	= true,
		gmdPrevReqTime	= true,
		gmdPerfMon		= true
	};
	cftracker.support.threads = {
		enabled			= true
	};
	cftracker.support.dashboard = {
		appsess			= true,
		memory			= true,
		cacheHitRatios	= true,
		threadGroups	= true
	};
	if (cftracker.server Eq 'ColdFusion') {
		// Adobe ColdFusion currently supports all features
	} else if (cftracker.server Eq 'Railo') {
		// Application differences
		cftracker.support.apps.data.settings		= false;
		cftracker.support.apps.data.timeAlive		= false;
		cftracker.support.apps.data.isinited		= false;
		
		cftracker.support.apps.actions.stopSessions = false;
		cftracker.support.apps.actions.stopBoth		= false;
		cftracker.support.apps.actions.restart		= false;
		
		// Session differences
		cftracker.support.sess.form					= false;

		cftracker.support.sess.data.expired			= false;
		cftracker.support.sess.data.lastAccessed	= false;
		cftracker.support.sess.data.idleTimeout		= false;
		cftracker.support.sess.data.timeAlive		= false;
		cftracker.support.sess.data.isJ2eeSession	= false;
		cftracker.support.sess.data.clientIp		= false;
		cftracker.support.sess.data.idFromUrl		= false;

		cftracker.support.sess.actions.stop			= false;
		cftracker.support.sess.actions.refresh		= false;

		// Query Cache
		cftracker.support.qc.enabled				= false;
		cftracker.support.qc.table					= false;
		cftracker.support.qc.form					= false;
		cftracker.support.qc.data.queryName			= false;
		cftracker.support.qc.data.creation			= false;
		cftracker.support.qc.data.sql				= false;
		cftracker.support.qc.data.params			= false;
		cftracker.support.qc.data.results			= false;
		cftracker.support.qc.actions.purge			= false;
		cftracker.support.qc.actions.purgeAll		= false;
		cftracker.support.qc.actions.refresh		= false;

		cftracker.support.stats.cfmservlet			= false;
		cftracker.support.stats.jdbc				= false;
		cftracker.support.dashboard.cacheHitRatios	= false;
	} else if (cftracker.server Eq 'ODB') {
		// Open Blue Dragon, not yet tested and don't know the server string
	} else {
		// Other CFML engines aren't supported.
	}
	
	cftracker.demo = {};
	cftracker.demo.interval = 120;
	cftracker.demo.apps = {
		min = 2,
		max = 10,
		timeout = CreateTimeSpan(0, 2, 0, 0),
		createChance = 10
	};
	cftracker.demo.sess = {
		min = 1,
		max = 10,
		timeout = CreateTimeSpan(0, 0, 20, 0),
		createChance = 10,
		hitChance = 20
	};
	cftracker.demo.queries = {
		items = 10,
		hitChance = 10
	};
	
	cftracker.graphs = {
		interval = 300,
		offset = 60
	};
</cfscript>