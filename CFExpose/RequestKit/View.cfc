<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	Extends		= "CFExpose.ComponentExtension"
	accessors	= "yes"
>

	<cfProperty name="SubmitUrlAddress"		type="CFExpose.RequestKit.UrlAddress" />

	<cfFunction
		name		= "getOutput"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfThrow
			message	= "No getOutput Method Override Provided"
			detail	= "The component '#getMetaData(this).name#' does not contain the method 'getOutput'"
		/>
	</cfFunction>

	<cfFunction
		name		= "setSubmitUrlAddress"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="SubmitUrlAddress" required="yes" type="any" hint="" />
		<cfScript>
			if(isSimpleValue(arguments.SubmitUrlAddress))
				arguments.SubmitUrlAddress = new CFExpose.RequestKit.UrlAddress(arguments.SubmitUrlAddress);

			variables.SubmitUrlAddress = arguments.SubmitUrlAddress;

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getSubmitUrlAddress"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( structKeyExists(variables, "SubmitUrlAddress") )
				return variables.SubmitUrlAddress;
		</cfScript>
		<cfThrow message="SubmitUrlAddress Not Yet Set" detail="Use the method 'setSubmitUrlAddress' in component '#getMetaData(this).name#'" />
	</cfFunction>

</cfComponent>