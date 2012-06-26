<cfcomponent extends="Application">
	<cfscript>
		variables.framework.applicationKey = 'CfTracker-20100927';
		variables.framework.base = '/railo_plugin_directory/CfTracker/';
		request.appKey = variables.framework.applicationKey;

		this.base = variables.framework.base;
		this.railoPlugin = true;
		this.assetBegin = 'plugin/CfTracker/';
		this.assetEnd = '.cfm';
	</cfscript>

	<cffunction name="init" output="false">
		<cfscript>
			variables.configApplication();
			variables.onApplicationStart();
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="configApplication" output="false">
		<cfset var lc = {} />
		<cfset lc.path = GetDirectoryFromPath(GetCurrentTemplatePath()) />
		<cfset lc.mappings = {
			'/railo_plugin_directory' = lc.path & '../',
			'/javaloader' = lc.path & 'libraries/javaloader',
			'/validatethis' = lc.path & 'libraries/validatethis'
		} />
		<cfapplication name="webadmin" action="update" mappings="#lc.mappings#" customtagpaths="#lc.path#libraries/tags/forms/cfUniForm" />
	</cffunction>
	
	<cffunction name="BuildUrl" output="false">
		<cfargument name="action" type="string" />
		<cfargument name="path" type="string" default="#variables.framework.baseURL#" />
		<cfargument name="queryString" type="string" default="" />
		<cfset var lc = {} />
		<cfset lc.url = super.buildUrl(arguments.action, arguments.path, arguments.queryString) />
		<cfset lc.url = ReReplace(lc.url, '(web|server)(\.cfm\?action=)(.*)$', '\1\2plugin&plugin=CfTracker&fw1action=\3') />
		<cfreturn lc.url />
	</cffunction>
	
</cfcomponent>