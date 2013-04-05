<cfComponent
	Hint		= "Using the Url Address Component, this Component ties a server side path with the url. By default the server folder path will be the path of this component + a folder with the same last name as this component"
	Description	= "Example: if this component was located at c:\inetput\wwwroot\Media.cfc THEN a folder should reside here: c:\inetpub\wwwroot\Media\ AND the url defaults to be: /Media/ "
	Output		= "no"
	extends		= "UrlAddress"
	accessors	= "yes"
>

	<cfProperty name="baseHref"				type="string" />
	<cfProperty name="queryString"			type="string" />
	<cfProperty name="relativeScriptUrl"	type="string" />
	<cfProperty name="fileName"				type="string" />

	<cfFunction
		name		= "init"
		returnType	= "any"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			setUrlRelativeToComponent(this , listLast(getMetaData(this).name,'.'));
			return super.init(argumentCollection=arguments);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getUrl"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= "this method is a more natural name for the method 'getString' since this component supplies both a physical path and url path"
	>
		<cfReturn getString() />
	</cfFunction>

	<cfFunction
		name		= "getPath"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn getDirectoryFromPath(getMetaData(this).path) & listLast(getMetaData(this).name,'.') & '/' />
	</cfFunction>

	<cfFunction
		name		= "setUrlRelativeToComponent"
		returnType	= "MediaAddress"
		access		= "public"
		output		= "no"
		description	= "set the relative url by component instance"
		hint		= "gets metadata name of component and casts dot notation to forward slashes and then declares as the relative url of this UrlAddress instances"
	>
		<cfArgument name="Component"	required="yes"	type="WEB-INF.cftags.component" hint="" />
		<cfArgument name="subDirectory" required="no"	type="string"					hint="just a handy way to notate target is sub directory of component path" />
		<cfScript>
			local.name	= getMetaData(arguments.Component).name;
			local.url	= getDirectoryFromPath(reReplaceNoCase(local.name,'(\.|\\)','/','all'));

			if(structKeyExists(arguments , "subDirectory") AND len(arguments.subDirectory))
			{
				if(right(arguments.subDirectory,1) NEQ "/")
					arguments.subDirectory &= "/";

				local.url &= arguments.subDirectory;
			}


			/* auto relative url discovery */
				local.mappingUrl = Expose(getMetaData(Component).path,'directory').getUrlRelativeToCurrentRequest();

				if(len(local.mappingUrl))
					local.url = '#local.mappingUrl##listLast(local.name,'.')#/';
				else
					local.url = '/' & local.url;//added 9-11-12
			/* end */

			setRelativePath(local.url);

			Return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "Folder"
		returnType	= "MediaAddress"
		access		= "public"
		output		= "no"
		hint		= "returns new Media instance a lot like this one but one folder deeper"
		description	= ""
	>
		<cfArgument name="folderName" required="yes" type="string" hint="" />
		<cfReturn createObject("component", getMetaData(this).name).init(this.getString()).appendRelativeFolderPath(arguments.folderName) />
	</cfFunction>

</cfComponent>