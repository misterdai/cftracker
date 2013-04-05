<cfComponent
	Hint		= "Using the Url Address Component, this Component ties a server side path with the url. By default the server folder path will be the path of this component + a folder with the same last name as this component"
	Description	= "Example: if this component was located at c:\inetput\wwwroot\Media.cfc THEN a folder should reside here: c:\inetpub\wwwroot\Media\ AND the url defaults to be: /Media/ "
	Output		= "no"
	extends		= "MediaAddress"
	accessors	= "yes"
>
	<!--- This file is just all about providing a more convenient name to the component MediaAddress --->
	<cfProperty name="baseHref"				type="string" />
	<cfProperty name="queryString"			type="string" />
	<cfProperty name="relativeScriptUrl"	type="string" />
	<cfProperty name="fileName"				type="string" />
	<cfProperty name="ClientFileLoader"		type="ClientFileLoader" />

	<cfFunction
		name		= "setClientFileLoader"
		returnType	= "Media"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="ClientFileLoader" required="yes" type="ClientFileLoader" hint="" />
		<cfset variables.ClientFileLoader = arguments.ClientFileLoader />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getClientFileLoader"
		returnType	= "ClientFileLoader"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "returns the same instance after first call"
	>
		<cfScript>
			var local = {};

			if( !structKeyExists(variables, "ClientFileLoader") )
			{
				local.ClientFileLoader = new('ClientFileLoader');
				local.ClientFileLoader.setUrlAddress(this);
				variables.ClientFileLoader = local.ClientFileLoader;
			}

			return variables.ClientFileLoader;
		</cfScript>
	</cfFunction>

</cfComponent>