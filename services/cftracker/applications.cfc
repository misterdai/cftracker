<cfcomponent output="false">
	<cfscript>
		variables.aspects = 'isInited,timeAlive,lastAccessed,idleTimeout,expired';
	</cfscript>

	<cffunction name="init" output="false" access="public">
		<cfscript>
			var lc = {};
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
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="getApps" access="public" output="false" returntype="array">
		<cfscript>
			var lc = {};
			lc.aApps = [];
			lc.oApps = variables.jAppTracker.getApplicationKeys();
			while (lc.oApps.hasMoreElements()) {
				ArrayAppend(lc.aApps, lc.oApps.nextElement());
			}
			return lc.aApps;
		</cfscript>
	</cffunction>
	
	<cffunction name="getScope" access="public" output="false">
		<cfargument name="appName" type="string" required="true" />
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
			lc.scope = variables.getScope(arguments.appName);
			lc.keys = [];
			if (IsStruct(lc.scope)) {
				lc.keys = StructKeyArray(lc.scope);
			}
			return lc.keys;
		</cfscript>
	</cffunction>

	<cffunction name="getScopeValues" access="public" output="false" returntype="any">
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="keys" type="array" required="false" />
		<cfscript>
			var lc = {};
			lc.values = {};
			lc.scope = variables.getScope(arguments.appName);
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

	<cffunction name="getSettings" access="public" output="false" returntype="any">
		<cfargument name="appName" required="true" type="string" />
		<cfscript>
			var lc = {};
			lc.scope = variables.getScope(arguments.appName);
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

	<cffunction name="stop" returntype="boolean" output="false" access="public">
		<cfargument name="appName" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.scope = variables.getScope(arguments.appName);
			if (IsStruct(lc.scope)) {
				variables.jAppTracker.cleanUp(lc.scope);
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>

	<cffunction name="restart" returntype="boolean" output="false" access="public">
		<cfargument name="appName" type="string" required="true" />
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
	
	<cffunction name="touch" access="public" output="false" returntype="boolean">
		<cfargument name="appName" required="true" type="string" />
		<cfscript>
			var lc = {};
			lc.scope = variables.getScope(arguments.appName);
			if (IsStruct(lc.scope)) {
				lc.scope.setLastAccess();
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
			var lc = {};
			lc.info = {};
			lc.len = Len(Trim(arguments.aspects));
			if (lc.len Eq 0) {
				arguments.aspects = ListAppend(variables.aspects, 'IdlePercent');
			}
			lc.itemLen = ListLen(arguments.aspects);
			lc.scope = variables.getScope(arguments.appName);
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
					if (ListFindNoCase(arguments.aspects, 'idlePercent')) {
						if (variables.methods.expired.invoke(lc.scope, variables.mirror)) {
							lc.info.idlePercent = 100;
						} else {
							lc.info.idlePercent = variables.methods.lastAccessed.invoke(lc.scope, variables.mirror) / variables.methods.idleTimeout.invoke(lc.scope, variables.mirror) * 100;
						}
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

	<cffunction name="getAppsInfo" access="public" output="false" returntype="struct">
		<cfscript>
			var lc = {};
			lc.info = {};
			lc.oApps = variables.jAppTracker.getApplicationKeys();
			while (lc.oApps.hasMoreElements()) {
				lc.appName = lc.oApps.nextElement();
				lc.scope = variables.getScope(lc.appName);
				if (IsStruct(lc.scope)) {
					lc.info[lc.appName] = {exists = true};
					lc.info[lc.appName].isInited = variables.methods.isInited.invoke(lc.scope, variables.mirror);
					lc.info[lc.appName].timeAlive = variables.methods.timeAlive.invoke(lc.scope, variables.mirror) / 1000;
					lc.info[lc.appName].lastAccessed = variables.methods.lastAccessed.invoke(lc.scope, variables.mirror) / 1000;
					lc.info[lc.appName].idleTimeout = variables.methods.idleTimeout.invoke(lc.scope, variables.mirror) / 1000;
					lc.info[lc.appName].expired = variables.methods.expired.invoke(lc.scope, variables.mirror);
					lc.info[lc.appName].lastAccessed = DateAdd('s', -lc.info[lc.appName].lastAccessed, now());
					lc.info[lc.appName].idleTimeout = DateAdd('s', lc.info[lc.appName].idleTimeout, lc.info[lc.appName].lastAccessed);
					lc.info[lc.appName].timeAlive = DateAdd('s', -lc.info[lc.appName].timeAlive, now());
					if (variables.methods.expired.invoke(lc.scope, variables.mirror)) {
						lc.info[lc.appName].idlePercent = 100;
					} else {
						lc.info[lc.appName].idlePercent = variables.methods.lastAccessed.invoke(lc.scope, variables.mirror) / variables.methods.idleTimeout.invoke(lc.scope, variables.mirror) * 100;
					}
					lc.info[lc.appName].sessionCount = StructCount(variables.jSessTracker.getSessionCollection(JavaCast('string', lc.appName)));
				} else {
					lc.info[lc.appName] = {exists = false};
				}
			}
			return lc.info;
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