<cfcomponent extends="CFMLApplication" output="false">
	<cfscript>
		
	/* -------------------------- CONSTRUCTOR -------------------------- */
	
	RailoApplication function init( required appname, webcontext, password ){
		super.init( arguments.appname );
		
		param name="variables.webcontext" default=server.coldfusion.rootdir; 
		param name="variables.password" default=""; 
		
		variables.jSessTracker = CreateObject("java", "coldfusion.runtime.SessionTracker");
		
		return this;
	}
	
	/* -------------------------- PUBLIC -------------------------- */
	
	struct function getInfo(){
		var lc = {};
		lc.info = {};
		lc.scope = getScope();
		if (IsStruct(lc.scope)) {
			lc.info.exists = true;
			lc.info.lastAccessed = lc.scope.getLastAccess();
			lc.info.idleTimeout = lc.scope.getTimeSpan();
			lc.info.expired = lc.scope.isExpired();
			lc.info.idleTimeout = DateAdd('s', lc.info.idleTimeout / 1000, DateAdd('s', -lc.scope.getLastAccess() / 1000, Now()));
			lc.info.lastAccessed = DateAdd('s', -lc.info.lastAccessed / 1000, now());
			if (lc.scope.isExpired()) {
				lc.info.idlePercent = 100;
			} else {
				lc.info.idlePercent = lc.scope.getLastAccess() / lc.scope.getTimeSpan() * 100;
			}
			lc.info.sessionCount = 0;
			lc.configs = getConfigWebs();
			lc.cLen = ArrayLen(lc.configs);
			for (lc.c = 1; lc.c Lte lc.cLen; lc.c++) {
				lc.wcId = lc.configs[lc.c].getServletContext().getRealPath('/');
				if (variables.webcontext Eq lc.wcId) {
					lc.scopeContext = lc.configs[lc.c].getFactory().getScopeContext();
					lc.appScopes = lc.scopeContext.getAllApplicationScopes();
					if (StructKeyExists(lc.appScopes, variables.appName)) {
						//if (server.railo.version Lt '3.1.2.002') {
						//	lc.info.sessionCount = StructCount(lc.scopeContext.getAllSessionScopes(getPageContext(), lc.app));
						//} else {
							//lc.info.sessionCount = StructCount(lc.scopeContext.getAllSessionScopes(lc.configs[lc.c], lc.app));
						//}
						return lc.configs[lc.c];
					}
				}
			}
		} 
		else {
			lc.info.exists = false;
		}
		return lc.info;
	}
	
	/**
	* returns the Application scope 
	**/
	struct function getScope(){
		var lc = {};
		lc.configs = getConfigWebs();
		lc.cLen = ArrayLen(lc.configs);
		for (lc.c = 1; lc.c Lte lc.cLen; lc.c++) {
			lc.wcId = lc.configs[lc.c].getServletContext().getRealPath('/');
			if (variables.webcontext Eq lc.wcId) {
				lc.appScopes = lc.configs[lc.c].getFactory().getScopeContext().getAllApplicationScopes();
				if (StructKeyExists(lc.appScopes, variables.appName)) {
					return lc.appScopes[variables.appName];
				}
			}
		}
		return false;
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
	
	/* -------------------------- PRIVATE -------------------------- */
	private array function getConfigWebs(){
		if ( variables.password != "" ){
			return getPageContext().getConfig().getConfigServer( variables.password ).getConfigWebs();	
		}
		else {
			return [ getPageContext().getConfig() ];	
		}
	}

	
	</cfscript>
	
</cfcomponent>