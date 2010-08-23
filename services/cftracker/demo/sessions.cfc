<cfcomponent output="false">
	<cffunction name="init" output="false" access="public">
		<cfreturn this />
	</cffunction>

	<cffunction name="getSessions" access="public" output="false" returntype="struct">
		<cfargument name="appName" type="string" required="false" />
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfscript>
			var lc = {};
			lc.stSess = {};
			lc.stSess['Adobe'] = {};
			if (Not StructKeyExists(arguments, 'appName')) {
				for (lc.app in application.demo.wc.adobe.sess) {
					lc.stSess.adobe[lc.app] = StructKeyArray(application.demo.wc.adobe.sess[lc.app]);
				}
			} else {
				lc.stSess.adobe[arguments.appName] = StructKeyArray(application.demo.wc.adobe.sess[arguments.appName]);
			}
			return lc.stSess;
		</cfscript>
	</cffunction>
	
	<cffunction name="getCount" access="public" output="false" returntype="numeric">
		<cfargument name="appName" type="string" required="false" />
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfscript>
			var lc = {};
			if (Not StructKeyExists(arguments, 'appName')) {
				lc.total = 0;
				for (lc.app in application.demo.wc.adobe.sess) {
					lc.total += StructCount(application.demo.wc.adobe.sess[lc.app]);
				}
			} else {
				lc.total = StructCount(application.demo.wc.adobe.sess[arguments.appName]);
			}
			return lc.total;
		</cfscript>
	</cffunction>
	
	<cffunction name="getScope" access="public" output="false">
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfargument name="appName" type="string" required="false" />
		<cfargument name="sessId" type="string" required="true" />
		<cfscript>
			var lc = {};
			// Make sure we get something back
			if (StructKeyExists(application.demo.wc.adobe.sess, arguments.appName) And StructKeyExists(application.demo.wc.adobe.sess[arguments.appName], arguments.sessId)) {
				return application.demo.wc.adobe.sess[arguments.appName][arguments.sessId];
			} else {
				return false;
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
						for (lc.app in application.demo.wc.adobe.sess) {
							if (StructKeyExists(application.demo.wc.adobe.sess[lc.app], arguments.sessId)) {
								lc.values[arguments.keys[lc.i]] = application.demo.wc.adobe.sess[arguments
							}
						}
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

	<cffunction name="getInfo" access="public" output="false" returntype="struct">
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
							lc.info.adobe[lc.app][lc.sessId].idleTimeout = DateAdd('s', lc.info.adobe[lc.app][lc.sessId].idleTimeout, DateAdd('l', -variables.methods.lastAccessed.invoke(lc.scope, variables.mirror), Now()));
						}
						if (StructKeyExists(lc.info.adobe[lc.app][lc.sessId], 'timeAlive')) {
							lc.info.adobe[lc.app][lc.sessId].timeAlive = DateAdd('l', -lc.info.adobe[lc.app][lc.sessId].timeAlive, now());
						}
						if (StructKeyExists(lc.info.adobe[lc.app][lc.sessId], 'lastAccessed')) {
							lc.info.adobe[lc.app][lc.sessId].lastAccessed = DateAdd('l', -lc.info.adobe[lc.app][lc.sessId].lastAccessed, now());
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