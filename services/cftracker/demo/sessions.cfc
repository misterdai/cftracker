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
			} else if (StructKeyExists(application.demo.wc.adobe.sess, arguments.appName)) {
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
				return application.demo.wc.adobe.sess[arguments.appName][arguments.sessId].scope;
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
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="sessId" type="string" required="true" />
		<cfargument name="keys" type="array" required="false" />
		<cfscript>
			var lc = {};
			lc.values = {};
			lc.scope = variables.getScope(arguments.wc, arguments.appName, arguments.sessId);
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
						lc.values[arguments.keys[lc.i]] = lc.scope[arguments.keys[lc.i]];
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
			if (StructKeyExists(application.demo.wc.adobe.sess, arguments.appName)
				And StructKeyExists(application.demo.wc.adobe.sess[arguments.appName], arguments.sessId)) {
				StructDelete(application.demo.wc.adobe.sess[arguments.appName], arguments.sessId);
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
			if (StructKeyExists(application.demo.wc.adobe.sess, arguments.appName)) {
				for (lc.sessId in application.demo.wc.adobe.sess[arguments.appName]) {
					StructDelete(application.demo.wc.adobe.sess[arguments.appName], lc.sessId);
				}
			}
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="touch" access="public" output="false" returntype="boolean">
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfargument name="appName" type="string" required="false" default="" />
		<cfargument name="sessId" required="true" type="string" />
		<cfscript>
			//var lc = {};
			if (StructKeyExists(application.demo.wc.adobe.sess, arguments.appName)
				And StructKeyExists(application.demo.wc.adobe.sess[arguments.appName], arguments.sessId)) {
				application.demo.wc.adobe.sess[arguments.appName][arguments.sessId].metadata.lastAccessed = Now();
				//return true;
			} else {
				//return false;
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
			if (Not StructKeyExists(arguments, 'sessId')) {
				arguments.sessId = variables.getSessions();
			}
			for (lc.app in arguments.sessId.adobe) {
				lc.len = ArrayLen(arguments.sessId.adobe[lc.app]);
				for (lc.s = 1; lc.s Lte lc.len; lc.s++) {
					lc.sessId = arguments.sessId.adobe[lc.app][lc.s];
					if (StructKeyExists(application.demo.wc.adobe.sess, lc.app)
						And StructKeyExists(application.demo.wc.adobe.sess[lc.app], lc.sessId)) {
						lc.info.adobe[lc.app][lc.sessId] = Duplicate(application.demo.wc.adobe.sess[lc.app][lc.sessId].metadata);
						lc.info.adobe[lc.app][lc.sessId].exists = true;
						lc.info.adobe[lc.app][lc.sessId].idleTimeout = DateAdd('s', lc.info.adobe[lc.app][lc.sessId].idleTimeout * 86400, lc.info.adobe[lc.app][lc.sessId].lastAccessed);
						if (Now() Gt lc.info.adobe[lc.app][lc.sessId].idleTimeout) {
							lc.info.adobe[lc.app][lc.sessId].expired = true;
						} else {
							lc.info.adobe[lc.app][lc.sessId].expired = false;
						}
						if (lc.info.adobe[lc.app][lc.sessId].expired) {
							lc.info.adobe[lc.app][lc.sessId].idlePercent = 100;
						} else {
							lc.info.adobe[lc.app][lc.sessId].idlePercent = DateDiff('s', lc.info.adobe[lc.app][lc.sessId].lastAccessed, Now()) / DateDiff('s', lc.info.adobe[lc.app][lc.sessId].lastAccessed, lc.info.adobe[lc.app][lc.sessId].idleTimeout) * 100;
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