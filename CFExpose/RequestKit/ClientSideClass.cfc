<cfComponent
	Hint		= ""
	Description	= ""
	Output		= "no"
	Extends		= "CFExpose.ComponentExtension"
	accessors	= "yes"
>

	<cfProperty name="cfideMode" type="boolean" />
	<cfProperty name="MediaAddress" type="MediaAddress" />
	<cfScript>
		//multi-named references
		this.setMediaUrlAddress = setMediaAddress;
	</cfScript>

	<cfFunction
		name		= "isDebug"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.Debug = arguments.yesNo;

			if(!structKeyExists(variables, "Debug"))
				variables.Debug = 0;

			return variables.Debug;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setMediaAddress"
		returnType	= "ClientSideClass"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="urlAddress" required="yes" type="any" hint="string" />
		<cfScript>
			if(isSimpleValue(arguments.urlAddress))
				arguments.UrlAddress = getNewMediaAddress(arguments.urlAddress);

			variables.MediaAddress = arguments.UrlAddress;

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getNewMediaAddress"
		returnType	= "CFExpose.RequestKit.MediaAddress"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn new("Media",arguments) />
	</cfFunction>

	<cfFunction
		name		= "getMediaAddress"
		returnType	= "CFExpose.RequestKit.MediaAddress"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			if( !structKeyExists(variables, "MediaAddress") )
				variables.MediaAddress = getNewMediaAddress();

			return variables.MediaAddress;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setClientFileLoader"
		returnType	= "ClientSideClass"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="ClientFileLoader" required="yes" type="ClientFileLoader" hint="" />
		<cfset variables.ClientFileLoader = arguments.ClientFileLoader />
		<cfReturn this />
	</cfFunction>
<!---
	<cfFunction
		name		= "getClientFileLoader"
		returnType	= "any"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "returns the same instance after first call"
	>
		<cfScript>
			var local = {};

			if( !structKeyExists(variables, "ClientFileLoader") )
			{
				local.ClientFileLoader = new("ClientFileLoader");

				local.mediaUrlAddress = getMediaAddress();

				if(isCfideMode())
					local.CflMedia = getNewMediaAddress().appendRelativeFolderPath('ClientFileLoader/ClientFileLoader.js');
				else
					local.CflMedia = new("CFExpose.Media").appendRelativeFolderPath('ClientFileLoader/ClientFileLoader.js');

				if(!local.ClientFileLoader.isCflCoreFileUrlSet())
					local.ClientFileLoader.setClientFileLoaderJavascriptCoreFileUrl(local.CflMedia);

				local.ClientFileLoader.setUrlAddress(local.mediaUrlAddress);

				setClientFileLoader(local.ClientFileLoader);
			}

			return variables.ClientFileLoader;
		</cfScript>
	</cfFunction>
--->
	<cfFunction
		name		= "isCfideMode"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.cfideMode = arguments.yesNo;

			if(!structKeyExists(variables, "cfideMode"))
				variables.cfideMode = fileExists(getClientFileLoaderCfidePath());

			return variables.cfideMode;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getClientFileLoaderCfidePath"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn expandPath(getClientFileLoaderCfideUrl()) />
	</cfFunction>

	<cfFunction
		name		= "getClientFileLoaderCfideUrl"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn '/CFIDE/CFExpose/ClientFileLoader/ClientFileLoader.js' />
	</cfFunction>

	<cfFunction
		name		= "setClassName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= "used for jsClassNames and such to refer to this object on the client-side"
		description	= ""
	>
		<cfArgument name="ClassName" required="yes" type="string" hint="" />
		<cfScript>
			variables.ClassName = arguments.ClassName;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getClassName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= "used for jsClassNames and such to refer to this object on the client-side"
		description	= ""
	>
		<cfScript>
			if( NOT structKeyExists(variables, "ClassName") )
				variables.ClassName = listLast(getMetaData(this).name,'.') & '_' & replace(createUUID(), '-', '', 'all');

			return variables.ClassName;
		</cfScript>
	</cfFunction>

</cfComponent>