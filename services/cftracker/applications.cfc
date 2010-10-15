<cfcomponent output="false">
	<cffunction name="init" output="false" access="public">
		<cfscript>
			var lc = {};
			
			variables.server = server.coldfusion.productName;
			variables.version = server.coldfusion.productVersion;
			
			if (ListFirst(variables.server, ' ') Eq 'ColdFusion') {
				initAdobe(argumentCollection = arguments);
				this.getApps = variables.getAppsAdobe;
				this.getScope = variables.getScopeAdobe;
				this.getScopeValues = variables.getScopeValuesAdobe;
				this.getSettings = variables.getSettingsAdobe;
				this.stop = variables.stopAdobe;
				this.restart = variables.restartAdobe;
				this.getInfo = variables.getInfoAdobe;
				this.getAppsInfo = variables.getAppsInfoAdobe;
				this.getIsInited = variables.getIsInitedAdobe;
				this.getTimeAlive = variables.getTimeAliveAdobe;
				this.getSessionCount = variables.getSessionCountAdobe;
				this.getAppsByKey = variables.getAppsByKeyAdobe;
				this.getAppsInfoByKey = variables.getAppsInfoByKeyAdobe;
			} else if (variables.server Eq 'Railo') {
				variables.initRailo(argumentCollection = arguments);
				this.getApps = variables.getAppsRailo;
				this.getScope = variables.getScopeRailo;
				this.getScopeValues = variables.getScopeValuesRailo;
				this.stop = variables.stopRailo;
				this.getInfo = variables.getInfoRailo;
				this.getAppsInfo = variables.getAppsInfoRailo;
				// this.getIsinited, getTimeAlive, getSessionCount, getSettings, restart
			}
			
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="initAdobe" access="private" output="false">
		<cfscript>
			var lc = {};
			variables.aspects = 'isInited,timeAlive,lastAccessed,idleTimeout,expired';

			// Java Reflection for methods to avoid updating the last access date
			variables.methods = {};
			variables.mirror = [];

			lc.class = variables.mirror.getClass().forName('coldfusion.runtime.ApplicationScope');
			variables.methods.timeAlive = lc.class.getMethod('getElapsedTime', variables.mirror);
			variables.methods.lastAccessed = lc.class.getMethod('getTimeSinceLastAccess', variables.mirror);
			variables.methods.idleTimeout = lc.class.getMethod('getMaxInactiveInterval', variables.mirror);
			variables.methods.expired = lc.class.getMethod('expired', variables.mirror);
			variables.methods.settings = lc.class.getMethod('getApplicationSettings', variables.mirror);
			variables.methods.isInited = lc.class.getMethod('isInited', variables.mirror);

			lc.mirror = [];
			lc.mirror[1] = CreateObject('java', 'java.lang.String').GetClass();
			variables.methods.getValue = lc.class.getMethod('getValueWIthoutChange', lc.mirror);
			
			// Application tracker
			variables.jAppTracker = CreateObject('java', 'coldfusion.runtime.ApplicationScopeTracker');
			// Session tracker
			variables.jSessTracker = CreateObject('java', 'coldfusion.runtime.SessionTracker');
		</cfscript>
	</cffunction>
	
	<cffunction name="initRailo" access="private" output="false">
		<cfargument name="password" type="string" required="true" />
		<cfargument name="adminType" type="string" required="true" />
		<cfscript>
			var lc = {};
			variables.aspects = 'lastAccessed,idleTimeout,expired';

			variables.password = arguments.password;
			variables.adminType = arguments.adminType;
			variables.config = getPageContext().getConfig();
		</cfscript>
	</cffunction>

	<cffunction name="getAppsRailo" access="private" output="false" returntype="struct">
		<cfscript>
			var lc = {};
			lc.stApps = {};
			if (variables.adminType Eq 'web') {
				lc.configs = [variables.config];
			} else {
				lc.configs = variables.config.getConfigServer(variables.password).getConfigWebs();
			}
			lc.cLen = ArrayLen(lc.configs);
			for (lc.c = 1; lc.c Lte lc.cLen; lc.c++) { 
				lc.wcId = lc.configs[lc.c].getServletContext().getRealPath('/');
				lc.stApps[lc.wcId] = [];
				lc.appScopes = lc.configs[lc.c].getFactory().getScopeContext().getAllApplicationScopes();
				for (lc.app in lc.appScopes) {
					if (Len(lc.app) Gt 0 And lc.appScopes[lc.app].isInitalized()) {
						ArrayAppend(lc.stApps[lc.wcId], lc.app);
					}
				}
			}
			return lc.stApps;
		</cfscript>
	</cffunction>
	
	<cffunction name="getAppsAdobe" access="public" output="false" returntype="struct">
		<cfscript>
			var lc = {};
			lc.stApps = {};
			lc.stApps['Adobe'] = [];
			lc.oApps = variables.jAppTracker.getApplicationKeys();
			while (lc.oApps.hasMoreElements()) {
				ArrayAppend(lc.stApps.adobe, lc.oApps.nextElement());
			}
			return lc.stApps;
		</cfscript>
	</cffunction>
	
	<cffunction name="getAppsByKeyAdobe" access="private" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />
		<cfscript>
			lc.stApps = {};
			lc.stApps['Adobe'] = [];
			lc.oApps = variables.jAppTracker.getApplicationKeys();
			lc.mirror = [];
			while (lc.oApps.hasMoreElements()) {
				lc.appName = lc.oApps.nextElement();
				lc.scope = variables.jAppTracker.getApplicationScope(JavaCast('string', lc.appName));
				if (IsDefined('lc.scope')) {
					if (StructKeyExists(lc.scope, arguments.name)) {
						lc.mirror[1] = JavaCast('string', arguments.name);
						lc.key = variables.methods.getValue.invoke(lc.scope, lc.mirror);
						if (lc.key Eq arguments.value) {
							ArrayAppend(lc.stApps.adobe, lc.appName);
						}
					}
				}
			}
			return lc.stApps;
		</cfscript>
	</cffunction>
	
	<cffunction name="getScopeRailo" access="private" output="false">
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="wc" type="string" required="true" />
		<cfscript>
			var lc = {};
			if (variables.adminType Eq 'web') {
				lc.configs = [variables.config];
			} else {
				lc.configs = variables.config.getConfigServer(variables.password).getConfigWebs();
			}
			lc.cLen = ArrayLen(lc.configs);
			for (lc.c = 1; lc.c Lte lc.cLen; lc.c++) {
				lc.wcId = lc.configs[lc.c].getServletContext().getRealPath('/');
				if (arguments.wc Eq lc.wcId) {
					lc.appScopes = lc.configs[lc.c].getFactory().getScopeContext().getAllApplicationScopes();
					if (StructKeyExists(lc.appScopes, arguments.appName)) {
						return lc.appScopes[arguments.appName];
					}
				}
			}
			return false;
		</cfscript>
	</cffunction>
	
	<cffunction name="getScopeAdobe" access="private" output="false">
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfscript>
			var lc = {};
			// Make sure we get something back
			lc.scope = variables.jAppTracker.getApplicationScope(JavaCast('string', arguments.appName));
			if (Not IsDefined('lc.scope')) {
				return false;
			} else {
				return lc.scope;
			}
		</cfscript>
	</cffunction>

	<cffunction name="getScopeKeys" access="public" output="false" returntype="array">
		<cfargument name="appName" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.scope = this.getScope(arguments.appName);
			lc.keys = [];
			if (IsStruct(lc.scope)) {
				lc.keys = StructKeyArray(lc.scope);
			}
			return lc.keys;
		</cfscript>
	</cffunction>

	<cffunction name="getScopeValuesRailo" access="private" output="false" returntype="any">
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="keys" type="array" required="false" />
		<cfscript>
			var lc = {};
			lc.values = {};
			lc.scope = variables.getScopeRailo(arguments.appName);
			// Make sure the scope exists
			if (IsStruct(lc.scope)) {
				// If no keys passed, return all keys
				if (Not StructKeyExists(arguments, 'keys') Or ArrayLen(arguments.keys) Eq 0) {
					return lc.scope;
				}
				lc.length = ArrayLen(arguments.keys);
				// Retrieve keys if they exist
				for (lc.key in lc.scope) {
					if (ArrayContainsNoCase(arguments.keys, lc.key)) {
						lc.values[lc.key] = lc.scope[lc.key];
					}
				}
			}
			return lc.values;
		</cfscript>
	</cffunction>
	
	<cffunction name="getScopeValuesAdobe" access="private" output="false" returntype="any">
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="keys" type="array" required="false" />
		<cfscript>
			var lc = {};
			lc.values = {};
			lc.scope = variables.getScopeAdobe(arguments.appName);
			// Make sure the scope exists
			if (IsStruct(lc.scope)) {
				// If no keys passed, return all keys
				if (Not StructKeyExists(arguments, 'keys') Or ArrayLen(arguments.keys) Eq 0) {
					arguments.keys = StructKeyArray(lc.scope);
				}
				lc.length = ArrayLen(arguments.keys);
				// Retrieve keys if they exist
				lc.mirror = [];
				for (lc.i = 1; lc.i Lte lc.length; lc.i++) {
					if (StructKeyExists(lc.scope, arguments.keys[lc.i])) {
						lc.mirror[1] = JavaCast('string', arguments.keys[lc.i]);
						lc.values[arguments.keys[lc.i]] = variables.methods.getValue.invoke(lc.scope, lc.mirror);
					}
				}
			}
			return lc.values;
		</cfscript>
	</cffunction>

	<cffunction name="getSettingsAdobe" access="private" output="false" returntype="any">
		<cfargument name="appName" required="true" type="string" />
		<cfscript>
			var lc = {};
			lc.scope = variables.getScopeAdobe(arguments.appName);
			lc.settings = {};
			if (IsStruct(lc.scope)) {
				lc.settings = variables.methods.settings.invoke(lc.scope, variables.mirror);
				// Very odd issue with existing keys with null values.
				lc.keys = StructKeyArray(lc.settings);
				lc.len = ArrayLen(lc.keys);
				for (lc.k = 1; lc.k Lte lc.len; lc.k++) {
					if (Not StructKeyExists(lc.settings, lc.keys[lc.k])) {
						StructDelete(lc.settings, lc.keys[lc.k]);
					}
				}
			}
			return lc.settings;
		</cfscript>
	</cffunction>

	<cffunction name="stopAdobe" returntype="boolean" output="false" access="private">
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfscript>
			var lc = {};
			lc.scope = variables.getScopeAdobe(arguments.appName);
			if (IsStruct(lc.scope)) {
				variables.jAppTracker.cleanUp(lc.scope);
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>

	<cffunction name="stopRailo" returntype="boolean" output="false" access="private">
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="wc" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.scope = variables.getScopeRailo(arguments.appName, arguments.wc);
			if (IsStruct(lc.scope)) {
				lc.scope.release();
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>

	<cffunction name="restartAdobe" returntype="boolean" output="false" access="private">
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfscript>
			var lc = {};
			lc.scope = variables.getScope(arguments.appName);
			if (IsStruct(lc.scope)) {
				lc.scope.setIsInited(false);
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="touchAdobe" access="private" output="false" returntype="boolean">
		<cfargument name="appName" required="true" type="string" />
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfscript>
			var lc = {};
			lc.scope = variables.getScopeAdobe(arguments.appName);
			if (IsStruct(lc.scope)) {
				lc.scope.setLastAccess();
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>

	<cffunction name="touchRailo" access="private" output="false" returntype="boolean">
		<cfargument name="appName" required="true" type="string" />
		<cfargument name="wc" required="true" type="string" />
		<cfscript>
			var lc = {};
			lc.scope = variables.getScopeRailo(arguments.appName, arguments.wc);
			if (IsStruct(lc.scope)) {
				lc.scope.touch();
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>

	<cffunction name="getInfoAdobe" access="private" output="false" returntype="struct">
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="wc" type="string" required="true" />
		<cfargument name="aspects" type="string" required="false" default="" />
		<cfscript>
			var lc = {};
			lc.info = {};
			lc.len = Len(Trim(arguments.aspects));
			if (lc.len Eq 0) {
				arguments.aspects = ListAppend(variables.aspects, 'IdlePercent');
			}
			lc.itemLen = ListLen(arguments.aspects);
			lc.scope = variables.getScopeAdobe(arguments.appName);
			if (IsStruct(lc.scope)) {
				lc.info.exists = true;
				for (lc.i = 1; lc.i Lte lc.itemLen; lc.i++) {
					lc.item = ListGetat(arguments.aspects, lc.i);
					if (ListFindNoCase(variables.aspects, lc.item)) {
						lc.info[lc.item] = variables.methods[lc.item].invoke(lc.scope, variables.mirror);
					}
				}
				if (StructKeyExists(lc.info, 'idleTimeout')) {
					lc.info.idleTimeout = DateAdd('s', lc.info.idleTimeout / 1000, DateAdd('s', -variables.methods.lastAccessed.invoke(lc.scope, variables.mirror) / 1000, Now()));
				}
				if (StructKeyExists(lc.info, 'timeAlive')) {
					lc.info.timeAlive = DateAdd('s', -lc.info.timeAlive / 1000, now());
				}
				if (StructKeyExists(lc.info, 'lastAccessed')) {
					lc.info.lastAccessed = DateAdd('s', -lc.info.lastAccessed / 1000, now());
				}
				if (ListFindNoCase(arguments.aspects, 'idlePercent')) {
					if (variables.methods.expired.invoke(lc.scope, variables.mirror)) {
						lc.info.idlePercent = 100;
					} else {
						lc.info.idlePercent = variables.methods.lastAccessed.invoke(lc.scope, variables.mirror) / variables.methods.idleTimeout.invoke(lc.scope, variables.mirror) * 100;
					}
				}
				if (ListFindNoCase(arguments.aspects, 'sessionCount')) {
					lc.info.sessionCount = StructCount(variables.jSessTracker.getSessionCollection(JavaCast('string', arguments.appName)));
				}
			} else {
				lc.info.exists = false;
			}
			return lc.info;
		</cfscript>
	</cffunction>

	<cffunction name="getInfoRailo" access="private" output="false" returntype="struct">
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="wc" type="string" required="true" />
		<cfargument name="aspects" type="string" required="false" default="" />
		<cfscript>
			var lc = {};
			lc.info = {};
			lc.len = Len(Trim(arguments.aspects));
			if (lc.len Eq 0) {
				arguments.aspects = ListAppend(variables.aspects, 'IdlePercent');
			}
			lc.itemLen = ListLen(arguments.aspects);
			lc.scope = variables.getScopeRailo(arguments.appName, arguments.wc);
			if (IsStruct(lc.scope)) {
				lc.info.exists = true;
				if (ListFindNoCase(arguments.aspects, 'lastAccessed')) {
					lc.info.lastAccessed = lc.scope.getLastAccess();
				}
				if (ListFindNoCase(arguments.aspects, 'idleTimeout')) {
					lc.info.idleTimeout = lc.scope.getTimeSpan();
				}
				if (ListFindNoCase(arguments.aspects, 'expired')) {
					lc.info.expired = lc.scope.isExpired();
				}
				if (StructKeyExists(lc.info, 'idleTimeout')) {
					lc.info.idleTimeout = DateAdd('s', lc.info.idleTimeout / 1000, DateAdd('s', -lc.scope.getLastAccess() / 1000, Now()));
				}
				if (StructKeyExists(lc.info, 'lastAccessed')) {
					lc.info.lastAccessed = DateAdd('s', -lc.info.lastAccessed / 1000, now());
				}
				if (ListFindNoCase(arguments.aspects, 'idlePercent')) {
					if (lc.scope.isExpired()) {
						lc.info.idlePercent = 100;
					} else {
						lc.info.idlePercent = lc.scope.getLastAccess() / lc.scope.getTimeSpan() * 100;
					}
				}
				if (ListFindNoCase(arguments.aspects, 'sessionCount')) {
					lc.info.sessionCount = 0;
					if (variables.adminType Eq 'web') {
						lc.configs = [variables.config];
					} else {
						lc.configs = variables.config.getConfigServer(variables.password).getConfigWebs();
					}
					lc.cLen = ArrayLen(lc.configs);
					for (lc.c = 1; lc.c Lte lc.cLen; lc.c++) {
						lc.wcId = lc.configs[lc.c].getServletContext().getRealPath('/');
						if (arguments.wc Eq lc.wcId) {
							lc.scopeContext = lc.configs[lc.c].getFactory().getScopeContext();
							lc.appScopes = lc.scopeContext.getAllApplicationScopes();
							if (StructKeyExists(lc.appScopes, arguments.appName)) {
								if (server.railo.version Lt '3.1.2.002') {
									lc.info.sessionCount = StructCount(lc.scopeContext.getAllSessionScopes(getPageContext(), lc.app));
								} else {
									lc.info.sessionCount = StructCount(lc.scopeContext.getAllSessionScopes(lc.configs[lc.c], lc.app));
								}
							}
						}
					}
				}
			} else {
				lc.info.exists = false;
			}
			return lc.info;
		</cfscript>
	</cffunction>

	<cffunction name="getAppsInfoAdobe" access="private" output="false" returntype="struct">
		<cfscript>
			var lc = {};
			lc.info = {};
			lc.info['Adobe'] = {};
			lc.oApps = variables.jAppTracker.getApplicationKeys();
			while (lc.oApps.hasMoreElements()) {
				lc.appName = lc.oApps.nextElement();
				lc.scope = variables.getScopeAdobe(lc.appName);
				if (IsStruct(lc.scope)) {
					lc.info.adobe[lc.appName] = {exists = true};
					lc.info.adobe[lc.appName].isInited = variables.methods.isInited.invoke(lc.scope, variables.mirror);
					lc.info.adobe[lc.appName].timeAlive = variables.methods.timeAlive.invoke(lc.scope, variables.mirror);
					lc.info.adobe[lc.appName].lastAccessed = variables.methods.lastAccessed.invoke(lc.scope, variables.mirror);
					lc.info.adobe[lc.appName].idleTimeout = variables.methods.idleTimeout.invoke(lc.scope, variables.mirror);
					lc.info.adobe[lc.appName].expired = variables.methods.expired.invoke(lc.scope, variables.mirror);
					lc.info.adobe[lc.appName].lastAccessed = DateAdd('s', -lc.info.adobe[lc.appName].lastAccessed / 1000, now());
					lc.info.adobe[lc.appName].idleTimeout = DateAdd('s', lc.info.adobe[lc.appName].idleTimeout / 1000, lc.info.adobe[lc.appName].lastAccessed);
					lc.info.adobe[lc.appName].timeAlive = DateAdd('s', -lc.info.adobe[lc.appName].timeAlive / 1000, now());
					if (variables.methods.expired.invoke(lc.scope, variables.mirror)) {
						lc.info.adobe[lc.appName].idlePercent = 100;
					} else {
						lc.info.adobe[lc.appName].idlePercent = variables.methods.lastAccessed.invoke(lc.scope, variables.mirror) / variables.methods.idleTimeout.invoke(lc.scope, variables.mirror) * 100;
					}
					lc.info.adobe[lc.appName].sessionCount = StructCount(variables.jSessTracker.getSessionCollection(JavaCast('string', lc.appName)));
				} else {
					lc.info.adobe[lc.appName] = {exists = false};
				}
			}
			return lc.info;
		</cfscript>
	</cffunction>

	<cffunction name="getAppsInfoRailo" access="private" output="false" returntype="struct">
		<cfscript>
			var lc = {};
			lc.info = {};
			if (variables.adminType Eq 'web') {
				lc.configs = [variables.config];
			} else {
				lc.configs = variables.config.getConfigServer(variables.password).getConfigWebs();
			}
			lc.cLen = ArrayLen(lc.configs);
			for (lc.c = 1; lc.c Lte lc.cLen; lc.c++) { 
				lc.wcId = lc.configs[lc.c].getServletContext().getRealPath('/');
				lc.info[lc.wcId] = {};
				lc.scopeContext = lc.configs[lc.c].getFactory().getScopeContext();
				lc.appScopes = lc.scopeContext.getAllApplicationScopes();
				for (lc.appName in lc.appScopes) {
					if (Len(lc.appName) Gt 0 And lc.appScopes[lc.appName].isInitalized()) {
						lc.scope = lc.appScopes[lc.appName];
						if (IsStruct(lc.scope)) {
							lc.info[lc.wcId][lc.appName] = {exists = true};
							lc.info[lc.wcId][lc.appName].lastAccessed = lc.scope.getLastAccess();
							lc.info[lc.wcId][lc.appName].idleTimeout = lc.scope.getTimeSpan();
							lc.info[lc.wcId][lc.appName].expired = lc.scope.isExpired();
							lc.info[lc.wcId][lc.appName].idleTimeout = DateAdd('s', lc.info[lc.wcId][lc.appName].idleTimeout / 1000, DateAdd('s', -lc.scope.getLastAccess() / 1000, Now()));
							lc.info[lc.wcId][lc.appName].lastAccessed = DateAdd('s', -lc.info[lc.wcId][lc.appName].lastAccessed / 1000, now());
							if (lc.scope.isExpired()) {
								lc.info[lc.wcId][lc.appName].idlePercent = 100;
							} else {
								lc.info[lc.wcId][lc.appName].idlePercent = lc.scope.getLastAccess() / lc.scope.getTimeSpan() * 100;
							}
							if (server.railo.version Lt '3.1.2.002') {
								lc.info[lc.wcId][lc.appName].sessionCount = StructCount(lc.scopeContext.getAllSessionScopes(getPageContext(), lc.appName));
							} else {
								lc.info[lc.wcId][lc.appName].sessionCount = StructCount(lc.scopeContext.getAllSessionScopes(lc.configs[lc.c], lc.appName));
							}
						} else {
							lc.info[lc.wcId][lc.appName] = {exists = false};
						}
					}
				}
			}
			return lc.info;
		</cfscript>
	</cffunction>
	
		<cffunction name="getAppsInfoByKeyAdobe" access="private" output="false" returntype="struct">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.info = {};
			lc.info['Adobe'] = {};
			lc.stApps = variables.getAppsByKeyAdobe(arguments.name, arguments.value);
			lc.len = ArrayLen(lc.stApps['adobe']);
			for (lc.i = 1; lc.i Lte lc.len; lc.i++) {
				lc.appName = lc.stApps['adobe'][lc.i];
				lc.scope = variables.getScopeAdobe(lc.appName);
				if (IsStruct(lc.scope)) {
					lc.info.adobe[lc.appName] = {exists = true};
					lc.info.adobe[lc.appName].isInited = variables.methods.isInited.invoke(lc.scope, variables.mirror);
					lc.info.adobe[lc.appName].timeAlive = variables.methods.timeAlive.invoke(lc.scope, variables.mirror);
					lc.info.adobe[lc.appName].lastAccessed = variables.methods.lastAccessed.invoke(lc.scope, variables.mirror);
					lc.info.adobe[lc.appName].idleTimeout = variables.methods.idleTimeout.invoke(lc.scope, variables.mirror);
					lc.info.adobe[lc.appName].expired = variables.methods.expired.invoke(lc.scope, variables.mirror);
					lc.info.adobe[lc.appName].lastAccessed = DateAdd('s', -lc.info.adobe[lc.appName].lastAccessed / 1000, now());
					lc.info.adobe[lc.appName].idleTimeout = DateAdd('s', lc.info.adobe[lc.appName].idleTimeout / 1000, lc.info.adobe[lc.appName].lastAccessed);
					lc.info.adobe[lc.appName].timeAlive = DateAdd('s', -lc.info.adobe[lc.appName].timeAlive / 1000, now());
					if (variables.methods.expired.invoke(lc.scope, variables.mirror)) {
						lc.info.adobe[lc.appName].idlePercent = 100;
					} else {
						lc.info.adobe[lc.appName].idlePercent = variables.methods.lastAccessed.invoke(lc.scope, variables.mirror) / variables.methods.idleTimeout.invoke(lc.scope, variables.mirror) * 100;
					}
					lc.info.adobe[lc.appName].sessionCount = StructCount(variables.jSessTracker.getSessionCollection(JavaCast('string', lc.appName)));
				} else {
					lc.info.adobe[lc.appName] = {exists = false};
				}
			}
			return lc.info;
		</cfscript>
	</cffunction>

	<cffunction name="getIsInitedAdobe" access="private" output="false" returntype="struct">
		<cfargument name="appName" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.appName, 'isinited') />
	</cffunction>
	
	<cffunction name="getTimeAliveAdobe" access="private" output="false" returntype="struct">
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

	<cffunction name="getSessionCountAdobe" access="private" output="false" returntype="struct"> 
		<cfargument name="appName" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.appName, 'sessionCount') />
	</cffunction>
</cfcomponent>