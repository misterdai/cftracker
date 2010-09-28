    <cfcomponent extends="Application">
      <cfscript>
        variables.framework.applicationKey = 'CfTracker-20100927';
        //variables.framework.base = GetDirectoryFromPath(GetCurrentTemplatePath());
		variables.framework.base = '/railo_plugin_directory/CfTracker';
        request.appKey = variables.framework.applicationKey;
		request.railoPlugin = true;
      </cfscript>
	  

      <cffunction name="init" output="true">
		<cfset var lc = {} />
		<cfset lc.temp = Duplicate(application) />
		<cfset lc.path = GetDirectoryFromPath(GetCurrentTemplatePath()) />
		<cfset lc.mappings = {
			'/javaloader' = lc.path & 'libraries/javaloader',
			'/validatethis' = lc.path & 'libraries/validatethis'
		} />
		<cfapplication name="webadmin" action="create" mappings="#lc.mappings#">
        <cfscript>
			variables.onApplicationStart();
			return this;
        </cfscript>
      </cffunction>
    </cfcomponent>