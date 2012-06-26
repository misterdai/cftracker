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
		<cfif StructKeyExists(rc, 'data') And StructKeyExists(rc.data, 'uniformerrors')>
			<cfset rc.formdata = {
				uniformerrors = rc.data.uniformerrors,
				success = rc.data.success
			} />
		</cfif>
	</cffunction>

	<cffunction name="application" output="false">
		<cfargument name="rc" />
		<cfcookie name="cft_app" value="#arguments.rc.name#" />
		<cfcookie name="cft_wc" value="#arguments.rc.wc#" />
		<cfset variables.fw.service('applications.getinfo', 'appinfo', arguments.rc, true) />
		<cfset variables.fw.service('applications.getApps', 'apps', arguments.rc, true) />
	</cffunction>
	
	<cffunction name="endApplication" output="false">
		<cfargument name="rc" />
		<cfset var lc = {} />
		<cfif Not arguments.rc.appInfo.exists>
			<cfset StructDelete(cookie, 'cft_app') />
			<cfset StructDelete(cookie, 'cft_wc') />
			<cfset arguments.rc.message = {} />
			<cfset arguments.rc.message.bad = ['Application not found.'] />
			<cfset variables.fw.redirect('sessions.default', 'message') />
		</cfif>
	</cffunction>

	<cffunction name="getScope" output="false">
		<cfargument name="rc" />
	</cffunction>
	
	<cffunction name="stop" output="false">
		<cfargument name="rc" />
		<cfscript>
			var lc = {};
			arguments.rc.sessions = [];
			for (lc.key in arguments.rc) {
				if (ReFindNoCase('^sess_\d+$', lc.key)) {
					ArrayAppend(arguments.rc.sessions, arguments.rc[lc.key]);
				}
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="endstop" output="false">
		<cfargument name="rc" />
		<cfscript>
			var address = '';
			if (StructKeyExists(arguments.rc, 'name') And Len(arguments.rc.name) Gt 0) {
				address = "sessions.application?name=";
				address &= UrlEncodedFormat(arguments.rc.name);
				address &= '&wc=';
				address &= UrlEncodedFormat(arguments.rc.wc);
				variables.fw.redirect(address, 'data');
			} else {
				variables.fw.redirect('sessions.default', 'data');
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