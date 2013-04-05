<cfComponent
	Hint		= "ColdFusion 9+ ONLY!"
	output		= "no"
	extends		= "ComponentExtension"
	accessors	= "yes"
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
		<cfScript>
			variables.Name = arguments.Name;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( structKeyExists(variables, "Name") )
				return variables.Name;

			return '';
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setExposeEntity"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="ExposeEntity" required="yes" type="ExposeEntity" hint="" />
		<cfScript>
			variables.ExposeEntity = arguments.ExposeEntity;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getExposeEntity"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( structKeyExists(variables, "ExposeEntity") )
				return variables.ExposeEntity;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getPropertyStruct"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return getExposeEntity().getPropertyByName(getName());
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isAllowNull"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.propertyStruct = getPropertyStruct();

			if(structKeyExists(local.propertyStruct, "notnull"))
				return !local.propertyStruct.notnull;

			return 1;
		</cfScript>
	</cfFunction>

</cfComponent>
