<cfcomponent output="false">
	<cffunction name="init" output="false" access="public">
		<cfset variables.settings = application.cftracker.demo />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setup" output="false" access="private">
		<cfscript>
			var lc = {};
			application.demo = {};
			// WC
			application.demo.wc = {};
			application.demo.wc['Adobe'] = {};
			application.demo.wc.adobe.apps = {};
			application.demo.wc.adobe.sess = {};
			for (lc.i = 1; lc.i Lte variables.settings.apps.min; lc.i++) {
				variables.newApplication();
			}
			// Queries
			application.demo.queries = {
				hitratio = 0
			};
			application.demo.queries.items = {};
			for (lc.i = 1; lc.i Lte variables.settings.queries.items; lc.i++) {
				variables.newQuery();
			}
			// Stats
			application.demo.stats = {};
			application.demo.stats.compilationTime = 17.80;
			application.demo.stats.cpuProcessTime = 0.00000005367;
			application.demo.stats.classLoading = {
				current = 8171,
				total = 8436,
				unloaded = 265
			};
			application.demo.stats.jdbc = {};
			application.demo.stats.jdbc['Db1'] = {
				database = 'DbName',
				description = 'Description goes here',
				open = 1,
				total = 1
			};
			application.demo.stats.cfm = {
				running = 1,
				queued = 0,
				timedout = 0,
				limit = 10
			};
			application.demo.stats.os = {
				vmCommitted = 0,
				physicalFree = 3464810496,
				physicalTotal = 4294967296,
				physicalUsed = 830156800,
				swapTotal = 2147483648,
				swapUsed = 0,
				swapFree = 2147483648,
				cpuTime = application.demo.stats.cpuProcessTime
			};
			application.demo.stats.memory = {};
			application.demo.stats.garbage = [];
			application.demo.stats.garbage[1] = {
				collections = 53,
				duration = 12,
				endTime = Now(),
				name = 'PS Scavenge',
				startTime = Now(),
				totalDuration = 811,
				valid = true
			};
			application.demo.stats.garbage[1].pools = ['PS Eden Space', 'PS Survivor Space'];
			application.demo.stats.garbage[1].usage = {};
			application.demo.stats.garbage[1].usage['PS Eden Space'] = {};
			application.demo.stats.garbage[1].usage['PS Eden Space'].after = {
				committed = 3003136,
				free = 49414144,
				initial = 3145728,
				max = 49414144,
				used = 0
			};
			application.demo.stats.garbage[1].usage['PS Eden Space'].before = {
				committed = 23003136,
				free = 31031304,
				initial = 3145728,
				max = 42795008,
				used = 11763704
			};
			application.demo.stats.garbage[1].usage['PS Survivor Space'] = {};
			application.demo.stats.garbage[1].usage['PS Survivor Space'].after = {
				committed = 2097152,
				free = 64224,
				initial = 524288,
				max = 2097152,
				used = 2032928
			};
			application.demo.stats.garbage[1].usage['PS Survivor Space'].before = {
				committed = 8192000,
				free = 6088176,
				initial = 524288,
				max = 8192000,
				used = 2103824
			};
			application.demo.stats.garbage[2] = {
				collections = 6,
				duration = 254,
				endtime = Now(),
				name = 'PS MarkSweep',
				startTime = Now(),
				totalduration = 900,
				valid = true
			};
			application.demo.stats.garbage[2].pools = ['PS Eden Space', 'PS Survivor Space', 'PS Old Gen', 'PS Perm Gen'];
			application.demo.stats.garbage[2].usage = {};
			application.demo.stats.garbage[2].usage['PS Eden Space'] = {};
			application.demo.stats.garbage[2].usage['PS Eden Space'].after = {
				committed = 23003136,
				free = 49414144,
				initial = 3145728,
				max = 49414144,
				used = 0
			};
			application.demo.stats.garbage[2].usage['PS Eden Space'].before = {
				committed = 23003136,
				free = 49414144,
				initial = 3145728,
				max = 49414144,
				used = 0
			};
			application.demo.stats.garbage[2].usage['PS Old Gen'] = {};
			application.demo.stats.garbage[2].usage['PS Old Gen'].after = {
				committed = 39321600,
				free = 451812072,
				initial = 4194304,
				max = 477233152,
				used = 25421080
			};
			application.demo.stats.garbage[2].usage['PS Old Gen'].before = {
				committed = 39321600,
				free = 452997360,
				initial = 4194304,
				max = 477233152,
				used = 24235792
			};
			application.demo.stats.garbage[2].usage['PS Perm Gen'] = {};
			application.demo.stats.garbage[2].usage['PS Perm Gen'].after = {
				committed = 60686336,
				free = 160187816,
				initial = 16777216,
				max = 201326592,
				used = 41138776
			};
			application.demo.stats.garbage[2].usage['PS Perm Gen'].before = {
				committed = 59899904,
				free = 160187816,
				initial = 16777216,
				max = 201326592,
				used = 41138776
			};
			application.demo.stats.garbage[2].usage['PS Survivor Space'] = {};
			application.demo.stats.garbage[2].usage['PS Survivor Space'].after = {
				committed = 2097152,
				free = 2097152,
				initial = 524288,
				max = 2097152,
				used = 0
			};
			application.demo.stats.garbage[2].usage['PS Survivor Space'].before = {
				committed = 2097152,
				free = 64224,
				initial = 524288,
				max = 2097152,
				used = 2032928
			};
			application.demo.stats.memory = {};
			application.demo.stats.memory.heap = {};
			application.demo.stats.memory.heap.peakUsage = {
				committed = 91488256,
				free = 478463864,
				initial = 0,
				max = 517013504,
				used = 72038536
			};
			application.demo.stats.memory.heap.pools = {};
			application.demo.stats.memory.heap.pools['PS Eden Space'] = {
				name = 'PS Eden Space'
			};
			application.demo.stats.memory.heap.pools['PS Eden Space'].garbageCollections = ['PS MarkSweep', 'PS Scavenge'];
			application.demo.stats.memory.heap.pools['PS Eden Space'].peakUsage = {
				committed = 37486592,
				free = 21102592,
				initial = 3145728,
				max = 58589184,
				used = 37486592
			};
			application.demo.stats.memory.heap.pools['PS Eden Space'].usage = {
				committed = 23003136,
				free = 40093600,
				initial = 3145728,
				max = 49414144,
				used = 9320544
			};
			application.demo.stats.memory.heap.pools['PS Old Gen'] = {
				name = 'PS Old Gen'
			};
			application.demo.stats.memory.heap.pools['PS Old Gen'].garbageCollections = ['PS MarkSweep'];
			application.demo.stats.memory.heap.pools['PS Old Gen'].peakUsage = {
				committed = 39321600,
				free = 451812072,
				initial = 4194304,
				max = 477233152,
				used = 25421080
			};
			application.demo.stats.memory.heap.pools['PS Old Gen'].usage = {
				committed = 39321600,
				free = 451812072,
				initial = 4194304,
				max = 477233152,
				used = 25421080
			};
			application.demo.stats.memory.heap.pools['PS Survivor Space'] = {
				name = 'PS Survivor Space'
			};
			application.demo.stats.memory.heap.pools['PS Survivor Space'].garbageCollections = ['PS MarkSweep', 'PS Scavenge'];
			application.demo.stats.memory.heap.pools['PS Survivor Space'].peakUsage = {
				committed = 14680064,
				free = 5549200,
				initial = 524288,
				max = 14680064,
				used = 9130864
			};
			application.demo.stats.memory.heap.pools['PS Survivor Space'].usage = {
				committed = 2097152,
				free = 2097152,
				initial = 524288,
				max = 2097152,
				used = 0
			};
			application.demo.stats.memory.heap.usage = {
				committed = 64421888,
				free = 494002824,
				initial = 0,
				max = 517013504,
				used = 34741624
			};
			application.data.stats.memory.nonheap = {};
			application.demo.stats.memory.nonheap.peakUsage = {
				committed = 64520192,
				free = 206688312,
				initial = 19136512,
				max = 251658240,
				used = 44969928
			};
			application.demo.stats.memory.nonheap.pools = {};
			application.demo.stats.memory.nonheap.pools['Code Cache'] = {
				name = 'Code Cache'
			};
			application.demo.stats.memory.nonheap.pools['Code Cache'].garbageCollections = ['CodeCacheManager'];
			application.demo.stats.memory.nonheap.pools['Code Cache'].peakUsage = {
				committed = 3833856,
				free = 46543360,
				initial = 2359296,
				max = 50331648,
				used = 3788288
			};
			application.demo.stats.memory.nonheap.pools['Code Cache'].usage = {
				committed = 3833856,
				free = 46545856,
				initial = 2359296,
				max = 50331648,
				used = 3785792
			};
			application.demo.stats.memory.nonheap.pools['PS Perm Gen'] = {
				name = 'PS Perm Gen'
			};
			application.demo.stats.memory.nonheap.pools['PS Perm Gen'].garbageCollections = ['PS MarkSweep'];
			application.demo.stats.memory.nonheap.pools['PS Perm Gen'].peakUsage = {
				committed = 60686336,
				free = 160144952,
				initial = 16777216,
				max = 201326592,
				used = 41181640
			};
			application.demo.stats.memory.nonheap.pools['PS Perm Gen'].usage = {
				committed = 60686336,
				free = 160144952,
				initial = 16777216,
				max = 201326592,
				used = 41181640
			};
			application.demo.stats.memory.nonheap.usage = {
				committed = 64520192,
				free = 206690808,
				initial = 19136512,
				max = 251658240,
				used = 44967432
			};
			application.demo.templates = {
				hitRatio = 0.5
			};
			application.demo.threads = {};
			application.demo.threads.items = [];
			lc.names = ['jndi-', 'jms-fifo-', 'jndi-', 'jrpp'];
			lc.groups = ['jndi', 'main', 'main', 'jrpp'];
			lc.states = ['WAITING', 'WAITING', 'BLOCKED', 'RUNNABLE'];
			lc.shutdown = ['', '', 'NO', 'NO'];
			lc.current = ['', '', GetTickCount(), GetTickCount()];
			for (lc.i = 1; lc.i Lte 40; lc.i++) {
				lc.g = Ceiling(lc.i / 10);
				application.demo.threads.items[lc.i] = {
					id = lc.i,
					name = lc.names[lc.g] & lc.i,
					group = lc.groups[lc.g],
					priority = 5,
					state = lc.states[lc.g],
					isAlive = 'YES',
					isDaemon = 'NO',
					isInterrupted = 'NO',
					currentTimeMillis = lc.current[lc.g],
					isShutdown = lc.shutdown[lc.g],
					startTime = '',
					methodTiming = '',
					file = ''
				};
			}
			application.demo.threads.groups = {};
			application.demo.threads.groups['MultiplexConnections'] = 0;
			application.demo.threads.groups['main'] = 20;
			application.demo.threads.groups['jndi'] = 10;
			application.demo.threads.groups['jrpp'] = 10;
			application.demo.threads.groups['tyrex.util.daemonMaster'] = 0;
			application.demo.threads.groups['ORB ThreadGroup'] = 0;
			application.demo.threads.groups['web'] = 0;
			application.demo.threads.groups['RMI Runtime'] = 0;
			application.demo.threads.groups['scheduler'] = 0;
		</cfscript>
	</cffunction>
	
	<cffunction name="tick" output="false" access="public">
		<cfset var lc = {} />
		<cflock name="#application.applicationName#-demodata" type="exclusive" timeout="10" throwontimeout="false">
			<cfscript>
				if (Not StructKeyExists(application, 'demo')) {
					variables.setup();
				}
				if (StructKeyExists(application.demo, 'updated')) {
//					WriteOutput(application.demo.updated);
				}
				if (Not StructKeyExists(application.demo, 'updated') Or DateDiff('s', application.demo.updated, Now()) Gte variables.settings.interval) {
					// Last updated
					application.demo.updated = Now();
					// APPLICATIONS AND SESSIONS
					// Loop over current applications
					for (lc.app in application.demo.wc.adobe.apps) {
						// Clean up expired applications
						if (DateAdd('s', application.demo.wc.adobe.apps[lc.app].metadata.idleTimeout * 86400, application.demo.wc.adobe.apps[lc.app].metadata.lastAccessed) Lt Now()) {
							// Expired application, remove
							StructDelete(application.demo.wc.adobe.apps, lc.app);
						}
						if (Not StructKeyExists(application.demo.wc.adobe.sess, lc.app)) {
							application.demo.wc.adobe.sess[lc.app] = {};
						}
						// Clean up expired sessions, random activity on others
						for (lc.sess in application.demo.wc.adobe.sess[lc.app]) {
							if (DateAdd('s', application.demo.wc.adobe.sess[lc.app][lc.sess].metadata.idleTimeout * 86400, application.demo.wc.adobe.sess[lc.app][lc.sess].metadata.lastAccessed) Lt Now()) {
								// Expired session, remove
								StructDelete(application.demo.wc.adobe.sess[lc.app], lc.sess);
							} else if (RandRange(0, 100) Lte variables.settings.sess.hitChance) {
								// Hit a session
								application.demo.wc.adobe.sess[lc.app][lc.sess].metadata.lastAccessed = Now();
								// The app may have expired, create a new instance if needed
								if (Not StructKeyExists(application.demo.wc.adobe.apps, lc.app)) {
									variables.newApplication(lc.app);
								}
								application.demo.wc.adobe.apps[lc.app].metadata.lastAccessed = Now();
							}
						}
						if (Not StructKeyExists(application.demo.wc.adobe.apps, lc.app)
							And StructCount(application.demo.wc.adobe.sess[lc.app]) Eq 0) {
							// App has expired and so have all of it's sessions
							StructDelete(application.demo.wc.adobe.sess, lc.app);
						} else {
							// Generate new sessions
							if (StructCount(application.demo.wc.adobe.sess[lc.app]) Lte variables.settings.sess.min
								Or (
									StructCount(application.demo.wc.adobe.sess[lc.app]) Lte variables.settings.sess.max
									And RandRange(0, 100) Lte variables.settings.sess.createChance
								)) {
								variables.newSession(lc.app);
							}
						}
					}
					// Generate new applications
					if (StructCount(application.demo.wc.adobe.apps) Lte variables.settings.apps.min
						Or (
							StructCount(application.demo.wc.adobe.apps) Lte variables.settings.apps.max
							And RandRange(0, 100) Lte variables.settings.apps.createChance
						)) {
						variables.newApplication();
					}
					// QUERIES
					for (lc.query in application.demo.queries.items) {
						if (RandRange(0, 100) Lte variables.settings.queries.hitChance) {
							application.demo.queries.items[lc.query].metadata.creation = Now();
						}
					}
					lc.len = StructCount(application.demo.queries.items) + 1;
					if (lc.len Lte variables.settings.queries.items) {
						for (lc.i = lc.len; lc.i Lte variables.settings.queries.items; lc.i++) {
							variables.newQuery();
						}
					}
					if (application.demo.queries.hitRatio Lt 1) {
						application.demo.queries.hitRatio += (RandRange(1, 100) - 50) / 1000;
					}
					if (application.demo.queries.hitRatio Gt 1) {
						application.demo.queries.hitRatio = 1;
					} else if (application.demo.queries.hitRatio Lt 0) {
						application.demo.queries.hitRatio = 0;
					}
					if (application.demo.templates.hitRatio Lt 1) {
						application.demo.templates.hitRatio += (RandRange(1, 100) - 50) / 1000;
					}
					if (application.demo.templates.hitRatio Gt 1) {
						application.demo.templates.hitRatio = 1;
					} else if (application.demo.templates.hitRatio Lt 0) {
						application.demo.templates.hitRatio = 0;
					}
				}
			</cfscript>
		</cflock>
	</cffunction>
	
	<cffunction name="reset" output="false" access="public">
		<cflock name="#application.applicationName#-demodata" type="exclusive" timeout="10" throwontimeout="false">
			<cfset StructDelete(application, 'demo') />
		</cflock>
	</cffunction>
	
	<cffunction name="newApplication" output="false" access="private">
		<cfargument name="appName" type="string" required="false" />
		<cfscript>
			var lc = {};
			if (StructKeyExists(arguments, 'appName')) {
				lc.appName = arguments.appName;
			} else {
				do {
					lc.appName = 'Sample_App_' & RandRange(1000, 9999);
				} while (StructKeyExists(application.demo.wc.adobe.apps, lc.appName));
			}
			lc.scope = {};
			lc.scope['applicationname'] = lc.appName;
			lc.settings = {
				applicationTimeout	= variables.settings.apps.timeout,
				clientManagement	= false,
				clientStorage		= 'Registry',
				loginStorage		= 'cookie',
				name				= lc.appName,
				onApplicationStart	= variables.fakeFunction,
				onError				= variables.fakeFunction,
				scriptProtect		= '',
				sessionManagement	= true,
				sessionTimeout		= variables.settings.sess.timeout,
				setClientCookies	= true,
				setDomainCookies	= false
			};
			lc.metadata = {
				timealive = Now(),
				lastaccessed = Now(),
				idleTimeout = variables.settings.apps.timeout,
				isinited = true
			};
			application.demo.wc.adobe.apps[lc.appName] = {
				scope = lc.scope,
				settings = lc.settings,
				metadata = lc.metadata
			};
			if (Not StructKeyExists(arguments, 'appName')) {
				variables.newSession(lc.appName);
			}
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="fakeFunction" output="false" access="private">
		<cfreturn false />
	</cffunction>
	
	<cffunction name="newSession" output="false" access="private">
		<cfargument name="appName" type="string" required="true" />
		<cfscript>
			var lc = {};
			do {
				lc.sessionId = [
					arguments.appName,
					RandRange(10000, 99999), 
					LCase(Left(Hash(RandRange(0, 65000)), 16)) & '-' & CreateUuid()
				];
			} while (StructKeyExists(application.demo.wc.adobe.sess, ArrayToList(lc.sessionId, '_')));
			lc.scope = {};
			lc.scope['cfid'] = lc.sessionId[2];
			lc.scope['cftoken'] = lc.sessionId[3];
			lc.scope['sessionid'] = ArrayToList(lc.sessionId, '_');
			lc.scope['urltoken'] = 'CFID=' & lc.scope['cfid'] & '&CFTOKEN=' & lc.scope['cftoken'];
			
			lc.metadata = {
				timeAlive = Now(),
				lastAccessed = Now(),
				idleTimeout = variables.settings.sess.timeout,
				clientIp = variables.RandomIp(),
				isNew = true,
				isJ2eeSession = false,
				idFromUrl = false
			};
			application.demo.wc.adobe.sess[arguments.appName][lc.scope['sessionid']] = {
				scope = lc.scope,
				metadata = lc.metadata
			};
			application.demo.wc.adobe.apps[arguments.appName].metadata.lastAccessed = Now();
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="RandomIp" output="false">
		<cfscript>
			var lc = {};
			lc.ip = [
				127,
				RandRange(0, 254),
				RandRange(0, 254),
				RandRange(1, 253)
			];
			return ArrayToList(lc.ip, '.');
		</cfscript>
	</cffunction>
	
	<cffunction name="newQuery" output="false">
		<cfscript>
			var lc = {};
			do {
				lc.id = RandRange(-999999, 999999);
			} while (StructKeyExists(application.demo.queries, lc.id));
			if (IsDefined('lc.params')) {
				lc.params = lc.params.getAllParameters();
				lc.pCount = ArrayLen(lc.params);
				for (lc.p = 1; lc.p Lte lc.pCount; lc.p++) {
					lc.param.scale = lc.params[lc.p].getScale();
					lc.param.type = lc.params[lc.p].getSqltypeName();
					lc.param.statement = lc.params[lc.p].getStatement();
					lc.param.value = lc.params[lc.p].getObject();
					ArrayAppend(lc.data.params, lc.param);
					// Not 100% sure on the getObject(), may need conversion?
				}
			}
			lc.metadata = {
				creation = Now(),
				dsn = '',
				hashCode = lc.id
			};
			switch(RandRange(1, 2)) {
				case 1: {
					lc.results = QueryNew('id,tag,conference,rating');
					lc.metadata.queryName = 'qPosts';
					lc.metadata.sql = 'SELECT id, tag, conference, rating FROM conferences WHERE tag = ?';
					lc.metadata.params = [];
					lc.param = {
						scale = -1,
						type = 'cf_sql_varchar',
						value = 'SOTR'
					};
					lc.param.statement = "[type='IN', class='java.lang.String', value='SOTR', sqltype='cf_sql_varchar']";
					ArrayAppend(lc.metadata.params, lc.param);
					lc.year = 2008;
					for (lc.i = 1; lc.i Lte 3; lc.i++) {
						QueryAddRow(lc.results, 1);
						QuerySetCell(lc.results, 'id', RandRange(1, 10000), lc.i);
						QuerySetCell(lc.results, 'tag', 'SOTR', lc.i);
						QuerySetCell(lc.results, 'conference', 'Scotch On The Rocks ' & (lc.year + lc.i), lc.i);
						QuerySetCell(lc.results, 'rating', 7 + lc.i, lc.i);
					}
					break;
				}
				case 2: {
					lc.results = QueryNew('id,title,content');
					lc.metadata.queryName = 'qPosts';
					lc.metadata.sql = 'SELECT id, title, content FROM posts WHERE id = (?, ?, ?)';
					lc.metadata.params = [];
					for (lc.i = 1; lc.i Lte 3; lc.i++) {
						lc.param = {
							scale = -1,
							type = 'cf_sql_integer',
							value = RandRange(1, 99999)
						};
						lc.param.statement = "[type='IN', class='java.lang.Integer', value='" & lc.param.value & "', sqltype='cf_sql_integer']";
						ArrayAppend(lc.metadata.params, lc.param);
						QueryAddRow(lc.results, 1);
						QuerySetCell(lc.results, 'id', lc.param.value, lc.i);
						QuerySetCell(lc.results, 'title', 'Title-Goes-Here', lc.i);
						QuerySetCell(lc.results, 'content', 'Content-Goes-Here', lc.i);
					}
					break;
				}
			}
			application.demo.queries.items[lc.id] = {
				metadata = lc.metadata,
				results = lc.results
			};
			return true;
		</cfscript>
	</cffunction>

	<cffunction name="newThread" output="false">
		<cfscript>
			var lc = {};
			
			return true;
		</cfscript>
	</cffunction>
</cfcomponent>