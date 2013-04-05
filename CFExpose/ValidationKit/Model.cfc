<cfComponent
	Hint		= "middle man component between HTML element output and sets of validations"
	description	= "contains both html based & server-side validation methods (getRequiredIndicator)"
	output		= "no"
	extends		= "CFExpose.ComponentExtension"
	accessors	= "yes"
>

	<cfProperty name="valArray" type="array" />
	<cfScript>
		variables.valArray = arrayNew(1);
	</cfScript>

	<cfFunction
		name		= "setValue"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Value" required="yes" type="string" hint="" />
		<cfset variables.Value = arguments.Value />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getValue"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfif NOT structKeyExists(variables, "Value")>
			<cfReturn '' />
		</cfif>
		<cfReturn variables.Value />
	</cfFunction>

	<cfFunction
		name		= "getNewValidation"
		returnType	= "Validation"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn createObject("component", "Validation").init(argumentCollection=arguments) />
	</cfFunction>

	<cfFunction
		name		= "Validation"
		access		= "public"
		output		= "no"
		returnType	= "Validation"
		description	= "their is no setValidation method in this component. They are created here"
	>
		<cfArgument name="required"			required="no"	type="boolean"		default="yes" />
		<cfArgument name="pattern"			required="no"	type="string"			hint="" />
		<cfArgument name="type"				required="no"	type="variableName" 	hint="phone,firstNameLastName,variableName,email" />
		<cfArgument name="onInvalid"		required="no"	type="variableName"		hint="" />
		<cfArgument name="minLength"		required="no"	type="numeric"			hint="" />
		<cfArgument name="invalidMessage"	required="no"	type="string"			hint="" />
		<cfScript>
			arrayAppend(variables.valArray, getNewValidation(argumentCollection=arguments));
			return variables.valArray[arrayLen(variables.valArray)];
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getValidation"
		returnType	= "Validation"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="num" required="no" type="numeric" default="1" hint="" />
		<cfReturn variables.valArray[arguments.num] />
	</cfFunction>

	<cfFunction
		name		= "getCount"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "how many validations set"
	>
		<cfReturn arrayLen(variables.valArray) />
	</cfFunction>

	<cfFunction
		Name		= "getValidationArray"
		returnType	= "array"
		Access		= "public"
		Output		= "no"
		Hint		= "returns array of validations"
	>
		<cfReturn variables.valArray />
	</cfFunction>

	<cfFunction
		name		= "getStatusStruct"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= "returns struct with keys : isVal & isValFormat"
	>
		<cfScript>
			local.invalidArray = getInvalidArray();

			local.returnStruct=
			{
				isVal			= !arrayLen(local.invalidArray)
				,isValFormat	= 1
				,invalidMessage	= ""
			};

			if(arrayLen(local.invalidArray))
			{
				local.returnStruct.value			= local.invalidArray[1].value;
				local.returnStruct.invalidMessage	= local.invalidArray[1].invalidMessage;
			}else
				local.returnStruct.value = getValue();

			//detect if invalid format
			for(local.aIndex=1; local.aIndex LTE arrayLen(local.invalidArray); ++local.aIndex)
			{
				local.invalStruct = local.invalidArray[local.aIndex];
				if(!local.invalStruct.isValFormat)
				{
					local.returnStruct.isValFormat = 0;
					break;
				}
			}

			return local.returnStruct;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getInvalidArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="isReturnFirst" required="no" type="boolean" default="no" hint="increase speed if all needed is true/false" />
		<cfScript>
			local.returnArray = arrayNew(1);
			local.validationArray = getValidationArray();
			local.value = getValue();
			local.valueLen = len(local.value);

			for(local.aIndex=1; local.aIndex LTE arrayLen(local.validationArray); ++local.aIndex)
			{
				local.Validation = local.validationArray[local.aIndex];

				if(local.valueLen)
					local.Validation.setValue(local.value);

				local.statusStruct = local.Validation.getStatusStruct();

				if(!local.statusStruct.isVal)
				{
					arrayAppend(local.returnArray, local.statusStruct);

					if(arguments.isReturnFirst)
						return local.returnArray;
				}
			}

			return local.returnArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isVal"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return arrayLen(getInvalidArray(1));
		</cfScript>
	</cfFunction>

</cfComponent>