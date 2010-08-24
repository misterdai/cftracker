<cfcomponent output="false">
	<cfscript>
		variables.settings = {};
		variables.settings.interval = 600;
		variables.settings.apps = {
			min = 2,
			max = 10,
			timeout = CreateTimeSpan(0, 2, 0, 0),
			createChance = 10
		};
		variables.settings.sess = {
			min = 1,
			max = 10,
			timeout = CreateTimeSpan(0, 0, 20, 0),
			createChance = 20,
			hitChance = 30
		};
		// No more than 10 please
		variables.settings.queries = {
			items = 10,
			hitChance = 10
		};
	</cfscript>
	
	<cffunction name="init" output="false" access="public">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="tick" output="false" access="public">
		<cfset var lc = {} />
		<cflock name="#application.applicationName#-demodata" type="exclusive" timeout="10" throwontimeout="false">
			<cfscript>
				if (Not StructKeyExists(application, 'demo')) {
					application.demo = {};
					// WC
					application.demo.wc = {};
					application.demo.wc['Adobe'] = {};
					application.demo.wc.adobe.apps = {};
					application.demo.wc.adobe.sess = {};
					// Queries
					application.demo.queries = {
						hitratio = 0
					};
					application.demo.queries.items = {};
					for (lc.i = 1; lc.i Lte variables.settings.queries.items; lc.i++) {
						variables.newQuery();
					}
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
						application.demo.queries.hitRatio += RandRange(1, 100) / 1000 - 500;
					}
					if (application.demo.queries.hitRatio Gt 1) {
						application.demo.queries.hitRatio = 1;
					} else if (application.demo.queries.hitRatio Lt 0) {
						application.demo.queries.hitRatio = 0;
					}
					// MEMORY
					// STATISTICS
					// THREADS
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