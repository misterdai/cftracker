<cfcomponent output="false">
	<cfscript>
		variables.aspects = 'timeAlive,lastAccessed,idleTimeout,expired,clientIp,idFromUrl,isNew,isJ2eeSession';
	</cfscript>

	<cffunction name="init" output="false" access="public">
		<cfscript>
			var lc = {};
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
			
			// Session tracker
			variables.jSessTracker = CreateObject('java', 'coldfusion.runtime.SessionTracker');
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="getSessions" access="public" output="false" returntype="array">
		<cfargument name="appName" type="string" required="false" />
		<cfscript>
			var lc = {};
			lc.aSess = [];
			if (Not StructKeyExists(arguments, 'appName')) {
				lc.oSess = variables.jSessTracker.getSessionKeys();
				while (lc.oSess.hasMoreElements()) {
					ArrayAppend(lc.aSess, lc.oSess.nextElement());
				}
			} else {
				lc.sessions = variables.jSessTracker.getSessionCollection(JavaCast('string', arguments.appName));
				lc.aSess = StructKeyArray(lc.sessions);
			}
			return lc.aSess;
		</cfscript>
	</cffunction>
	
	<cffunction name="getCount" access="public" output="false" returntype="numeric">
		<cfargument name="appName" type="string" required="false" />
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
	
	<cffunction name="getScope" access="public" output="false">
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
		<cfargument name="sessId" type="string" required="true" />
		<cfscript>
			var lc = {};
			lc.scope = variables.getScope(arguments.sessId);
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
		<cfargument name="sessId" required="true" type="string" />
		<cfscript>
			var lc = {};
			lc.scope = variables.getScope(arguments.sessId);
			if (IsStruct(lc.scope)) {
				lc.scope.setLastAccess();
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>

	<cffunction name="getInfo" access="public" output="false" returntype="struct">
		<cfargument name="sessId" type="any" required="false" />
		<cfargument name="aspects" type="string" required="false" default="" />
		<cfscript>
			var lc = {};
			lc.info = {};
			lc.len = Len(Trim(arguments.aspects));
			if (lc.len Eq 0) {
				arguments.aspects = ListAppend(variables.aspects, 'IdlePercent');
			}
			lc.itemLen = ListLen(arguments.aspects);
			lc.sessions = [];
			if (Not StructKeyExists(arguments, 'sessId')) {
				arguments.sessId = variables.getSessions();
			}
			if (IsSimpleValue(arguments.sessId)) {
				lc.sessions = [arguments.sessId];
			} else if (IsArray(arguments.sessId)) {
				lc.sessions = arguments.sessId; 
			}
			lc.sessionCount = ArrayLen(lc.sessions);
			for (lc.s = 1; lc.s Lte lc.sessionCount; lc.s++) {
				lc.scope = variables.getScope(lc.sessions[lc.s]);
				if (IsStruct(lc.scope)) {
					lc.info[lc.sessions[lc.s]] = {};
					lc.info[lc.sessions[lc.s]].exists = true;
					for (lc.i = 1; lc.i Lte lc.itemLen; lc.i++) {
						lc.item = ListGetat(arguments.aspects, lc.i);
						if (ListFindNoCase(variables.aspects, lc.item)) {
							lc.info[lc.sessions[lc.s]][lc.item] = variables.methods[lc.item].invoke(lc.scope, variables.mirror);
						}
					}
					if (StructKeyExists(lc.info[lc.sessions[lc.s]], 'idleTimeout')) {
						lc.info[lc.sessions[lc.s]].idleTimeout = DateAdd('s', lc.info[lc.sessions[lc.s]].idleTimeout * 1000, DateAdd('s', -variables.methods.lastAccessed.invoke(lc.scope, variables.mirror), Now()));
					}
					if (StructKeyExists(lc.info[lc.sessions[lc.s]], 'timeAlive')) {
						lc.info[lc.sessions[lc.s]].timeAlive = DateAdd('s', -lc.info[lc.sessions[lc.s]].timeAlive, now());
					}
					if (StructKeyExists(lc.info[lc.sessions[lc.s]], 'lastAccessed')) {
						lc.info[lc.sessions[lc.s]].lastAccessed = DateAdd('s', -lc.info[lc.sessions[lc.s]].lastAccessed, now());
					}
					if (ListFindNoCase(arguments.aspects, 'idlePercent')) {
						if (variables.methods.expired.invoke(lc.scope, variables.mirror)) {
							lc.info[lc.sessions[lc.s]].idlePercent = 100;
						} else {
							lc.info[lc.sessions[lc.s]].idlePercent = variables.methods.lastAccessed.invoke(lc.scope, variables.mirror) / variables.methods.idleTimeout.invoke(lc.scope, variables.mirror) * 100;
						}
					}
					if (ListFindNoCase(arguments.aspects, 'clientIp') And Not StructKeyExists(lc.info[lc.sessions[lc.s]], 'clientIp')) {
						lc.info[lc.sessions[lc.s]].clientIp = '';
					}
				} else {
					lc.info[lc.sessions[lc.s]].exists = false;
				}
			}
			if (IsSimpleValue(arguments.sessId)) {
				return lc.info[arguments.sessId];
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