<!---
	Variables used
	fakeFunction, temp, fake
--->

<cffunction name="fakeFunction" output="false" hint="Fake hint" description="Fake Description">
	<cfargument name="fake" type="string" required="true" />
	<cfargument name="unreal" type="numeric" required="false" default="123" />
	<cfargument name="fictional" type="struct" required="false" />
</cffunction>

<cfscript>
	temp = {};
	temp.ff = variables.fakeFunction;
	StructDelete(variables, 'fakeFunction');
	fake = {};
	fake.apps = {};
	fake.queries = {};
	fake.threads = {};
	fake.stats = {};
	// Application 1
		temp.name = 'cfadmin';
		fake.apps[temp.name] = {};
		// Scope
		fake.apps[temp.name].scope = {};
		fake.apps[temp.name].scope['applicationname'] = 'cfadmin';
		// Settings
		fake.apps[temp.name].settings = {
			clientManagement = 'NO',
			loginStorage = 'cookie',
			name = 'cfadmin',
			sessionManagement = 'YES',
			sessiontimeout = 21600,
			setClientCookies = 'YES',
			setDomainCookies = 'NO'
		};
		// Sessions
		fake.apps[temp.name].sessions = {};
		// Metadata
		fake.apps[temp.name].metadata = {
			expired = 'NO',
			lastaccessed = Now(),
			idleTimeout = DateAdd('n', 60, Now()),
			timeAlive = Now(),
			isInited = 'NO',
			sessionCount = 10,
			idlePercent = 0
		};
		// Sessions
		fake.apps[temp.name].sessions = {};
		for (temp.i = 1; temp.i Lte 10; temp.i++) {
			// Create fake id's
			temp.cfid = RandRange(10000, 99999);
			temp.cftoken = LCase(Left(Hash(Rand(), 'md5'), 16)) & '_' & CreateUUID();
			temp.id = temp.name & '_' & temp.cfid & '_' & temp.cftoken;
			fake.apps[temp.name].sessions[temp.id] = {};
			// metadata
			fake.apps[temp.name].sessions[temp.id].metadata = {
				expired = 'NO',
				lastaccessed = Now(),
				idleTimeout = DateAdd('n', 30, NOW()),
				timeAlive = Now(),
				isJ2eeSession = false,
				clientIp = RandRange(1, 254) & '.' & RandRange(1, 254) & '.' & RandRange(1, 254) & '.' & RandRange(1, 254),
				idFromUrl = 'NO',
				exists = true
			};
			// scope
			fake.apps[temp.name].sessions[temp.id].scope = {
				sessionid = UCase(temp.name) & '_' & temp.cfid & '_' & temp.cftoken,
				cfid = temp.cfid,
				cftoken = temp.cftoken,
				urltoken = 'CFID=' & temp.cfid & '&CFTOKEN=' & temp.cftoken
			};
		}
	
	// Application 2
		temp.name = 'cftracker';
		fake.apps[temp.name] = {};
		// Scope
		fake.apps[temp.name].scope = {
			applicationName = 'cftracker',
			cfide = false,
			loginattempts = 0,
			logindate = Now()
		};
		fake.apps[temp.name].scope['org.corfield.framework'] = {};
		fake.apps[temp.name].scope['org.corfield.framework'].cache.controllers = {};
		fake.apps[temp.name].scope['org.corfield.framework'].cache.services = {};
		fake.apps[temp.name].scope['org.corfield.framework'].cache.lastreload = Now();
		fake.apps[temp.name].scope['org.corfield.framework'].subsystemfactories = {};
		fake.apps[temp.name].scope['org.corfield.framework'].subsystems = {};
		// Settings
		fake.apps[temp.name].settings = {
			ACTIONSPECIFIESSUBSYSTEM = temp.ff,
			APPLICATIONTIMEOUT = 172800,
			BUILDURL = temp.ff,
			BUILDVIEWANDLAYOUTQUEUE = temp.ff,
			CLIENTMANAGEMENT = 'NO',
			CLIENTSTORAGE = 'Registry',
			CONTROLLER = temp.ff,
			CUSTOMIZEVIEWORLAYOUTPATH = temp.ff,
			ENSURENEWFRAMEWORKSTRUCTSEXIST = temp.ff,
			FAILURE = temp.ff,
			GETACTION = temp.ff,
			GETBEANFACTORY = temp.ff,
			GETCONFIG = temp.ff,
			GETDEFAULTBEANFACTORY = temp.ff,
			GETDEFAULTSUBSYSTEM = temp.ff,
			GETFULLYQUALIFIEDACTION = temp.ff,
			GETITEM = temp.ff,
			GETSECTION = temp.ff,
			GETSECTIONANDITEM = temp.ff,
			GETSERVICEKEY = temp.ff,
			GETSUBSYSTEM = temp.ff,
			GETSUBSYSTEMBEANFACTORY = temp.ff,
			GETSUBSYSTEMDIRPREFIX = temp.ff,
			HASBEANFACTORY = temp.ff,
			HASDEFAULTBEANFACTORY = temp.ff,
			HASSUBSYSTEMBEANFACTORY = temp.ff,
			ISFRAMEWORKINITIALIZED = temp.ff,
			ISFRAMEWORKRELOADREQUEST = temp.ff,
			ISSUBSYSTEMINITIALIZED = temp.ff,
			LAYOUT = temp.ff,
			LOGINSTORAGE = 'cookie',
			NAME = 'cftracker',
			ONAPPLICATIONSTART = temp.ff,
			ONERROR = temp.ff,
			ONMISSINGVIEW = temp.ff,
			ONPOPULATEERROR = temp.ff,
			ONREQUEST = temp.ff,
			ONREQUESTSTART = temp.ff,
			ONSESSIONSTART = temp.ff,
			PARSEVIEWORLAYOUTPATH = temp.ff,
			POPULATE = temp.ff,
			REDIRECT = temp.ff,
			SCRIPTPROTECT = '',
			SERVICE = temp.ff,
			SESSIONMANAGEMENT = true,
			SESSIONTIMEOUT = 1800,
			SETBEANFACTORY = temp.ff,
			SETCFCMETHODFAILUREINFO = temp.ff,
			SETCLIENTCOOKIES = 'YES',
			SETDOMAINCOOKIES = 'NO',
			SETSUBSYSTEMBEANFACTORY = temp.ff,
			SETUPAPPLICATION = temp.ff,
			SETUPFRAMEWORKDEFAULTS = temp.ff,
			SETUPREQUEST = temp.ff,
			SETUPREQUESTDEFAULTS = temp.ff,
			SETUPREQUESTWRAPPER = temp.ff,
			SETUPSESSION = temp.ff,
			SETUPSESSIONWRAPPER = temp.ff,
			SETUPSUBSYSTEM = temp.ff,
			SETVIEW = temp.ff,
			USINGSUBSYSTEMS = temp.ff,
			VIEW = temp.ff,
			VIEWNOTFOUND = temp.ff
		};
		// Metadata
		fake.apps[temp.name].metadata = {
			expired = 'NO',
			lastaccessed = Now(),
			idleTimeout = DateAdd('n', 60, Now()),
			timeAlive = Now(),
			isInited = 'NO',
			sessionCount = 10,
			idlePercent = 0
		};
		// Sessions
		fake.apps[temp.name].sessions = {};
		for (temp.i = 1; temp.i Lte 10; temp.i++) {
			// Create fake id's
			temp.cfid = RandRange(10000, 99999);
			temp.cftoken = LCase(Left(Hash(Rand(), 'md5'), 16)) & '_' & CreateUUID();
			temp.id = temp.name & '_' & temp.cfid & '_' & temp.cftoken;
			fake.apps[temp.name].sessions[temp.id] = {};
			// metadata
			fake.apps[temp.name].sessions[temp.id].metadata = {
				expired = 'NO',
				lastaccessed = Now(),
				idleTimeout = DateAdd('n', 30, NOW()),
				timeAlive = Now(),
				isJ2eeSession = false,
				clientIp = RandRange(1, 254) & '.' & RandRange(1, 254) & '.' & RandRange(1, 254) & '.' & RandRange(1, 254),
				idFromUrl = 'NO',
				exists = true
			};
			// scope
			fake.apps[temp.name].sessions[temp.id].scope = {
				sessionid = UCase(temp.name) & '_' & temp.cfid & '_' & temp.cftoken,
				cfid = temp.cfid,
				cftoken = temp.cftoken,
				urltoken = 'CFID=' & temp.cfid & '&CFTOKEN=' & temp.cftoken
			};
		}
	// Queries
	temp.name = RandRange(-9999999, 9999999);
	fake.queries[temp.name] = {};
	// metadata
	fake.queries[temp.name].metadata = {
		queryName = 'variables.qTitles',
		creation = Now(),
		sql = 'SELECT id, titles FROM posts ORDER BY titles'
	};
	fake.queries[temp.name].metadata.params = [];
	// results
	fake.queries[temp.name].results = QueryNew('id,title');
	QueryAddRow(fake.queries[temp.name].results, 1);
	QuerySetCell(fake.queries[temp.name].results, 'id', 2, 1);
	QuerySetCell(fake.queries[temp.name].results, 'title', 'CfTracker', 1);
	
	QueryAddRow(fake.queries[temp.name].results, 1);
	QuerySetCell(fake.queries[temp.name].results, 'id', 1, 2);
	QuerySetCell(fake.queries[temp.name].results, 'title', 'Test post', 2);
	// Query 2
	temp.name = RandRange(-9999999, 9999999);
	fake.queries[temp.name] = {};
	// metadata
	fake.queries[temp.name].metadata = {
		queryName = 'variables.qResults',
		creation = Now(),
		sql = 'SELECT id, name, stock FROM products WHERE price > ?'
	};
	fake.queries[temp.name].metadata.params = [];
	temp.param = {
		scale = -1,
		statement = "[type='IN', class='java.lang.Integer', value='2', sqltype='cf_sql_integer']",
		type = 'cf_sql_integer',
		value = 200
	};
	ArrayAppend(fake.queries[temp.name].metadata.params, temp.param);
	// results
	fake.queries[temp.name].results = QueryNew('id,name,stock');
	QueryAddRow(fake.queries[temp.name].results, 1);
	QuerySetCell(fake.queries[temp.name].results, 'id', 572, 1);
	QuerySetCell(fake.queries[temp.name].results, 'name', 'TV', 1);
	QuerySetCell(fake.queries[temp.name].results, 'stock', 42, 1);
	
	fake.stats.mem = {};
	fake.stats.mem.max = 493.06;
	fake.stats.mem.used = 48.24;
	fake.stats.mem.allocated = 70.25;
	fake.stats.mem.freeAllocated = 22.01;
	fake.stats.mem.free = 444.82;
	fake.stats.mem.percentUsed = 9.78;
	fake.stats.server = {};
	fake.stats.server.requests = {};
	fake.stats.server.perfmon = {};
	
	temp.id = 0;
	fake.threads = [];
	for (temp.i = 1; temp.i Lte 5; temp.i++) {
		temp.id++;
		temp.thread = {
			id = temp.id,
			name = 'jndi-' & temp.i,
			group = 'jndi',
			priority = 5,
			state = 'WAITING',
			isAlive = 'YES',
			isDaemon = 'NO',
			isInterrupted = 'NO',
			currentTimeMillis = '',
			isShutdown = '',
			startTime = '',
			methodTiming = '',
			file = ''
		};
		ArrayAppend(fake.threads, temp.thread);
	}
	for (temp.i = 1; temp.i Lte 5; temp.i++) {
		temp.id++;
		temp.thread = {
			id = temp.id,
			name = 'jms-fifo-' & temp.i,
			group = 'main',
			priority = 5,
			state = 'WAITING',
			isAlive = 'YES',
			isDaemon = 'NO',
			isInterrupted = 'NO',
			currentTimeMillis = '',
			isShutdown = '',
			startTime = '',
			methodTiming = '',
			file = ''
		};
		ArrayAppend(fake.threads, temp.thread);
	}
	for (temp.i = 1; temp.i Lte 5; temp.i++) {
		temp.id++;
		temp.thread = {
			id = temp.id,
			name = 'jndi-' & temp.i,
			group = 'main',
			priority = 5,
			state = 'BLOCKED',
			isAlive = 'YES',
			isDaemon = 'NO',
			isInterrupted = 'NO',
			currentTimeMillis = GetTickCount(),
			isShutdown = 'NO',
			startTime = '',
			methodTiming = '',
			file = ''
		};
		ArrayAppend(fake.threads, temp.thread);
	}
	for (temp.i = 1; temp.i Lte 6; temp.i++) {
		temp.id++;
		temp.thread = {
			id = temp.id,
			name = 'jrpp-' & temp.i,
			group = 'jrpp',
			priority = 5,
			state = 'RUNNABLE',
			isAlive = 'YES',
			isDaemon = 'NO',
			isInterrupted = 'NO',
			currentTimeMillis = GetTickCount(),
			isShutdown = 'NO',
			startTime = '',
			methodTiming = '',
			file = ''
		};
		ArrayAppend(fake.threads, temp.thread);
	}
	
	fake.threadGroups = {};
	fake.threadGroups['MultiplexConnections'] = 0;
	fake.threadGroups['main'] = 10;
	fake.threadGroups['jndi'] = 5;
	fake.threadGroups['jrpp'] = 6;
	fake.threadGroups['tyrex.util.daemonMaster'] = 0;
	fake.threadGroups['ORB ThreadGroup'] = 0;
	fake.threadGroups['web'] = 0;
	fake.threadGroups['RMI Runtime'] = 0;
	fake.threadGroups['scheduler'] = 0;
	
	fake.templateCache = {
		hitRatio = 0.9
	};
	
	fake.queryCache = {
		hitRatio = 0.3
	};
</cfscript>