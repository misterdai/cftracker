<cfcomponent output="false">
	<cfset variables.types = {
		'png' = 'image/png',
		'ico' = 'image/vnd.microsoft.icon',
		'css' = 'text/css',
		'js' = 'text/javascript',
		'gif' = 'image/gif',
		'swf' = 'application/x-shockwave-flash'
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
		<cfcontent file="#lc.asset#" type="#variables.types[lc.type]#" />
	</cffunction>
</cfcomponent>