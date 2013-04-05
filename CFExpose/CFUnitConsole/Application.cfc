<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
>

	<cfScript>
		this.path = getDirectoryFromPath(getCurrentTemplatePath());
		this.path = listDeleteAt(this.path,listlen(this.path,'/\'),'/\');
		this.mappings['/CFExpose'] = this.path;

		this.customTagPaths = this.path & 'CFExpose/CustomTags';
	</cfScript>
	<cfSetting enablecfoutputonly="no" requesttimeout="60" />
	<cfif cgi.HTTP_HOST neq '127.0.0.1' AND HTTP_HOST neq 'localhost' AND left(HTTP_HOST,8) NEQ '192.168.' >
		<cfThrow message="You are not authorized to access this url address" detail="Only authorized requests are from the localhost" />
	</cfif>

</cfComponent>
