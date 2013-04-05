<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	extends		= "CFExpose.ComponentExtension"
	accessors	= "true"
>

	<cfProperty name="name" type="string" />

	<cfFunction
		name		= "setName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Name" required="yes" type="string" hint="" />
		<cfset variables.Name = arguments.Name />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfif structKeyExists(variables, "Name")>
			<cfReturn variables.Name />
		</cfif>
		<cfThrow message="Name Not Yet Set" detail="Use the method 'setName' in component '#getMetaData(this).name#'" />
	</cfFunction>

</cfComponent>