<cfComponent
	Description	= "Base component in which to create a proxy between two connections"
	Hint		= "Entended to be extended by other components that will actually contain the invokation logic such as an httpProxy containing the proxy mechanics of http connections. This component just contains useful often used methods when creating a proxy"
	output		= "no"
	extends		= "CFExpose.RequestKit.ClientSideClass"
	accessors	= "yes"
>

	<cfProperty name="UrlAddress"	type="CFExpose.RequestKit.UrlAddress" />
	<cfProperty name="PassthruData"	type="ProxyPassthru" />
	<cfScript>
		variables.setup = structNew();
	</cfScript>

	<cfFunction
		name		= "init"
		returnType	= "Proxy"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="passthruCollection"	required="no"	type="struct" hint="each key in struct will be used as name value pair passthru" />
		<cfScript>
			if(structKeyExists(arguments, "passthruCollection") AND structCount(arguments.passthruCollection))
				Passthru().setPassthruCollection(arguments.passthruCollection);

			return super.init(argumentCollection=arguments);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setPassthruData"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="PassthruData" required="yes" type="ProxyPassthru" hint="" />
		<cfScript>
			variables.PassthruData = arguments.PassthruData;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getPassthruData"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( NOT structKeyExists(variables, "PassthruData") )
				variables.PassthruData = createObject("component" , "ProxyPassthru");

			return variables.PassthruData;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setUrl"
		returnType	= "Proxy"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="UrlAddress" required="yes" type="any" hint="" />
		<cfScript>
			if(isSimpleValue(arguments.UrlAddress))
				arguments.UrlAddress = new('CFExpose.RequestKit.UrlAddress').init(arguments.UrlAddress);

			setUrlAddress(arguments.UrlAddress);

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setUrlAddress"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="UrlAddress" required="yes" type="any" hint="" />
		<cfScript>
			if(isSimpleValue(arguments.UrlAddress))
				arguments.UrlAddress = new CFExpose.RequestKit.UrlAddress(arguments.UrlAddress);

			variables.UrlAddress = arguments.UrlAddress;

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getUrlAddress"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( structKeyExists(variables, "UrlAddress") )
				return variables.UrlAddress;
		</cfScript>
		<cfThrow message="UrlAddress Not Yet Set" detail="Use the method 'setUrlAddress' in component '#getMetaData(this).name#'" />
	</cfFunction>

	<cfFunction
		Name		= "setUrlAsComponentMethod"
		returnType	= "Proxy"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="Component"	required="yes"		type="any"			hint="" />
		<cfArgument name="method"		required="yes"		type="variableName"	hint="" />
		<cfScript>
			if(super.Expose(arguments.component,'component').isRemoteMethod(arguments.method))
			{
				structAppend(variables.setup , arguments);
				return this;
			}
		</cfScript>
		<cfThrow
			message	= "The access to method '#arguments.method#' is not remote in component #getMetaData(arguments.component).name#"
			detail	= "You cannot invoke 'setComponentMethod' in component '#getMetaData(this).name#' with a component method that cannot be accessed remotely"
		/>
	</cfFunction>

</cfComponent>