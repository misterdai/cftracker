<cfcomponent output="false">
	<cfset variables.types = {
		'png' = 'image/png',
		'ico' = 'image/vnd.microsoft.icon',
		'css' = 'text/css',
		'js' = 'text/javascript',
		'gif' = 'image/gif',
		'swf' = 'application/x-shockwave-flash',
		'xml' = 'application/xml',
		'txt' = 'text/plain',
		'csv' = 'text/csv'
	} />
	<!---
		This application.cfc is designed for the Railo Admin plugin support.
		Without this, assets are processed by FW/1, which doesn't make any sense.
	--->
	<cffunction name="onRequestStart" output="false">
		<cfset var lc = {} />
		<cfset lc.asset = arguments[1] />
		<cfset lc.len = Len(lc.asset) />
		<cfset lc.asset = Mid(lc.asset, 1, lc.len - 4) />
		<cfset lc.type = ListLast(lc.asset, '.') />
		<cfif Not FileExists(arguments[1])>
			<cfif StructKeyExists(variables.types, lc.type)>
				<cfcontent file="#lc.asset#" type="#variables.types[lc.type]#" />
			<cfelse>
				<cfheader statuscode="404" statustext="Not Found" />
				<cfabort />
			</cfif>
		<cfelse>
			<cfif StructKeyExists(variables.types, lc.type)>
				<cfheader name="Content-type" value="#variables.types[lc.type]#" />
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>