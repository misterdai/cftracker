<cfcomponent extends="CFMLApplication" output="false">
	<cfscript>
		
	/* -------------------------- CONSTRUCTOR -------------------------- */
	
	ColdFusionApplication function init( required appname ){
		super.init( arguments.appname );
		// Application tracker
		variables.jAppTracker = CreateObject('java', 'coldfusion.runtime.ApplicationScopeTracker');
		// Session tracker
		variables.jSessTracker = CreateObject('java', 'coldfusion.runtime.SessionTracker');
		
		// Java Reflection for methods to avoid updating the last access date
		variables.mirror = [];
		variables.methods = {};
		variables.class = variables.mirror.getClass().forName('coldfusion.runtime.ApplicationScope');
		
		variables.methods.getApplicationSettings = class.getMethod('getApplicationSettings', variables.mirror);
		variables.methods.isInited = variables.class.getMethod('isInited', variables.mirror);
		variables.methods.timeAlive = variables.class.getMethod('getElapsedTime', variables.mirror);
		variables.methods.lastAccessed = variables.class.getMethod('getTimeSinceLastAccess', variables.mirror);
		variables.methods.idleTimeout = variables.class.getMethod('getMaxInactiveInterval', variables.mirror);
		variables.methods.expired = variables.class.getMethod('expired', variables.mirror);
		// keys supported by ColdFusion
		variables.aspects = 'isInited,timeAlive,lastAccessed,idleTimeout,expired';
		
		return this;
	}
	
	/* -------------------------- PUBLIC -------------------------- */
	
	struct function getInfo(aspects=''){
		var lc = {};
		lc.info = {};
		lc.len = Len(Trim(arguments.aspects));
		if (lc.len Eq 0) {
			arguments.aspects = ListAppend(variables.aspects, 'IdlePercent');
		}
		lc.itemLen = ListLen(arguments.aspects);
		lc.scope = getScope();
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
	}
	
	
	/**
	* returns the Application scope 
	**/
	struct function getScope(){
		// Make sure we get something back
		var result = variables.jAppTracker.getApplicationScope(variables.appname);
		if (Not IsDefined('result')) {
			return false;
		} else {
			return result;
		}
	}
	
	numeric function getSessionCount(){
		return StructCount(variables.jSessTracker.getSessionCollection(variables.appname));
	}
	
	numeric function getExpired(){
		return getInfo('expired').expired;
	} 

	numeric function getIdlePercent(){
		return getInfo('IdlePercent').IdlePercent;
	} 

	numeric function getIdleTimeout(){
		return getInfo('idleTimeout').idleTimeout;
	}

	date function getLastAccessed(){
		return getInfo('LastAccessed').LastAccessed;
	}
	
	/**
	* returns the Application settings 
	**/
	struct function getSettings(){
		var scope = getScope();
		var settings = {};
		var keys = [];
		var len = 0;
		var k = 0;
		var mirror = [];
		if (IsStruct(scope)) {
			settings = variables.methods.getApplicationSettings.invoke(scope, mirror);
			// Very odd issue with existing keys with null values.
			keys = StructKeyArray(settings);
			len = ArrayLen(keys);
			for (k = 1; k Lte len; k++) {
				if (Not StructKeyExists(settings, keys[k])) {
					StructDelete(settings, keys[k]);
				}
			}
		}
		return settings;
	}
	
	boolean function stop(){
		var lc = {};
		lc.scope = getScope();
		if (IsStruct(lc.scope)) {
			variables.jAppTracker.cleanUp(lc.scope);
			return true;
		} else {
			return false;
		}
	}
	
	boolean function touch(){ 
		var lc = {};
		lc.scope = variables.getScope();
		if (IsStruct(lc.scope)) {
			lc.scope.setLastAccess();
			return true;
		} else {
			return false;
		}
	}
	
	/**
	* returns an struct of session names for this application
	**/
	struct function getSessions(){
		return variables.jSessTracker.getSessionCollection(variables.appname);
	}
	
	</cfscript>
	
</cfcomponent>