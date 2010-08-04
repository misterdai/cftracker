<cfcomponent output="false">
	<cfscript>
		this.name = 'CfTracker-Components';
		this.applicationTimeout = CreateTimeSpan(0, 1, 0, 0);
	</cfscript>
	
	<cffunction name="onApplicationStart" output="false">
		<cfset application.one = 1 />
		<cfset application.test = 'testing...' />
		<cfset application.st = StructNew() />
		<cfset application.st.array = ArrayNew(1) />
		<cfset application.st.boo = false />
	</cffunction>

	<cffunction name="onError">
		<cfdump var="#arguments#" />
		<cfabort>
	</cffunction>
</cfcomponent>