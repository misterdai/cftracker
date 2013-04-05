<cfComponent
	Hint		= ""
	output		= "no"
	extends		= "ExposeVariable"
>

	<cfFunction
		name		= "setVar"
		returnType	= "ExposeComponentVariable"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="var" required="yes" type="any" hint="" />
		<cfScript>
			structDelete(variables, "ExposeComponent");

			if(isObject(arguments.var))
				Return super.setVar(arguments.var);

			Return setComponentByName(arguments.var);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setComponent"
		returnType	= "ExposeComponentVariable"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "same thing as setVar"
	>
		<cfArgument name="var" required="yes" type="WEB-INF.cfTags.Component" hint="" />
		<cfReturn super.setVar(arguments.var) />
	</cfFunction>

	<cfFunction
		name		= "setComponentByName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfReturn super.setVar(createObject("component" , arguments.name)) />
	</cfFunction>

	<cfFunction
		name		= "ExposeComponent"
		returnType	= "ExposeComponent"
		access		= "private"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfif !structKeyExists(variables, "ExposeComponent") >
			<cfset variables.ExposeComponent = createObject("component", "ExposeComponent").init(getVar()) />
		</cfif>
		<cfReturn variables.ExposeComponent />
	</cfFunction>

</cfComponent>