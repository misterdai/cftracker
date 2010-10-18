<cfcomponent output="false">
	<cffunction name="init" output="false" access="public">
		<cfscript>
			var lc = {};
			
			variables.server = server.coldfusion.productName;
			variables.version = server.coldfusion.productVersion;
			
			if (ListFirst(variables.server, ' ') Eq 'ColdFusion') {
				initAdobe(argumentCollection = arguments);
				this.getSessions = variables.getSessionsAdobe;
				this.getInfo = variables.getInfoAdobe;
				this.getScope = variables.getScopeAdobe;
				this.getCount = variables.getCountAdobe;
				this.getSessionsByAppKey = variables.getSessionsByAppKeyAdobe;
				this.getInfoByAppKey = variables.getInfoByAppKeyAdobe;
			} else if (variables.server Eq 'Railo') {
				variables.initRailo(argumentCollection = arguments);
				this.getSessions = variables.getSessionsRailo;
				this.getInfo = variables.getInfoRailo;
				this.getScope = variables.getScopeRailo;
				this.getCount = variables.getCountRailo;
			}
			
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="initAdobe" output="false" access="public">
		<cfscript>
			var lc = {};

			variables.aspects = 'timeAlive,lastAccessed,idleTimeout,expired,clientIp,idFromUrl,isNew,isJ2eeSession';

			// Java Reflection for methods to avoid updating the last access date
			variables.methods = {};
			variables.mirror = [];

			lc.class = variables.mirror.getClass().forName('coldfusion.runtime.SessionScope');
			variables.methods.timeAlive = lc.class.getMethod('getElapsedTime', variables.mirror);
			variables.methods.lastAccessed = lc.class.getMethod('getTimeSinceLastAccess', variables.mirror);
			variables.methods.idleTimeout = lc.class.getMethod('getMaxInactiveInterval', variables.mirror);
			variables.methods.expired = lc.class.getMethod('expired', variables.mirror);
			variables.methods.clientIp = lc.class.getMethod('getClientIp', variables.mirror);
			variables.methods.idFromUrl = lc.class.getMethod('isIdFromURL', variables.mirror);
			variables.methods.isNew = lc.class.getMethod('isNew', variables.mirror);
			variables.methods.isJ2eeSession = lc.class.getMethod('IsJ2eeSession', variables.mirror);
			
			lc.mirror = [];
			lc.mirror[1] = CreateObject('java', 'java.lang.String').GetClass();
			variables.methods.getValue = lc.class.getMethod('getValueWIthoutChange', lc.mirror);

			lc.class = variables.mirror.getClass().forName('coldfusion.runtime.ApplicationScope');
			lc.mirror = [];
			lc.mirror[1] = CreateObject('java', 'java.lang.String').GetClass();
			variables.methods.getAppValue = lc.class.getMethod('getValueWIthoutChange', lc.mirror);

			
			// Session tracker
			variables.jSessTracker = CreateObject('java', 'coldfusion.runtime.SessionTracker');
			// Application tracker
			variables.jAppTracker = CreateObject('java', 'coldfusion.runtime.ApplicationScopeTracker');
		</cfscript>
	</cffunction>

	<cffunction name="initRailo" access="private" output="false">
		<cfargument name="password" type="string" required="true" />
		<cfargument name="admintype" type="string" required="true" />
		<cfscript>
			var lc = {};
			variables.aspects = '';

			variables.password = arguments.password;
			variables.adminType = arguments.adminType;
			variables.config = getPageContext().getConfig();
		</cfscript>
	</cffunction>

	<cffunction name="getSessionsRailo" access="private" output="false" returntype="struct">
		<cfargument name="appName" type="string" required="false" />
		<cfargument name="wc" type="string" required="false" />
		<cfscript>
			var lc = {};
			if (variables.adminType Eq 'web') {
				lc.configs = [variables.config];
			} else {
				lc.configs = variables.config.getConfigServer(variables.password).getConfigWebs();
			}
			lc.len = ArrayLen(lc.configs);
			lc.sessions = {};
			for (lc.c = 1; lc.c Lte lc.len; lc.c++) {
				lc.cname = lc.configs[lc.c].getServletContext().getRealPath('/');
				if (Not StructKeyExists(arguments, 'wc') Or lc.cname Eq arguments.wc) {
					lc.scopeContext = lc.configs[lc.c].getFactory().getScopeContext();
					lc.appScopes = lc.scopeContext.getAllApplicationScopes();
					for (lc.app in lc.appScopes) {
						if (Len(lc.app) Gt 0 And (Not StructKeyExists(arguments, 'appName') Or lc.app Eq arguments.appName)) {
							if (server.railo.version Lt '3.1.2.002') {
								lc.temp = lc.scopeContext.getAllSessionScopes(getPageContext(), lc.app);
							} else {
								lc.temp = lc.scopeContext.getAllSessionScopes(lc.configs[lc.c], lc.app);
							}
							lc.keys = StructKeyArray(lc.temp);
							if (ArrayLen(lc.keys) Gt 0) {
								lc.sessions[lc.cname][lc.app] = lc.keys;
							}
						}
					}
				}
			}
			return lc.sessions;
		</cfscript>
	</cffunction>

	<cffunction name="getSessionsAdobe" access="private" output="false" returntype="struct">
		<cfargument name="appName" type="string" required="false" />
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfscript>
			var lc = {};
			lc.stSess = {};
			lc.stSess['Adobe'] = {};
			if (Not StructKeyExists(arguments, 'appName')) {
				lc.oApps = variables.jAppTracker.getApplicationKeys();
				while (lc.oApps.hasMoreElements()) {
					lc.app = lc.oApps.nextElement();
					lc.sessions = variables.jSessTracker.getSessionCollection(JavaCast('string', lc.app));
					lc.stSess.adobe[lc.app] = StructKeyArray(lc.sessions);
				}
			} else {
				lc.sessions = variables.jSessTracker.getSessionCollection(JavaCast('string', arguments.appName));
				lc.stSess.adobe[arguments.appName] = StructKeyArray(lc.sessions);
			}
			return lc.stSess;
		</cfscript>
	</cffunction>
	
	<cffunction name="getSessionsByAppKeyAdobe" access="private" output="false" returntype="struct">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.stSess = {};
			lc.stSess['Adobe'] = {};
			lc.oApps = variables.jAppTracker.getApplicationKeys();
			lc.mirror = [];
			while (lc.oApps.hasMoreElements()) {
				lc.appName = lc.oApps.nextElement();
				lc.scope = variables.jAppTracker.getApplicationScope(JavaCast('string', lc.appName));
				if (IsDefined('lc.scope')) {
					if (StructKeyExists(lc.scope, arguments.name)) {
						lc.mirror[1] = JavaCast('string', arguments.name);
						lc.key = variables.methods.getAppValue.invoke(lc.scope, lc.mirror);
						if (lc.key Eq arguments.value) {
							lc.sessions = variables.jSessTracker.getSessionCollection(JavaCast('string', lc.appName));
							lc.stSess.adobe[lc.appName] = StructKeyArray(lc.sessions);
						}
					}
				}
			}
			return lc.stSess;
		</cfscript>
	</cffunction>
	
	<cffunction name="getCountRailo" access="private" output="false" returntype="numeric">
		<cfargument name="appName" type="string" required="false" />
		<cfargument name="wc" type="string" required="false" />
		<cfscript>
			var lc = {};
			if (variables.adminType Eq 'web') {
				lc.configs = [variables.config];
			} else {
				lc.configs = variables.config.getConfigServer(variables.password).getConfigWebs();
			}
			lc.cLen = ArrayLen(lc.configs);
			if (Not StructKeyExists(arguments, 'appName')) {
				lc.count = 0;
				for (lc.c = 1; lc.c Lte lc.cLen; lc.c++) {
					lc.wcId = lc.configs[lc.c].getServletContext().getRealPath('/');
					lc.scopeContext = lc.configs[lc.c].getFactory().getScopeContext();
					lc.appScopes = lc.scopeContext.getAllApplicationScopes();
					for (lc.app in lc.appScopes) {
						if (server.railo.version Lt '3.1.2.002') {
							lc.count += StructCount(lc.scopeContext.getAllSessionScopes(getPageContext(), lc.app));
						} else {
							lc.count += StructCount(lc.scopeContext.getAllSessionScopes(lc.configs[lc.c], lc.app));
						}
					}
				}
				return lc.count;
			} else {
				for (lc.c = 1; lc.c Lte lc.cLen; lc.c++) {
					lc.wcId = lc.configs[lc.c].getServletContext().getRealPath('/');
					if (arguments.wc Eq lc.wcId) {
						lc.scopeContext = lc.configs[lc.c].getFactory().getScopeContext();
						lc.appScopes = lc.scopeContext.getAllApplicationScopes();
						if (StructKeyExists(lc.appScopes, arguments.appName)) {
							if (server.railo.version Lt '3.1.2.002') {
								return StructCount(lc.scopeContext.getAllSessionScopes(getPageContext(), arguments.appName));
							} else {
								return StructCount(lc.scopeContext.getAllSessionScopes(lc.configs[lc.c], arguments.appName));
							}
						}
					}
				}
				return 0;
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getCountAdobe" access="private" output="false" returntype="numeric">
		<cfargument name="appName" type="string" required="false" />
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfscript>
			var lc = {};
			if (Not StructKeyExists(arguments, 'appName')) {
				return variables.jSessTracker.getSessionCount();
			} else {
				lc.sessions = variables.jSessTracker.getSessionCollection(JavaCast('string', arguments.appName));
				return StructCount(lc.sessions);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getScopeRailo" access="private" output="false">
		<cfargument name="wc" type="string" required="true" />
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="sessId" type="string" required="true" />
		<cfscript>
			var lc = {};
			if (variables.adminType Eq 'web') {
				lc.configs = [variables.config];
			} else {
				lc.configs = variables.config.getConfigServer(variables.password).getConfigWebs();
			}
			lc.len = ArrayLen(lc.configs);
			lc.sessions = {};
			for (lc.c = 1; lc.c Lte lc.len; lc.c++) {
				lc.cname = lc.configs[lc.c].getServletContext().getRealPath('/');
				if (lc.cname Eq arguments.wc) {
					lc.scopeContext = lc.configs[lc.c].getFactory().getScopeContext();
					lc.appScopes = lc.scopeContext.getAllApplicationScopes();
					if (StructKeyExists(lc.appScopes, arguments.appName)) {
						if (server.railo.version Lt '3.1.2.002') {
							lc.temp = lc.scopeContext.getAllSessionScopes(getPageContext(), arguments.appName);
						} else {
							lc.temp = lc.scopeContext.getAllSessionScopes(lc.configs[lc.c], arguments.appName);
						}
						if (StructKeyExists(lc.temp, arguments.sessId)) {
							return lc.temp[arguments.sessId];
						} else {
							return false;
						}
					}
				}
			}
			return false;
		</cfscript>
	</cffunction>
	
	<cffunction name="getScopeAdobe" access="private" output="false">
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfargument name="appName" type="string" required="false" />
		<cfargument name="sessId" type="string" required="true" />
		<cfscript>
			var lc = {};
			// Make sure we get something back
			lc.scope = variables.jSessTracker.getSession(JavaCast('string', arguments.sessId));
			if (Not IsDefined('lc.scope')) {
				return false;
			} else {
				return lc.scope;
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getScopeKeys" access="public" output="false" returntype="array">
		<cfargument name="sessId" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.scope = variables.getScope(arguments.sessId);
			lc.keys = [];
			if (IsStruct(lc.scope)) {
				lc.keys = StructKeyArray(lc.scope);
			}
			return lc.keys;
		</cfscript>
	</cffunction>
	
	<cffunction name="getScopeValues" access="public" output="false" returntype="any">
		<cfargument name="sessId" type="string" required="true" />
		<cfargument name="keys" type="array" required="false" />
		<cfscript>
			var lc = {};
			lc.values = {};
			lc.scope = variables.getScope(arguments.sessId);
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
	
	<cffunction name="stop" returntype="boolean" output="false" access="public">
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfargument name="appName" type="string" required="false" default="" />
		<cfargument name="sessId" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.scope = variables.getScopeAdobe(arguments.wc, arguments.appName, arguments.sessId);
			if (IsStruct(lc.scope)) {
				lc.sid = ReReplace(arguments.sessId, '.*_([^_]+_[^_]+)$', '\1');
				lc.appName = ReReplace(arguments.sessId, '(.*)_[^_]+_[^_]+$', '\1');
				variables.jSessTracker.cleanUp(lc.appName, lc.sid);
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="stopByApp" returntype="boolean" output="false" access="public">
		<cfargument name="appName" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.sessions = variables.jSessTracker.getSessionCollection(JavaCast('string', arguments.appName));
			lc.aSess = StructKeyArray(lc.sessions);
			lc.len = ArrayLen(lc.aSess);
			for (lc.i = 1; lc.i Lte lc.len; lc.i++) {
				lc.sid = ReReplace(lc.aSess[lc.i], '.*_([^_]+_[^_]+)$', '\1');
				lc.appName = ReReplace(lc.aSess[lc.i], '(.*)_[^_]+_[^_]+$', '\1');
				variables.jSessTracker.cleanUp(lc.appName, lc.sid);
			}
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="touch" access="public" output="false" returntype="boolean">
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfargument name="appName" type="string" required="false" default="" />
		<cfargument name="sessId" required="true" type="string" />
		<cfscript>
			var lc = {};
			lc.scope = variables.getScopeAdobe(arguments.wc, arguments.appName, arguments.sessId);
			if (IsStruct(lc.scope)) {
				lc.scope.setLastAccess();
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>

	<cffunction name="getInfoRailo" access="private" output="false" returntype="struct">
		<cfargument name="sessId" type="any" required="false" />
		<cfargument name="aspects" type="string" required="false" default="" />
		<cfscript>
			var lc = {};
			lc.info = {};
			lc.len = Len(Trim(arguments.aspects));
			if (lc.len Eq 0) {
				arguments.aspects = variables.aspects;
			}
			if (Not StructKeyExists(arguments, 'sessId')) {
				arguments.sessId = variables.getSessionsRailo();
			}
			if (variables.adminType Eq 'web') {
				lc.configs = [variables.config];
			} else {
				lc.configs = variables.config.getConfigServer(variables.password).getConfigWebs();
			}
			lc.len = ArrayLen(lc.configs);
			for (lc.c = 1; lc.c Lte lc.len; lc.c++) {
				lc.cname = lc.configs[lc.c].getServletContext().getRealPath('/');
				if (StructKeyExists(arguments.sessId, lc.cname)) {
					lc.scopeContext = lc.configs[lc.c].getFactory().getScopeContext();
					lc.appScopes = lc.scopeContext.getAllApplicationScopes();
					for (lc.app in lc.appScopes) {
						if (Len(lc.app) Gt 0 And StructKeyExists(arguments.sessId[lc.cname], lc.app)) {
							if (server.railo.version Lt '3.1.2.002') {
								lc.appSessions = lc.scopeContext.getAllSessionScopes(getPageContext(), lc.app);
							} else {
								lc.appSessions = lc.scopeContext.getAllSessionScopes(lc.configs[lc.c], lc.app);
							}
							lc.sLen = ArrayLen(arguments.sessId[lc.cname][lc.app]);
							for (lc.i = 1; lc.i Lte lc.sLen; lc.i++) {
								lc.sessId = arguments.sessId[lc.cname][lc.app][lc.i];
								if (StructKeyExists(lc.appSessions, lc.sessId)) {
									lc.info[lc.cname][lc.app][lc.sessId] = {
										exists = true
									};
								} else {
									lc.info[lc.cname][lc.app][lc.sessId] = {
										exists = false
									};
								}
							}
						}
					}
				}
			}
			return lc.info;
		</cfscript>
	</cffunction>

	<cffunction name="getInfoAdobe" access="private" output="false" returntype="struct">
		<cfargument name="sessId" type="any" required="false" />
		<cfargument name="aspects" type="string" required="false" default="" />
		<cfscript>
			var lc = {};
			lc.info = {};
			lc.info['Adobe'] = {};
			lc.len = Len(Trim(arguments.aspects));
			if (lc.len Eq 0) {
				arguments.aspects = ListAppend(variables.aspects, 'IdlePercent');
			}
			lc.itemLen = ListLen(arguments.aspects);

			if (Not StructKeyExists(arguments, 'sessId')) {
				arguments.sessId = variables.getSessionsAdobe();
			}
			for (lc.app in arguments.sessId.adobe) {
				lc.len = ArrayLen(arguments.sessId.adobe[lc.app]);
				for (lc.s = 1; lc.s Lte lc.len; lc.s++) {
					lc.sessId = arguments.sessId.adobe[lc.app][lc.s];
					lc.scope = variables.getScopeAdobe('Adobe', lc.app, lc.sessId);
					if (IsStruct(lc.scope)) {
						lc.info.adobe[lc.app][lc.sessId] = {};
						lc.info.adobe[lc.app][lc.sessId].exists = true;
						for (lc.i = 1; lc.i Lte lc.itemLen; lc.i++) {
							lc.item = ListGetat(arguments.aspects, lc.i);
							if (ListFindNoCase(variables.aspects, lc.item)) {
								lc.info.adobe[lc.app][lc.sessId][lc.item] = variables.methods[lc.item].invoke(lc.scope, variables.mirror);
							}
						}
						if (StructKeyExists(lc.info.adobe[lc.app][lc.sessId], 'idleTimeout')) {
							lc.info.adobe[lc.app][lc.sessId].idleTimeout = DateAdd('s', lc.info.adobe[lc.app][lc.sessId].idleTimeout, DateAdd('s', -variables.methods.lastAccessed.invoke(lc.scope, variables.mirror) / 1000, Now()));
						}
						if (StructKeyExists(lc.info.adobe[lc.app][lc.sessId], 'timeAlive')) {
							lc.info.adobe[lc.app][lc.sessId].timeAlive = DateAdd('s', -lc.info.adobe[lc.app][lc.sessId].timeAlive / 1000, now());
						}
						if (StructKeyExists(lc.info.adobe[lc.app][lc.sessId], 'lastAccessed')) {
							lc.info.adobe[lc.app][lc.sessId].lastAccessed = DateAdd('s', -lc.info.adobe[lc.app][lc.sessId].lastAccessed / 1000, now());
						}
						if (ListFindNoCase(arguments.aspects, 'idlePercent')) {
							if (variables.methods.expired.invoke(lc.scope, variables.mirror)) {
								lc.info.adobe[lc.app][lc.sessId].idlePercent = 100;
							} else {
								lc.info.adobe[lc.app][lc.sessId].idlePercent = variables.methods.lastAccessed.invoke(lc.scope, variables.mirror) / variables.methods.idleTimeout.invoke(lc.scope, variables.mirror) * 100;
							}
						}
						if (ListFindNoCase(arguments.aspects, 'clientIp') And Not StructKeyExists(lc.info.adobe[lc.app][lc.sessId], 'clientIp')) {
							lc.info.adobe[lc.app][lc.sessId].clientIp = '';
						}
					} else {
						lc.info.adobe[lc.app][lc.sessId].exists = false;
					}
				}
			}
			return lc.info;
		</cfscript>
	</cffunction>
	
	<cffunction name="getInfoByAppKeyAdobe" access="private" output="false" returntype="struct">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.info = {};
			lc.info['Adobe'] = {};
			arguments.aspects = ListAppend(variables.aspects, 'IdlePercent');
			lc.itemLen = ListLen(arguments.aspects);
			arguments.sessId = variables.getSessionsByAppKeyAdobe(arguments.name, arguments.value);
			for (lc.app in arguments.sessId.adobe) {
				lc.len = ArrayLen(arguments.sessId.adobe[lc.app]);
				for (lc.s = 1; lc.s Lte lc.len; lc.s++) {
					lc.sessId = arguments.sessId.adobe[lc.app][lc.s];
					lc.scope = variables.getScopeAdobe('Adobe', lc.app, lc.sessId);
					if (IsStruct(lc.scope)) {
						lc.info.adobe[lc.app][lc.sessId] = {};
						lc.info.adobe[lc.app][lc.sessId].exists = true;
						for (lc.i = 1; lc.i Lte lc.itemLen; lc.i++) {
							lc.item = ListGetat(arguments.aspects, lc.i);
							if (ListFindNoCase(variables.aspects, lc.item)) {
								lc.info.adobe[lc.app][lc.sessId][lc.item] = variables.methods[lc.item].invoke(lc.scope, variables.mirror);
							}
						}
						if (StructKeyExists(lc.info.adobe[lc.app][lc.sessId], 'idleTimeout')) {
							lc.info.adobe[lc.app][lc.sessId].idleTimeout = DateAdd('s', lc.info.adobe[lc.app][lc.sessId].idleTimeout, DateAdd('s', -variables.methods.lastAccessed.invoke(lc.scope, variables.mirror) / 1000, Now()));
						}
						if (StructKeyExists(lc.info.adobe[lc.app][lc.sessId], 'timeAlive')) {
							lc.info.adobe[lc.app][lc.sessId].timeAlive = DateAdd('s', -lc.info.adobe[lc.app][lc.sessId].timeAlive / 1000, now());
						}
						if (StructKeyExists(lc.info.adobe[lc.app][lc.sessId], 'lastAccessed')) {
							lc.info.adobe[lc.app][lc.sessId].lastAccessed = DateAdd('s', -lc.info.adobe[lc.app][lc.sessId].lastAccessed / 1000, now());
						}
						if (ListFindNoCase(arguments.aspects, 'idlePercent')) {
							if (variables.methods.expired.invoke(lc.scope, variables.mirror)) {
								lc.info.adobe[lc.app][lc.sessId].idlePercent = 100;
							} else {
								lc.info.adobe[lc.app][lc.sessId].idlePercent = variables.methods.lastAccessed.invoke(lc.scope, variables.mirror) / variables.methods.idleTimeout.invoke(lc.scope, variables.mirror) * 100;
							}
						}
						if (ListFindNoCase(arguments.aspects, 'clientIp') And Not StructKeyExists(lc.info.adobe[lc.app][lc.sessId], 'clientIp')) {
							lc.info.adobe[lc.app][lc.sessId].clientIp = '';
						}
					} else {
						lc.info.adobe[lc.app][lc.sessId].exists = false;
					}
				}
			}
			return lc.info;
		</cfscript>
	</cffunction>

	<cffunction name="getTimeAlive" access="public" output="false" returntype="struct">
		<cfargument name="sessId" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.sessId, 'timeAlive') />
	</cffunction>

	<cffunction name="getLastAccessed" access="public" output="false" returntype="struct">
		<cfargument name="sessId" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.sessId, 'lastAccessed') />
	</cffunction>

	<cffunction name="getIdleTimeout" access="public" output="false" returntype="struct">
		<cfargument name="sessId" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.sessId, 'idleTimeout') />
	</cffunction>
	
	<cffunction name="getExpired" access="public" output="false" returntype="struct">
		<cfargument name="sessId" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.sessId, 'expired') />
	</cffunction>

	<cffunction name="getIdlePercent" access="public" output="false" returntype="numeric">
		<cfargument name="sessId" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.sessId, 'IdlePercent') />
	</cffunction>

	<cffunction name="getClientIp" access="public" output="false" returntype="string">
		<cfargument name="sessId" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.sessId, 'clientIp') />
	</cffunction>

	<cffunction name="getIsNew" access="public" output="false" returntype="boolean">
		<cfargument name="sessId" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.sessId, 'isNew') />
	</cffunction>

	<cffunction name="getIsIdFromUrl" access="public" output="false" returntype="boolean">
		<cfargument name="sessId" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.sessId, 'IsIdFromUrl') />
	</cffunction>
	
	<cffunction name="getIsJ2eeSession" access="public" output="false" returntype="boolean">
		<cfargument name="sessId" required="true" type="string" />
		<cfreturn variables.getInfo(arguments.sessId, 'isJ2eeSession') />
	</cffunction>
</cfcomponent>