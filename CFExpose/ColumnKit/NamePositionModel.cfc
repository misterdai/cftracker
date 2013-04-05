<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	Extends		= "CFExpose.ComponentExtension"
>

	<cfProperty name="nameArray"	type="array" />
	<cfProperty name="elementArray"	type="array" />
	<cfScript>
		variables.nameArray		= arrayNew(1);
		variables.elementArray	= arrayNew(1);
	</cfScript>

	<cfFunction
		name		= "setByName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Element"	required="yes"	type="struct"		hint="" />
		<cfArgument name="name"		required="yes"	type="string"		hint="" />
		<cfArgument name="isAppend" required="no"	type="boolean"	default="yes"	hint="" />
		<cfScript>
			if(arguments.isAppend)
			{
				arrayAppend(variables.nameArray, arguments.name);
				arrayAppend(variables.elementArray, arguments.Element);
			}else
			{
				arrayPrepend(variables.nameArray, arguments.name);
				arrayPrepend(variables.elementArray, arguments.Element);
			}

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isNameDefined"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= "returns position in array or 0"
		description	= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfScript>
			var local = structNew();

			local.nameArray = getNameArray();

			for(local.x=arrayLen(local.nameArray); local.x GT 0; --local.x)
				if(local.nameArray[local.x] EQ arguments.name)
					return local.x;

			return 0;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return variables.elementArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getStruct"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.returnStruct = structNew();
			local.elementArray = getArray();
			local.nameArray = getNameArray();

			for(local.x=arrayLen(local.nameArray); local.x GT 0; local.x=local.x-1)
				local.returnStruct[local.nameArray[local.x]] = local.elementArray[local.x];

			return local.returnStruct;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getByName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= "may return void"
		description	= ""
	>
		<cfArgument name="name"				required="yes"	type="string"					hint="" />
		<cfArgument name="isErrorOnNull"	required="no"	type="boolean"	default="0"		hint="" />
		<cfScript>
			local.arrayPos = isNameDefined(arguments.name);

			if(local.arrayPos)
				return variables.elementArray[local.arrayPos];

			if(!arguments.isErrorOnNull)
				return;
		</cfScript>
		<cfThrow
			message	= "The named element '#arguments.name#' is not defined"
			detail	= "Use the method 'setByName' in component '#getMetaData(this).name#'. Available Names: #getNameList()#"
		/>
	</cfFunction>

	<cfFunction
		name		= "getNameList"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn arrayToList(getNameArray()) />
	</cfFunction>

	<cfFunction
		name		= "getNameArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= "names in the order in which they were set"
		description	= ""
	>
		<cfReturn variables.nameArray />
	</cfFunction>

</cfComponent>