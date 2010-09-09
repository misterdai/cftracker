<cfcomponent output="false">
	<cffunction name="configure" output="false">
		<cfscript>
			variables.logbox = {};
			variables.logbox.appenders = {};
			variables.logbox.appenders['monitor'] = {
				class = 'logbox.system.logging.appenders.AsyncRollingFileAppender'
			};
			variables.logbox.appenders.monitor.properties = {
				filePath = application.base & '../logs',
				autoExpand = false,
				fileMaxArchives = 1,
				fileMaxSize = 3
			};
			variables.logbox['root'] = {
				levelMin = 'FATAL',
				levelMax = 'INFO',
				appenders = '*'
			};
			variables.logbox.categories = {};
			variables.logbox.categories['Task'] = {
				levelMin = 'FATAL',
				levelMax = 'INFO',
				appenders = 'monitor'
			};
			variables.logbox.categories['Data'] = {
				levelMin = 'INFO',
				levelMax = 'INFO',
				appenders = 'monitor'
			};
		</cfscript>
	</cffunction>
</cfcomponent>