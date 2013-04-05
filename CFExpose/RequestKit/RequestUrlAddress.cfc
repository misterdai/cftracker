<cfComponent
	Hint		= "Just a helpful component extension. Useless by itself but powerful to components doing javascript client output"
	Output		= "no"
	Extends		= "UrlAddress"
	accessors	= "yes"
>

	<cfProperty name="baseHref"				type="string" />
	<cfProperty name="queryString"			type="string" />
	<cfProperty name="relativeScriptUrl"	type="string" />
	<cfProperty name="fileName"				type="string" />

	<cfset init('http://' & cgi.HTTP_HOST & cgi.script_name & '?' & cgi.query_string) />

</cfComponent>