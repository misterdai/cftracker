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
			max = 20,
			timeout = CreateTimeSpan(0, 0, 20, 0),
			createChance = 20,
			hitChance = 30
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
					// Threads
					application.demo.threads = {};
				}
				if (Not StructKeyExists(application.demo, 'updated') Or DateDiff('s', application.demo.updated, Now()) Gte variables.settings.interval) {
					application.demo.updated = Now();
					// Generate new applications
					if (StructCount(application.demo.wc.adobe.apps) Lte variables.settings.apps.min
						Or (
							StructCount(application.demo.wc.adobe.apps) Lte variables.settings.apps.max
							And RandRange(0, 100) Lte variables.settings.apps.createChance
						)) {
						variables.newApplication();
					}
				}
			</cfscript>
		</cflock>
		<cfscript>
			
			// Update apps and sessions

		</cfscript>
	</cffunction>
	
	<cffunction name="reset" output="false" access="public">
		<cflock name="#application.applicationName#-demodata" type="exclusive" timeout="10" throwontimeout="false">
			<cfset StructDelete(application, 'demo') />
		</cflock>
	</cffunction>
	
	<cffunction name="newApplication" output="false" access="private">
		<cfscript>
			var lc = {};
			do {
				lc.appName = 'Sample_App_' & RandRange(1000, 9999);
			} while (StructKeyExists(application.demo.wc.adobe.apps, lc.appName));
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
			variables.newSession(lc.appName);
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
				isJ2eeSession = false
			};
			application.demo.wc.adobe.sess[arguments.appName][lc.scope['sessionid']] = {
				scope = lc.scope,
				metadata = lc.metadata
			};
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
</cfcomponent>