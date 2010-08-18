<cfcomponent output="false">
	<cfscript>
		variables.settings = {};
		variables.settings.apps = {
			min = 1,
			max = 10,
			timeout = CreateTimeSpan(0, 2, 0, 0),
			createChance = 10
		};
		variables.settings.sess = {
			min = 1,
			max = 20,
			timeout = CreateTimeSpan(0, 0, 20, 0),
			createChance = 20,
			hitChance = 30
		};
	</cfscript>
	
	<cffunction name="init" output="false" access="public">
		<cfscript>
			StructDelete(application, 'demo');
			application.demo = {};
			// WC
			application.demo.wc = {};
			application.demo.wc['Adobe'] = {};
			// Apps + Sessions
			application.demo.wc.adobe = {};
			// Threads
			application.demo.threads = {};
		</cfscript>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="tick" output="false" access="public">
		<cfset var lc = {} />
		<cflock name="#application.applicationName#-demodata" type="exclusive" timeout="10">
			<cfscript>
				for (lc.app in application.demo.wc.adobe) {
					application.demo.wc.adobe[lc.app].metadata = 
				}
			</cfscript>
		</cflock>
		<cfscript>
			
			// Update apps and sessions
			for ()
		</cfscript>
	</cffunction>
	
	<cffunction name="newApplication" output="false" access="private">
		<cfscript>
			var lc = {};
			lc.applicationName = '';
			lc.scope = {};
			lc.scope['applicationname'] = lc.applicationName;
				appl
			};
			lc.settings = {
				applicationTimeout	= variables.settings.applications.timeout,
				clientManagement	= false,
				clientStorage		= 'Registry',
				loginStorage		= 'cookie',
				name				= lc.applicationName,
				onError				= variables.fakeFunction,
				scriptProtect		= '',
				sessionManagement	= true,
				sessionTimeout		= variables.settings.sessions.timeout,
				setClientCookies	= true,
				setDomainCookies	= false
			};
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="newSession" output="false" access="private">
		<cfargument name="appName" type="string" required="true" />
		
	</cffunction>
</cfcomponent>