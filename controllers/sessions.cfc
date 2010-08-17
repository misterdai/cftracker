<cfcomponent output="false">
	<cffunction name="init" output="false">
		<cfargument name="fw" />
		<cfset variables.fw = arguments.fw />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="default" output="false"> 
		<cfargument name="rc" />
		<cfif StructKeyExists(arguments.rc, 'all')>
			<cfset StructDelete(cookie, 'cft_app') />
			<cfset StructDelete(cookie, 'cft_wc') />
		<cfelse>
			<cfif StructKeyExists(cookie, 'cft_app') And StructKeyExists(cookie, 'cft_wc')>
				<cfset variables.fw.redirect('sessions.application?name=' & UrlEncodedFormat(cookie.cft_app) & '&wc=' & UrlEncodedFormat(cookie.cft_wc)) />
			</cfif>
		</cfif>
	
		<cfset variables.fw.service('applications.getApps', 'apps', arguments.rc, true) />
	</cffunction>

	<cffunction name="application" output="false">
		<cfargument name="rc" />
		<cfcookie name="cft_app" value="#rc.name#" />
		<cfcookie name="cft_wc" value="#rc.wc#" />
		<cfset variables.fw.service('applications.getinfo', 'appinfo', arguments.rc, true) />
		<cfset variables.fw.service('applications.getApps', 'apps', arguments.rc, true) />
	</cffunction>

	<cffunction name="getScope" output="false">
		<cfargument name="rc" />
	</cffunction>
	
	<cffunction name="stop" output="false">
		<cfargument name="rc" />
		<cfscript>
			var lc = {};
			rc.sessions = [];
			for (lc.key in arguments.rc) {
				if (ReFindNoCase('^sess_\d+$', lc.key)) {
					ArrayAppend(rc.sessions, arguments.rc[lc.key]);
				}
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="endstop" output="false">
		<cfargument name="rc" />
		<cfscript>
			if (StructKeyExists(rc, 'name') And Len(rc.name) Gt 0) {
				variables.fw.redirect('sessions.application?name=' & UrlEncodedFormat(arguments.rc.name) & '&wc=' & UrlEncodedFormat(arguments.rc.wc));
			} else {
				variables.fw.redirect('sessions.default');
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="refresh" output="false">
		<cfargument name="rc" />
		<cfset variables.stop(arguments.rc) />
	</cffunction>
	
	<cffunction name="endrefresh" output="false">
		<cfargument name="rc" />
		<cfset variables.endstop(arguments.rc) />
	</cffunction>

	<cffunction name="endStopBy" output="false">
		<cfargument name="rc" />
		<cfset variables.endstop(arguments.rc) />
	</cffunction>

	<cffunction name="endRefreshBy" output="false">
		<cfargument name="rc" />
		<cfset variables.endstop(arguments.rc) />
	</cffunction>
</cfcomponent>