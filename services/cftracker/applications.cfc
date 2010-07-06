<cfcomponent output="false">
	<cfscript>
		variables.aspects = 'isInited,timeAlive,lastAccessed,idleTimeout,expired';
	</cfscript>

	<cffunction name="init" output="false" access="public">
		<cfscript>
			var local = {};
			
			variables.server = server.coldfusion.productName;
			variables.version = server.coldfusion.productVersion;
			
			if (ListFirst(variables.server, ' ') Eq 'ColdFusion') {
				variables.initCf(argumentCollection = arguments);
				this.getApps = variables.getAppsAdobe;
			} else if (variables.server Eq 'Railo') {
				variables.initRailo(argumentCollection = arguments);
				this.getApps = variables.getAppsRailo;
			}
			
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="initAdobe" access="private" output="false">
		<cfscript>
			var local = {};
			// Java Reflection for methods to avoid updating the last access date
			variables.methods = {};
			variables.mirror = [];

			local.class = variables.mirror.getClass().forName('coldfusion.runtime.ApplicationScope');
			variables.methods.timeAlive = local.class.getMethod('getElapsedTime', variables.mirror);
			variables.methods.lastAccessed = local.class.getMethod('getTimeSinceLastAccess', variables.mirror);
			variables.methods.idleTimeout = local.class.getMethod('getMaxInactiveInterval', variables.mirror);
			variables.methods.expired = local.class.getMethod('expired', variables.mirror);
			variables.methods.settings = local.class.getMethod('getApplicationSettings', variables.mirror);
			variables.methods.isInited = local.class.getMethod('isInited', variables.mirror);

			local.mirror = [];
			local.mirror[1] = CreateObject('java', 'java.lang.String').GetClass();
			variables.methods.getValue = local.class.getMethod('getValueWIthoutChange', local.mirror);
			
			// Application tracker
			variables.jAppTracker = CreateObject('java', 'coldfusion.runtime.ApplicationScopeTracker');
			// Session tracker
			variables.jSessTracker = CreateObject('java', 'coldfusion.runtime.SessionTracker');
		</cfscript>
	</cffunction>
	
	<cffunction name="initRailo" access="private" output="false">
		<cfargument name="password" type="string" required="true" />
		<cfscript>
			var local = {};
			variables.password = arguments.password;
			variables.configServer = getPageContext().getConfig().getConfigServer(variables.password);
		</cfscript>
	</cffunction>

	<cffunction name="getAppsRailo" access="private" output="false" returntype="array">
		<cfscript>
			var local = {};
			local.aApps = [];
			local.configs = variables.configServer.getConfigWebs(); 
			local.cLen = ArrayLen(local.configs);
			for (local.c = 1; local.c Lte local.cLen; local.c++){ 
				local.appScopes = local.configs[local.c].getFactory().getScopeContext().getAllApplicationScopes();
				for (local.app in local.appScopes) {
					ArrayAppend(local.aApps, local.app);
				}
			}
			return local.aApps;
		</cfscript>
	</cffunction>
	
	<cffunction name="getAppsAdobe" access="public" output="false" returntype="array">
		<cfscript>
			var local = {};
			local.aApps = [];
			local.oApps = variables.jAppTracker.getApplicationKeys();
			while (local.oApps.hasMoreElements()) {
				ArrayAppend(local.aApps, local.oApps.nextElement());
			}
			return local.aApps;
		</cfscript>
	</cffunction>
	
	<cffunction name="getScope" access="public" output="false">
		<cfargument name="appName" type="string" required="true" />
		<cfscript>
			var local = {};
			// Make sure we get something back
			local.scope = variables.jAppTracker.getApplicationScope(JavaCast('string', arguments.appName));
			if (Not IsDefined('local.scope')) {
				return false;
			} else {
				return local.scope;
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getScopeKeys" access="public" output="false" returntype="array">
		<cfargument name="appName" type="string" required="true" />
		<cfscript>
			var local = {};
			local.scope = variables.getScope(arguments.appName);
			local.keys = [];
			if (IsStruct(local.scope)) {
				local.keys = StructKeyArray(local.scope);
			}
			return local.keys;
		</cfscript>
	</cffunction>

	<cffunction name="getScopeValues" access="public" output="false" returntype="any">
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="keys" type="array" required="false" />
		<cfscript>
			var local = {};
			local.values = {};
			local.scope = variables.getScope(arguments.appName);
			// Make sure the scope exists
			if (IsStruct(local.scope)) {
				// If no keys passed, return all keys
				if (Not StructKeyExists(arguments, 'keys') Or ArrayLen(arguments.keys) Eq 0) {
					arguments.keys = StructKeyArray(local.scope);
				}
				local.length = ArrayLen(arguments.keys);
				// Retrieve keys if they exist
				local.mirror = [];
				for (local.i = 1; local.i Lte local.length; local.i++) {
					if (StructKeyExists(local.scope, arguments.keys[local.i])) {
						local.mirror[1] = JavaCast('string', arguments.keys[local.i]);
						local.values[arguments.keys[local.i]] = variables.methods.getValue.invoke(local.scope, local.mirror);
					}
				}
			}
			return local.values;
		</cfscript>
	</cffunction>

	<cffunction name="getSettings" access="public" output="false" returntype="any">
		<cfargument name="appName" required="true" type="string" />
		<cfscript>
			var local = {};
			local.scope = variables.getScope(arguments.appName);
			local.settings = {};
			if (IsStruct(local.scope)) {
				local.settings = variables.methods.settings.invoke(local.scope, variables.mirror);
				// Very odd issue with existing keys with null values.
				local.keys = StructKeyArray(local.settings);
				local.len = ArrayLen(local.keys);
				for (local.k = 1; local.k Lte local.len; local.k++) {
					if (Not StructKeyExists(local.settings, local.keys[local.k])) {
						StructDelete(local.settings, local.keys[local.k]);
					}
				}
			}
			return local.settings;
		</cfscript>
	</cffunction>

	<cffunction name="stop" returntype="boolean" output="false" access="public">
		<cfargument name="appName" type="string" required="true" />
		<cfscript>
			var local = {};
			local.scope = variables.getScope(arguments.appName);
			if (IsStruct(local.scope)) {
				variables.jAppTracker.cleanUp(local.scope);
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>

	<cffunction name="restart" returntype="boolean" output="false" access="public">
		<cfargument name="appName" type="string" required="true" />
		<cfscript>
			var local = {};
			local.scope = variables.getScope(arguments.appName);
			if (IsStruct(local.scope)) {
				local.scope.setIsInited(false);
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="touch" access="public" output="false" returntype="boolean">
		<cfargument name="appName" required="true" type="string" />
		<cfscript>
			var local = {};
			local.scope = variables.getScope(arguments.appName);
			if (IsStruct(local.scope)) {
				local.scope.setLastAccess();
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>

	<cffunction name="getInfo" access="public" output="false" returntype="struct">
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="aspects" type="string" required="false" default="" />
		<cfscript>
			var local = {};
			local.info = {};
			local.len = Len(Trim(arguments.aspects));
			if (local.len Eq 0) {
				arguments.aspects = ListAppend(variables.aspects, 'IdlePercent');
			}
			local.itemLen = ListLen(arguments.aspects);
			local.scope = variables.getScope(arguments.appName);
			if (IsStruct(local.scope)) {
				local.info.exists = true;
				for (local.i = 1; local.i Lte local.itemLen; local.i++) {
					local.item = ListGetat(arguments.aspects, local.i);
					if (ListFindNoCase(variables.aspects, local.item)) {
						local.info[local.item] = variables.methods[local.item].invoke(local.scope, variables.mirror);
					}
				}
				if (StructKeyExists(local.info, 'idleTimeout')) {
					local.info.idleTimeout = DateAdd('s', local.info.idleTimeout / 1000, DateAdd('s', -variables.methods.lastAccessed.invoke(local.scope, variables.mirror) / 1000, Now()));
				}
				if (StructKeyExists(local.info, 'timeAlive')) {
					local.info.timeAlive = DateAdd('s', -local.info.timeAlive / 1000, now());
				}
				if (StructKeyExists(local.info, 'lastAccessed')) {
					local.info.lastAccessed = DateAdd('s', -local.info.lastAccessed / 1000, now());
				}
				if (ListFindNoCase(arguments.aspects, 'idlePercent')) {
					if (ListFindNoCase(arguments.aspects, 'idlePercent')) {
						if (variables.methods.expired.invoke(local.scope, variables.mirror)) {
							local.info.idlePercent = 100;
						} else {
							local.info.idlePercent = variables.methods.lastAccessed.invoke(local.scope, variables.mirror) / variables.methods.idleTimeout.invoke(local.scope, variables.mirror) * 100;
						}
					}
				}
				if (ListFindNoCase(arguments.aspects, 'sessionCount')) {
					local.info.sessionCount = StructCount(variables.jSessTracker.getSessionCollection(JavaCast('string', arguments.appName)));
				}
			} else {
				local.info.exists = false;
			}
			return local.info;
		</cfscript>
	</cffunction>

	<cffunction name="getAppsInfo" access="public" output="false" returntype="struct">
		<cfscript>
			var local = {};
			local.info = {};
			local.oApps = variables.jAppTracker.getApplicationKeys();
			while (local.oApps.hasMoreElements()) {
				local.appName = local.oApps.nextElement();
				local.scope = variables.getScope(local.appName);
				if (IsStruct(local.scope)) {
					local.info[local.appName] = {exists = true};
					local.info[local.appName].isInited = variables.methods.isInited.invoke(local.scope, variables.mirror);
					local.info[local.appName].timeAlive = variables.methods.timeAlive.invoke(local.scope, variables.mirror) / 1000;
					local.info[local.appName].lastAccessed = variables.methods.lastAccessed.invoke(local.scope, variables.mirror) / 1000;
					local.info[local.appName].idleTimeout = variables.methods.idleTimeout.invoke(local.scope, variables.mirror) / 1000;
					local.info[local.appName].expired = variables.methods.expired.invoke(local.scope, variables.mirror);
					local.info[local.appName].lastAccessed = DateAdd('s', -local.info[local.appName].lastAccessed, now());
					local.info[local.appName].idleTimeout = DateAdd('s', local.info[local.appName].idleTimeout, local.info[local.appName].lastAccessed);
					local.info[local.appName].timeAlive = DateAdd('s', -local.info[local.appName].timeAlive, now());
					if (variables.methods.expired.invoke(local.scope, variables.mirror)) {
						local.info[local.appName].idlePercent = 100;
					} else {
						local.info[local.appName].idlePercent = variables.methods.lastAccessed.invoke(local.scope, variables.mirror) / variables.methods.idleTimeout.invoke(local.scope, variables.mirror) * 100;
					}
					local.info[local.appName].sessionCount = StructCount(variables.jSessTracker.getSessionCollection(JavaCast('string', local.appName)));
				} else {
					local.info[local.appName] = {exists = false};
				}
			}
			return local.info;
		</cfscript>
	</cffunction>

	<cffunction name="getIsInited" access="public" output="false" returntype="struct">
		<cfargument name="appName" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.appName, 'isinited') />
	</cffunction>
	
	<cffunction name="getTimeAlive" access="public" output="false" returntype="struct">
		<cfargument name="appName" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.appName, 'timeAlive') />
	</cffunction>

	<cffunction name="getLastAccessed" access="public" output="false" returntype="struct">
		<cfargument name="appName" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.appName, 'lastAccessed') />
	</cffunction>

	<cffunction name="getIdleTimeout" access="public" output="false" returntype="struct">
		<cfargument name="appName" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.appName, 'idleTimeout') />
	</cffunction>
	
	<cffunction name="getExpired" access="public" output="false" returntype="struct"> 
		<cfargument name="appName" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.appName, 'expired') />
	</cffunction>

	<cffunction name="getIdlePercent" access="public" output="false" returntype="numeric">
		<cfargument name="appName" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.appName, 'IdlePercent') />
	</cffunction>

	<cffunction name="getSessionCount" access="public" output="false" returntype="struct"> 
		<cfargument name="appName" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.appName, 'sessionCount') />
	</cffunction>
</cfcomponent>