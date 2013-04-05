<cfComponent
	Hint		= ""
	Description	= ""
	Output		= "no"
	Extends		= "ClientSideClass"
	accessors	= "yes"
>

	<cfProperty name="debug"						type="boolean" />
	<cfProperty name="jsClassName"					type="string" />
	<cfProperty name="RemoteProcessorUrlAddress"	type="any" />

	<cfFunction
		name		= "getNewMediaAddress"
		returnType	= "CFExpose.RequestKit.MediaAddress"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfif isCfideMode() >
			<cfReturn new("CFExpose.Media").init('/CFIDE/CFExpose/') />
		<cfElse>
			<cfReturn new("CFExpose.Media", arguments) />
		</cfif>
	</cfFunction>

	<cfFunction
		name		= "setMediaUrlAddress"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="urlAddress" required="yes" type="string" hint="" />
		<cfScript>
			getClientFileLoader()
			.setClientFileLoaderJavascriptCoreFileUrl(arguments.urlAddress&'ClientFileLoader/')
			.setUrlAddress(arguments.urlAddress);
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isDebug"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.debug = arguments.yesNo;

			if(!structKeyExists(variables, "debug"))
				variables.debug = 0;

			return variables.debug;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getJsClassName"
		returnType	= "variableName"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "returns same name every time"
	>
		<cfReturn super.getClassName() />
	</cfFunction>

	<!--- URL Methods --->
		<cfFunction
			name		= "setRemoteProcessorUrlAddress"
			returnType	= "any"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="RemoteProcessorUrlAddress" required="yes" type="string" hint="" />
			<cfScript>
				variables.RemoteProcessorUrlAddress = new('CFExpose.RequestKit.UrlAddress');
				variables.RemoteProcessorUrlAddress.setBaseHref(arguments.RemoteProcessorUrlAddress);

				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getRemoteProcessorUrlAddress"
			returnType	= "CFExpose.RequestKit.UrlAddress"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfif NOT structKeyExists(variables, "RemoteProcessorUrlAddress")>
				<cfset variables.RemoteProcessorUrlAddress = new('CFExpose.RequestKit.UrlAddress') />
				<cfset variables.RemoteProcessorUrlAddress.setFileName('RemoteProcessor.cfc?method=jsonToDumpObject') />
			</cfif>
			<cfReturn variables.RemoteProcessorUrlAddress />
		</cfFunction>
	<!--- END : URL METHODS --->

</cfComponent>