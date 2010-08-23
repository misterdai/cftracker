<cfcomponent output="false">
	<cffunction name="init" output="false" access="public">
		<cfscript>
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="getApps" access="public" output="false" returntype="struct">
		<cfscript>
			var lc = {};
			lc.stApps = {};
			lc.stApps['Adobe'] = StructKeyArray(application.demo.wc.adobe.apps);
			return lc.stApps;
		</cfscript>
	</cffunction>
	
	<cffunction name="getScope" access="public" output="false">
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfscript>
			var lc = {};
			if (StructKeyExists(application.demo.wc.adobe.apps, arguments.appName)) {
				return application.demo.wc.adobe.apps[arguments.appName].scope;
			} else {
				return false;
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
				for (lc.i = 1; lc.i Lte lc.length; lc.i++) {
					if (StructKeyExists(lc.scope, arguments.keys[lc.i])) {
						lc.values[arguments.keys[lc.i]] = lc.scope[arguments.keys[lc.i]];
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
			lc.settings = {};
			if (StructKeyExists(application.demo.wc.adobe.apps, arguments.appName)) {
				lc.settings = application.demo.wc.adobe.apps[arguments.appName].settings;
			}
			return lc.settings;
		</cfscript>
	</cffunction>

	<cffunction name="stop" returntype="boolean" output="false" access="public">
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfscript>
			var lc = {};
			if (StructKeyExists(application.demo.wc.adobe.apps, arguments.appName)) {
				StructDelete(application.demo.wc.adobe.apps, arguments.appName);
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>

	<cffunction name="restart" returntype="boolean" output="false" access="public">
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfscript>
			var lc = {};
			if (StructKeyExists(application.demo.wc.adobe.apps, arguments.appName)) {
				application.demo.wc.adobe.apps[arguments.appName].metadata.isInited = false;
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="touch" access="public" output="false" returntype="boolean">
		<cfargument name="appName" required="true" type="string" />
		<cfargument name="wc" type="string" required="false" default="Adobe" />
		<cfscript>
			var lc = {};
			if (StructKeyExists(application.demo.wc.adobe.apps, arguments.appName)) {
				application.demo.wc.adobe.apps[arguments.appName].metadata.lastAccessed = Now();
				return true;
			} else {
				return false;
			}
		</cfscript>
	</cffunction>

	<cffunction name="getInfo" access="public" output="false" returntype="struct">
		<cfargument name="appName" type="string" required="true" />
		<cfargument name="wc" type="string" required="true" />
		<cfargument name="aspects" type="string" required="false" default="" />
		<cfscript>
			var lc = {};
			lc.info = {};
			if (StructKeyExists(application.demo.wc.adobe.apps, arguments.appName)) {
				lc.info = Duplicate(application.demo.wc.adobe.apps[arguments.appName].metadata);
				lc.info.exists = true;
				lc.info.idleTimeout = DateAdd('s', lc.info.idleTimeout * 86400, lc.info.lastAccessed);
				if (Now() Gt lc.info.idleTimeout) {
					lc.info.expired = true;
				} else {
					lc.info.expired = false;
				}
				if (lc.info.expired) {
					lc.info.idlePercent = 100;
				} else {
					lc.info.idlePercent = DateDiff('s', lc.info.lastAccessed, Now()) / DateDiff('s', lc.info.lastAccessed, lc.info.idleTimeout) * 100;
				}
				lc.info.sessionCount = StructCount(application.demo.wc.adobe.apps[arguments.appName]);
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
			lc.info['Adobe'] = {};
			lc.apps = variables.getApps();
			for (lc.wc in lc.apps) {
				lc.len = ArrayLen(lc.apps[lc.wc]);
				for (lc.i = 1; lc.i Lte lc.len; lc.i++) {
					lc.appName = lc.apps[lc.wc][lc.i];
					lc.scope = variables.getScope(lc.appName);
					lc.info.adobe[lc.appName] = variables.getInfo(lc.appName, 'adobe');
				}
			}
			return lc.info;
		</cfscript>
	</cffunction>
</cfcomponent>