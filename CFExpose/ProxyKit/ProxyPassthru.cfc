<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	extends		= "CFExpose.ComponentExtension"
	accessors	= "yes"
>

	<cfProperty name="passthruCollection" type="struct" />
	<cfScript>
		variables.passthruCollection = structNew();

		/* Deprecated extra naming conventions */
			setNameValuePair = set;
			paramAppendNameValuePair = param;
		/* end */
	</cfScript>

	<cfFunction
		Name		= "set"
		returnType	= "ProxyPassthru"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="name"		required="yes"	type="variableName"	hint="" />
		<cfArgument name="value"	required="yes"	type="string"		hint="" />
		<cfset variables.passthruCollection[arguments.name] = arguments.value />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		Name		= "setPassthruCollection"
		returnType	= "ProxyPassthru"
		Access		= "public"
		Output		= "no"
		Hint		= "All arguments received are made static proxy passthru name value pairs"
	>
		<cfScript>
			if(left(structKeyList(arguments),1) eq "1")
				arguments = arguments[1];

			CFMethods().structDeleteNulls(arguments);//Fix ColdFusion bug that may pass NULL as undefined arguments;

			structAppend(variables.passthruCollection , arguments);

			Return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getPassthruCollection"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn variables.passthruCollection />
	</cfFunction>

	<cfFunction
		name		= "param"
		returnType	= "ProxyPassthru"
		access		= "public"
		output		= "no"
		description	= "if variable is not defined, then it will be. If it exists, then it will be treated as list"
		hint		= ""
	>
		<cfArgument name="name"			required="yes"	type="variableName"	hint="" />
		<cfArgument name="value"		required="yes"	type="string"		hint="" />
		<cfArgument name="delimiters"	required="no"	type="string"	default=","	 hint="" />
		<cfScript>
			if(structKeyExists(variables.passthruCollection, arguments.name))
				variables.passthruCollection = listAppend(variables.passthruCollection, arguments.value, arguments.delimiters);
			else
				variables.passthruCollection[arguments.name] = arguments.value;

			return this;
		</cfScript>
	</cfFunction>


</cfComponent>