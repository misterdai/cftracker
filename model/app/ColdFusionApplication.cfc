<cfcomponent extends="AbstractCFMLApplication" output="false">
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
		getInfo('expired').expired;
	} 

	numeric function getIdlePercent(){
		getInfo('expired').IdlePercent;
	} 

	numeric function getIdleTimeout(){
		getInfo('expired').idleTimeout;
	}
	
	struct function getScopeValues( array keys=[] ){
		var lc = {};
		lc.values = {};
		lc.scope = getScope();
		
		lc.mirror = [];
		lc.mirror[1] = CreateObject('java', 'java.lang.String').GetClass();
		lc.getValueWIthoutChange = variables.class.getMethod('getValueWIthoutChange', lc.mirror);
		
		// Make sure the scope exists
		if (IsStruct(lc.scope)) {
			// If no keys passed, return all keys
			if (ArrayLen(arguments.keys) Eq 0) {
				arguments.keys = StructKeyArray(lc.scope);
			}
			lc.length = ArrayLen(arguments.keys);
			// Retrieve keys if they exist
			lc.mirror = [];
			for (lc.i = 1; lc.i Lte lc.length; lc.i++) {
				if (StructKeyExists(lc.scope, arguments.keys[lc.i])) {
					lc.mirror[1] = JavaCast('string', arguments.keys[lc.i]);
					lc.values[arguments.keys[lc.i]] = lc.getValueWIthoutChange.invoke(lc.scope, lc.mirror);
				}
			}
		}
		return lc.values;
	}
	
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
	
	function touch(){ 
		var lc = {};
		lc.scope = variables.getScope();
		if (IsStruct(lc.scope)) {
			lc.scope.setLastAccess();
			return true;
		} else {
			return false;
		}
	}
	</cfscript>
</cfcomponent>