<cfComponent
	Hint		= "Using the Url Address Component, this Component ties a server side path with the url. By default the server folder path will be the path of this component + a folder with the same last name as this component"
	Description	= "Example: if this component was located at c:\inetput\wwwroot\Media.cfc THEN a folder should reside here: c:\inetpub\wwwroot\Media\ AND the url defaults to be: /Media/ "
	Output		= "no"
	extends		= "CFExpose.RequestKit.Media"
	accessors	= "yes"
>
	<cfProperty name="baseHref"				type="string" />
	<cfProperty name="queryString"			type="string" />
	<cfProperty name="relativeScriptUrl"	type="string" />
	<cfProperty name="fileName"				type="string" />
</cfComponent>