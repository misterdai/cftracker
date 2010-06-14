<!---

Author: David Boyer (Mister Dai)
Website: http://cftracker.riaforge.com
Blog: http://misterdai.wordpress.com (http://yougeezer.co.uk)
Version: 1.0.1

--->
<cfcomponent name="Tracker" output="false">
	<cffunction name="init" output="false" access="public">
		<cfscript>
			var local = StructNew();
			// We have to use Java reflection for these methods, otherwise they'll keep the sessions alive
			variables.mirror = ArrayNew(1);
			variables.mirror2 = ArrayNew(1);
			variables.mirror2[1] = CreateObject('java', 'java.lang.String').GetClass();
			variables.mirror3 = ArrayNew(1);
			//variables.mirror3[1] = CreateObject('java', 'java.lang.Boolean').init('true').GetClass();
			variables.reflections = StructNew();

			variables.reflect.sess = StructNew();
			local.class = variables.mirror.getClass().forName('coldfusion.runtime.SessionScope');
			variables.reflect.sess.elapsedTime = local.class.getMethod('getElapsedTime', variables.mirror);
			variables.reflect.sess.lastAccess = local.class.getMethod('getTimeSinceLastAccess', variables.mirror);
			variables.reflect.sess.maxInterval = local.class.getMethod('getMaxInactiveInterval', variables.mirror);
			variables.reflect.sess.expired = local.class.getMethod('expired', variables.mirror);
			variables.reflect.sess.clientIp = local.class.getMethod('getClientIp', variables.mirror);
			variables.reflect.sess.idFromUrl = local.class.getMethod('isIdFromURL', variables.mirror);
			variables.reflect.sess.isNew = local.class.getMethod('isNew', variables.mirror);
			
			if (ListFirst(server.coldfusion.productVersion) Gt 7) {
				variables.reflect.sess.value = local.class.getMethod('getValueWIthoutChange', variables.mirror2);
			} else {
				// Not available in CF7-
				StructDelete(this, 'getSessionValue');
			}

			variables.reflect.app = StructNew();
			local.class = variables.mirror.getClass().forName('coldfusion.runtime.ApplicationScope');
			variables.reflect.app.elapsedTime = local.class.getMethod('getElapsedTime', variables.mirror);
			variables.reflect.app.lastAccess = local.class.getMethod('getTimeSinceLastAccess', variables.mirror);
			variables.reflect.app.maxInterval = local.class.getMethod('getMaxInactiveInterval', variables.mirror);
			variables.reflect.app.expired = local.class.getMethod('expired', variables.mirror);
			variables.reflect.app.settings = local.class.getMethod('getApplicationSettings', variables.mirror);
			variables.reflect.app.isInited = local.class.getMethod('isInited', variables.mirror);
			//variables.reflect.app.inited = local.class.getMethod('setIsInited', variables.mirror3);
			if (ListFirst(server.coldfusion.productVersion) Gt 7) {
				variables.reflect.app.value = local.class.getMethod('getValueWIthoutChange', variables.mirror2);
			} else {
				// Not available in CF7-
				StructDelete(this, 'getApplicationValue');
			}
			
			
			// Application tracking
			variables.jAppTracker = CreateObject('java', 'coldfusion.runtime.ApplicationScopeTracker');
			this.jAppTracker = variables.jAppTracker;
			// Session tracking
			variables.jSesTracker = CreateObject('java', 'coldfusion.runtime.SessionTracker');
			
			// Memory tracking
			variables.jRuntime = CreateObject("java","java.lang.Runtime").getRuntime();
			
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="getApplications" access="public" output="false" returntype="array">
		<cfscript>
			var local = StructNew();
			local.aApps = ArrayNew(1);
			local.oApps = variables.jAppTracker.getApplicationKeys();
			while (local.oApps.hasMoreElements()) {
				ArrayAppend(local.aApps, local.oApps.nextElement());
			}	
			return local.aApps;
		</cfscript>
	</cffunction>
	
	<cffunction name="getApplicationKeys" access="public" output="false" returntype="array">
		<cfargument name="applicationName" type="string" required="true" />
		<cfreturn StructKeyArray(variables.getApplication(arguments.applicationName)) />
	</cffunction>
	
	<cffunction name="ApplicationStop" returntype="boolean" output="false" access="public">
		<cfargument name="applicationName" type="string" required="true" />
		<cfset variables.jAppTracker.cleanUp(variables.getApplication(arguments.applicationName)) />
		<cfreturn true />
	</cffunction>

	<cffunction name="ApplicationRestart" returntype="boolean" output="false" access="public">
		<cfargument name="applicationName" type="string" required="true" />
		<cfset variables.getApplication(arguments.applicationName).setIsInited(false) />
		<cfreturn true />
	</cffunction>
	
	<cffunction name="getApplicationValue" access="public" output="false" returntype="any">
		<cfargument name="applicationName" type="string" required="true" />
		<cfargument name="key" type="string" required="true" />
		<cfscript>
			var local = StructNew();
			local.value = '';
			local.mirror = ArrayNew(1);
			local.mirror[1] = JavaCast('string', arguments.key);
			local.app = variables.getApplication(arguments.applicationName);
			if (IsDefined('local.app')) {
				local.keys = StructKeyArray(local.app);
				if (local.keys.Contains(JavaCast('string', arguments.key))) {
					local.value = variables.reflect.app.value.invoke(local.app, local.mirror);
				}
			}
			return local.value;
		</cfscript>
	</cffunction>
	
	<cffunction name="getAllApplicationValues" access="public" output="false" returntype="any">
		<cfargument name="applicationName" type="string" required="true" />
		<cfscript>
			var local = StructNew();
			local.values = {};
			local.mirror = ArrayNew(1);
			local.app = variables.getApplication(arguments.applicationName);
			if (IsDefined('local.app')) {
				local.keys = StructKeyArray(local.app);
				local.len = ArrayLen(local.keys);
				for (local.i = 1; local.i Lte local.len; local.i = local.i + 1) {
					local.mirror[1] = JavaCast('string', local.keys[local.i]);
					local.values[local.keys[local.i]] = variables.reflect.app.value.invoke(local.app, local.mirror);
				}
			}
			return local.values;
		</cfscript>
	</cffunction>
	
	<cffunction name="getApplication" access="public" output="false">
		<cfargument name="applicationName" type="string" required="true" />
		<cfreturn variables.jAppTracker.getApplicationScope(arguments.applicationName) />
	</cffunction>
	
	<cffunction name="getAppIsInited" access="public" output="false" returntype="boolean">
		<cfargument name="applicationName" required="true" type="string" />
		<cfreturn variables.reflect.app.isInited.invoke(variables.getApplication(arguments.applicationName), variables.mirror) />
	</cffunction>
	
	<cffunction name="getAppTimeAlive" access="public" output="false" returntype="numeric">
		<cfargument name="applicationName" required="true" type="string" />
		<cfreturn variables.reflect.app.elapsedTime.invoke(variables.getApplication(arguments.applicationName), variables.mirror) />
	</cffunction>
	
	<cffunction name="getAppSettings" access="public" output="false" returntype="struct">
		<cfargument name="applicationName" required="true" type="string" />
		<cfset var local = StructNew() />
		<cfset local.settings = variables.reflect.app.settings.invoke(variables.getApplication(arguments.applicationName), variables.mirror) />
		<!---
			CF8 hates nulls
		--->
		<cfset local.keys = StructKeyArray(local.settings) />
		<cfloop array="#local.keys#" index="local.key">
			<cfif Not StructKeyExists(local.settings, local.key)>
				<cfset StructDelete(local.settings, local.key) />
			</cfif>
		</cfloop>
		<cfreturn local.settings />
	</cffunction>
	
	<cffunction name="setAppIsInited" access="public" output="false">
		<cfargument name="applicationName" required="true" type="string" />
		<cfargument name="inited" required="true" type="boolean" />
		<!--- Can't work out how to use this function via reflection, so it'll update the last access time --->
		<cfset variables.getApplication(arguments.applicationName).setIsInited(arguments.inited) />
		<!---<cfscript>
			var local = StructNew();
			local.mirror = ArrayNew(1);
			local.mirror[1] = JavaCast('boolean', arguments.inited);
			local.app = variables.getApplication(arguments.applicationName);
			if (IsDefined('local.app')) {
				variables.reflect.app.inited.invoke(local.app, local.mirror);
			}
		</cfscript>--->
	</cffunction>

	<cffunction name="getAppLastAccessed" access="public" output="false" returntype="numeric">
		<cfargument name="applicationName" required="true" type="string" />
		<cfreturn variables.reflect.app.lastAccess.invoke(variables.getApplication(arguments.applicationName), variables.mirror) />
	</cffunction>

	<cffunction name="getAppIdleTimeout" access="public" output="false" returntype="numeric">
		<cfargument name="applicationName" required="true" type="string" />
		<cfreturn variables.reflect.app.maxInterval.invoke(variables.getApplication(arguments.applicationName), variables.mirror) * 1000 />
	</cffunction>
	
	<cffunction name="isAppExpired" access="public" output="false" returntype="any">
		<cfargument name="applicationName" required="true" type="string" />
		<cfreturn variables.reflect.app.expired.invoke(variables.getApplication(arguments.applicationName), variables.mirror) />
	</cffunction>
	
	<cffunction name="touchApp" access="public" output="false">
		<cfargument name="applicationName" required="true" type="string" />
		<cfset variables.getApplication(arguments.applicationName).setLastAccess() />
	</cffunction>

	<cffunction name="getAppIdlePercent" access="public" output="false" returntype="numeric">
		<cfargument name="applicationName" required="true" type="string" />
		<cfif variables.isAppExpired(arguments.applicationName)>
			<cfreturn 100 />
		<cfelse>
			<cfreturn variables.getAppLastAccessed(arguments.applicationName) / variables.getAppIdleTimeout(arguments.applicationName) * 100 />
		</cfif>
	</cffunction>
	
	<cffunction name="getAppInfo" access="public" output="false" returntype="struct">
		<cfargument name="applicationName" type="string" required="true" />
		<cfscript>
			var local = StructNew();
			local.data = StructNew();
			local.data.timeAlive = this.getAppTimeAlive(arguments.applicationName);
			local.data.lastAccessed = this.getAppLastAccessed(arguments.applicationName);
			local.data.idleTimeout = this.getAppIdleTimeout(arguments.applicationName) / 1000;
			local.data.expired = this.isAppExpired(arguments.applicationName);
			local.data.idlePercent = this.getAppIdlePercent(arguments.applicationName);
			local.data.isInited = this.getAppIsInited(arguments.applicationName);
			return local.data;
		</cfscript>
	</cffunction>
	
	<cffunction name="getSessions" access="public" output="false" returntype="array">
		<cfscript>
			var local = StructNew();
			local.aSess = ArrayNew(1);
			local.oSess = variables.jSesTracker.getSessionKeys();
			while (local.oSess.hasMoreElements()) {
				ArrayAppend(local.aSess, local.oSess.nextElement());
			}
			return local.aSess;
		</cfscript>
	</cffunction>
	
	<cffunction name="getSessionKeys" access="public" output="false" returntype="array">
		<cfargument name="sessionId" type="string" required="true" />
		<cfreturn StructKeyArray(variables.getSession(arguments.sessionId)) />
	</cffunction>
	
	<cffunction name="getSessionValue" access="public" output="false" returntype="any">
		<cfargument name="sessionId" type="string" required="true" />
		<cfargument name="key" type="string" required="true" />
		<cfscript>
			var local = StructNew();
			local.value = '';
			local.mirror = ArrayNew(1);
			local.mirror[1] = JavaCast('string', arguments.key);
			local.session = variables.getSession(arguments.sessionId);
			if (IsDefined('local.session')) {
				local.keys = StructKeyArray(local.session);
				if (local.keys.Contains(JavaCast('string', arguments.key))) {
					local.value = variables.reflect.sess.value.invoke(local.session, local.mirror);
				}
			}
			return local.value;
		</cfscript>
	</cffunction>

	<cffunction name="getAllSessionValues" access="public" output="false" returntype="any">
		<cfargument name="sessionId" type="string" required="true" />
		<cfscript>
			var local = StructNew();
			local.values = {};
			local.mirror = ArrayNew(1);
			local.session = variables.getSession(arguments.sessionId);
			if (IsDefined('local.session')) {
				local.keys = StructKeyArray(local.session);
				local.len = ArrayLen(local.keys);
				for (local.i = 1; local.i Lte local.len; local.i = local.i + 1) {
					local.mirror[1] = JavaCast('string', local.keys[local.i]);
					local.values[local.keys[local.i]] = variables.reflect.sess.value.invoke(local.session, local.mirror);
				}
			}
			return local.values;
		</cfscript>
	</cffunction>
	
	<cffunction name="getSessionCount" access="public" output="false" returntype="numeric">
		<cfreturn variables.jSesTracker.getSessionCount() />
	</cffunction>
	
	<cffunction name="getAppSessions" access="public" output="false" returntype="array">
		<cfargument name="applicationName" type="string" required="true" />
		<cfscript>
			var local = StructNew();
			local.sessions = variables.jSesTracker.getSessionCollection(arguments.applicationName);
			return StructKeyArray(local.sessions);
		</cfscript>
	</cffunction>
	
	<cffunction name="getAppSessionCount" access="public" output="false" returntype="numeric">
		<cfargument name="applicationName" type="string" required="true" />
		<cfscript>
			var local = StructNew();
			local.sessions = variables.jSesTracker.getSessionCollection(arguments.applicationName);
			return StructCount(local.sessions);
		</cfscript>
	</cffunction>
	
	<cffunction name="getSession" access="public" output="false">
		<cfargument name="sessionId" type="string" required="true" />
		<cfreturn variables.jSesTracker.getSession(arguments.sessionId) />
	</cffunction>
	
	<cffunction name="getSessTimeAlive" access="public" output="false" returntype="numeric">
		<cfargument name="sessionId" required="true" type="string" />
		<cfreturn variables.reflect.sess.elapsedTime.invoke(variables.getSession(arguments.sessionId), variables.mirror) />
	</cffunction>

	<cffunction name="getSessLastAccessed" access="public" output="false" returntype="numeric">
		<cfargument name="sessionId" required="true" type="string" />
		<cfreturn variables.reflect.sess.lastAccess.invoke(variables.getSession(arguments.sessionId), variables.mirror) />
	</cffunction>

	<cffunction name="getClientIp" access="public" output="false" returntype="string">
		<cfargument name="sessionId" required="true" type="string" />
		<cfreturn variables.reflect.sess.clientIp.invoke(variables.getSession(arguments.sessionId), variables.mirror) />
	</cffunction>

	<cffunction name="getIsNew" access="public" output="false" returntype="boolean">
		<cfargument name="sessionId" required="true" type="string" />
		<cfreturn variables.reflect.sess.isNew.invoke(variables.getSession(arguments.sessionId), variables.mirror) />
	</cffunction>

	<cffunction name="getIsIdFromUrl" access="public" output="false" returntype="boolean">
		<cfargument name="sessionId" required="true" type="string" />
		<cfreturn variables.reflect.sess.idFromUrl.invoke(variables.getSession(arguments.sessionId), variables.mirror) />
	</cffunction>

	<cffunction name="getSessIdleTimeout" access="public" output="false" returntype="numeric">
		<cfargument name="sessionId" required="true" type="string" />
		<cfreturn variables.reflect.sess.maxInterval.invoke(variables.getSession(arguments.sessionId), variables.mirror) * 1000 />
	</cffunction>
	
	<cffunction name="isSessExpired" access="public" output="false" returntype="any">
		<cfargument name="sessionId" required="true" type="string" />
		<cfreturn variables.reflect.sess.expired.invoke(variables.getSession(arguments.sessionId), variables.mirror) />
	</cffunction>

	<cffunction name="getSessIdlePercent" access="public" output="false" returntype="numeric">
		<cfargument name="sessionId" required="true" type="string" />
		<cfif variables.isSessExpired(arguments.sessionId)>
			<cfreturn 100 />
		<cfelse>
			<cfreturn variables.getSessLastAccessed(arguments.sessionId) / variables.getSessIdleTimeout(arguments.sessionId) * 100 />
		</cfif>
	</cffunction>

	<cffunction name="getSessInfo" access="public" output="false" returntype="struct">
		<cfargument name="sessionId" type="string" required="true" />
		<cfscript>
			var local = StructNew();
			local.data = StructNew();
			local.data.timeAlive = this.getSessTimeAlive(arguments.sessionId);
			local.data.lastAccessed = this.getSessLastAccessed(arguments.sessionId);
			local.data.idleTimeout = this.getSessIdleTimeout(arguments.sessionId);
			local.data.expired = this.isSessExpired(arguments.sessionId);
			local.data.idlePercent = this.getSessIdlePercent(arguments.sessionId);
			local.data.isNew = this.getIsNew(arguments.sessionId);
			local.data.isIdFromUrl = this.getIsIdFromUrl(arguments.sessionId);
			local.data.clientIp = this.getClientIp(arguments.sessionId);
			return local.data;
		</cfscript>
	</cffunction>

	<cffunction name="getAllSessInfo" access="public" output="false" returntype="any">
		<cfargument name="applicationName" type="string" required="false" />
		<cfscript>
			var local = StructNew();
			if (StructKeyExists(arguments, 'applicationName')) {
				local.apps = ArrayNew(1);
				local.apps[1] = arguments.applicationName;
			} else {
				local.apps = variables.getApplications();
			}
			local.query = QueryNew('sessionId,applicationName,timeAlive,lastAccessed,idleTimeout,idlePercent,expired', 'VarChar,VarChar,BigInt,BigInt,BigInt,Double,VarChar');
			local.countApps = ArrayLen(local.apps);
			local.count = 0;
			if (local.countApps Gt 0) {
				for (local.a = 1; local.a Lte local.countApps; local.a = local.a + 1) {
					// For performance reasons we'll repeat code instead of reusing the other functions
					local.sessions = variables.jSesTracker.getSessionCollection(local.apps[local.a]);
					for (local.key In local.sessions) {
						local.count = local.count + 1;
						QueryAddRow(local.query, 1);
						QuerySetCell(local.query, 'sessionId', local.key, local.count);
						QuerySetCell(local.query, 'applicationName', local.apps[local.a], local.count);
						QuerySetCell(local.query, 'timeAlive', variables.reflect.sess.elapsedTime.invoke(local.sessions[local.key], variables.mirror), local.count);
						QuerySetCell(local.query, 'lastAccessed', variables.reflect.sess.lastAccess.invoke(local.sessions[local.key], variables.mirror), local.count);
						QuerySetCell(local.query, 'idleTimeout', variables.reflect.sess.maxInterval.invoke(local.sessions[local.key], variables.mirror) * 1000, local.count);
						QuerySetCell(local.query, 'idlePercent', local.query.lastAccessed[local.count] / local.query.idleTimeout[local.count] * 100, local.count);
						QuerySetCell(local.query, 'expired', variables.reflect.sess.expired.invoke(local.sessions[local.key], variables.mirror), local.count);
					}
				}
			}
			return local.query;
		</cfscript>
	</cffunction>
	
	<!--- Memory stats --->
	<cffunction name="getMemFree" access="public" output="false" returntype="numeric">
		<cfreturn (variables.jRuntime.maxMemory() - variables.jRuntime.totalMemory() + variables.jRuntime.freeMemory()) / 1024^2 />
	</cffunction>
	
	<cffunction name="getMemAllocated" access="public" output="false" returntype="numeric">
		<cfreturn variables.jRuntime.totalMemory() / 1024^2 />
	</cffunction>

	<cffunction name="getMemFreeAllocated" access="public" output="false" returntype="numeric">
		<cfreturn variables.jRuntime.freeMemory() / 1024^2 />
	</cffunction>

	<cffunction name="getMemUsed" access="public" output="false" returntype="numeric">
		<cfreturn (variables.jRuntime.totalMemory() - variables.jRuntime.freeMemory()) / 1024^2 />
	</cffunction>
	
	<cffunction name="getMemMax" access="public" output="false" returntype="numeric">
		<cfreturn jRuntime.maxMemory() / 1024^2 />
	</cffunction>
	
	<cffunction name="getMem" access="public" output="false" returntype="struct">
		<cfscript>
			var local = StructNew();
			local.st = StructNew();
			local.st.free = variables.getMemFree();
			local.st.allocated = variables.getMemAllocated();
			local.st.freeAllocated = variables.getMemFreeAllocated();
			local.st.used = variables.getMemUsed();
			local.st.max = variables.getMemMax();
			return local.st;
		</cfscript>
	</cffunction>
	
	<!--- Server --->
	<cffunction name="getUptime" access="public" output="false" returntype="numeric">
		<cfreturn DateDiff('s', server.coldfusion.expiration, Now()) />
	</cffunction>

	<cffunction name="getServerInfo" access="public" output="false" returntype="struct">
		<cfscript>
			var local = StructNew();
			local.data = StructNew();
			local.data.perfmon = GetMetricData('perf_monitor');
			local.data.load = GetMetricData('simple_load');
			local.data.requests = StructNew();
			local.data.requests.averageTime = GetMetricData('avg_req_time');
			local.data.requests.previousTime = GetMetricData('prev_req_time');
			return local.data;
		</cfscript>
	</cffunction>
</cfcomponent>