<cfcomponent output="false">
	<cfscript>
		variables.aspects = 'timeAlive,lastAccessed,idleTimeout,expired,clientIp,idFromUrl,isNew,isJ2eeSession';
	</cfscript>

	<cffunction name="init" output="false" access="public">
		<cfscript>
			var local = {};
			// Java Reflection for methods to avoid updating the last access date
			variables.methods = {};
			variables.mirror = [];

			local.class = variables.mirror.getClass().forName('coldfusion.runtime.SessionScope');
			variables.methods.timeAlive = local.class.getMethod('getElapsedTime', variables.mirror);
			variables.methods.lastAccessed = local.class.getMethod('getTimeSinceLastAccess', variables.mirror);
			variables.methods.idleTimeout = local.class.getMethod('getMaxInactiveInterval', variables.mirror);
			variables.methods.expired = local.class.getMethod('expired', variables.mirror);
			variables.methods.clientIp = local.class.getMethod('getClientIp', variables.mirror);
			variables.methods.idFromUrl = local.class.getMethod('isIdFromURL', variables.mirror);
			variables.methods.isNew = local.class.getMethod('isNew', variables.mirror);
			variables.methods.isJ2eeSession = local.class.getMethod('IsJ2eeSession', variables.mirror);
			
			local.mirror = [];
			local.mirror[1] = CreateObject('java', 'java.lang.String').GetClass();
			variables.methods.getValue = local.class.getMethod('getValueWIthoutChange', local.mirror);
			
			// Session tracker
			variables.jSessTracker = CreateObject('java', 'coldfusion.runtime.SessionTracker');
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="getSessions" access="public" output="false" returntype="array">
		<cfargument name="appName" type="string" required="false" />
		<cfscript>
			var local = {};
			local.aSess = [];
			if (Not StructKeyExists(arguments, 'appName')) {
				local.oSess = variables.jSessTracker.getSessionKeys();
				while (local.oSess.hasMoreElements()) {
					ArrayAppend(local.aSess, local.oSess.nextElement());
				}
			} else {
				local.sessions = variables.jSessTracker.getSessionCollection(JavaCast('string', arguments.appName));
				local.aSess = StructKeyArray(local.sessions);
			}
			return local.aSess;
		</cfscript>
	</cffunction>
	
	<cffunction name="getCount" access="public" output="false" returntype="numeric">
		<cfargument name="appName" type="string" required="false" />
		<cfscript>
			var local = {};
			if (Not StructKeyExists(arguments, 'appName')) {
				return variables.jSessTracker.getSessionCount();
			} else {
				local.sessions = variables.jSessTracker.getSessionCollection(JavaCast('string', arguments.appName));
				return StructCount(local.sessions);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getScope" access="public" output="false">
		<cfargument name="sessId" type="string" required="true" />
		<cfscript>
			var local = {};
			// Make sure we get something back
			local.scope = variables.jSessTracker.getSession(JavaCast('string', arguments.sessId));
			if (Not IsDefined('local.scope')) {
				return false;
			} else {
				return local.scope;
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getScopeKeys" access="public" output="false" returntype="array">
		<cfargument name="sessId" type="string" required="true" />
		<cfscript>
			var local = {};
			local.scope = variables.getScope(arguments.sessId);
			local.keys = [];
			if (IsStruct(local.scope)) {
				local.keys = StructKeyArray(local.scope);
			}
			return local.keys;
		</cfscript>
	</cffunction>
	
	<cffunction name="getScopeValues" access="public" output="false" returntype="any">
		<cfargument name="sessId" type="string" required="true" />
		<cfargument name="keys" type="array" required="false" />
		<cfscript>
			var local = {};
			local.values = {};
			local.scope = variables.getScope(arguments.sessId);
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
	
	<cffunction name="stop" returntype="boolean" output="false" access="public">
		<cfargument name="sessId" type="string" required="true" />
		<cfscript>
			var local = {};
			local.scope = variables.getScope(arguments.sessId);
			if (IsStruct(local.scope)) {
				local.sid = ReReplace(arguments.sessId, '.*_([^_]+_[^_]+)$', '\1');
				local.appName = ReReplace(arguments.sessId, '(.*)_[^_]+_[^_]+$', '\1');
				variables.jSessTracker.cleanUp(local.appName, local.sid);
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="stopByApp" returntype="boolean" output="false" access="public">
		<cfargument name="appName" type="string" required="true" />
		<cfscript>
			var local = {};
			local.sessions = variables.jSessTracker.getSessionCollection(JavaCast('string', arguments.appName));
			local.aSess = StructKeyArray(local.sessions);
			local.len = ArrayLen(local.aSess);
			for (local.i = 1; local.i Lte local.len; local.i++) {
				local.sid = ReReplace(local.aSess[local.i], '.*_([^_]+_[^_]+)$', '\1');
				local.appName = ReReplace(local.aSess[local.i], '(.*)_[^_]+_[^_]+$', '\1');
				variables.jSessTracker.cleanUp(local.appName, local.sid);
			}
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="touch" access="public" output="false" returntype="boolean">
		<cfargument name="sessId" required="true" type="string" />
		<cfscript>
			var local = {};
			local.scope = variables.getScope(arguments.sessId);
			if (IsStruct(local.scope)) {
				local.scope.setLastAccess();
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
			var local = {};
			local.info = {};
			local.len = Len(Trim(arguments.aspects));
			if (local.len Eq 0) {
				arguments.aspects = ListAppend(variables.aspects, 'IdlePercent');
			}
			local.itemLen = ListLen(arguments.aspects);
			local.sessions = [];
			if (Not StructKeyExists(arguments, 'sessId')) {
				arguments.sessId = variables.getSessions();
			}
			if (IsSimpleValue(arguments.sessId)) {
				local.sessions = [arguments.sessId];
			} else if (IsArray(arguments.sessId)) {
				local.sessions = arguments.sessId; 
			}
			local.sessionCount = ArrayLen(local.sessions);
			for (local.s = 1; local.s Lte local.sessionCount; local.s++) {
				local.scope = variables.getScope(local.sessions[local.s]);
				if (IsStruct(local.scope)) {
					local.info[local.sessions[local.s]] = {};
					local.info[local.sessions[local.s]].exists = true;
					for (local.i = 1; local.i Lte local.itemLen; local.i++) {
						local.item = ListGetat(arguments.aspects, local.i);
						if (ListFindNoCase(variables.aspects, local.item)) {
							local.info[local.sessions[local.s]][local.item] = variables.methods[local.item].invoke(local.scope, variables.mirror);
						}
					}
					if (StructKeyExists(local.info[local.sessions[local.s]], 'idleTimeout')) {
						local.info[local.sessions[local.s]].idleTimeout = DateAdd('s', local.info[local.sessions[local.s]].idleTimeout * 1000, DateAdd('s', -variables.methods.lastAccessed.invoke(local.scope, variables.mirror), Now()));
					}
					if (StructKeyExists(local.info[local.sessions[local.s]], 'timeAlive')) {
						local.info[local.sessions[local.s]].timeAlive = DateAdd('s', -local.info[local.sessions[local.s]].timeAlive, now());
					}
					if (StructKeyExists(local.info[local.sessions[local.s]], 'lastAccessed')) {
						local.info[local.sessions[local.s]].lastAccessed = DateAdd('s', -local.info[local.sessions[local.s]].lastAccessed, now());
					}
					if (ListFindNoCase(arguments.aspects, 'idlePercent')) {
						if (variables.methods.expired.invoke(local.scope, variables.mirror)) {
							local.info[local.sessions[local.s]].idlePercent = 100;
						} else {
							local.info[local.sessions[local.s]].idlePercent = variables.methods.lastAccessed.invoke(local.scope, variables.mirror) / variables.methods.idleTimeout.invoke(local.scope, variables.mirror) * 100;
						}
					}
				} else {
					local.info[local.sessions[local.s]].exists = false;
				}
			}
			if (IsSimpleValue(arguments.sessId)) {
				return local.info[arguments.sessId];
			}
			return local.info;
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