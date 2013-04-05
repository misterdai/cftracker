<cfComponent
	Hint		= "represents one of an inputs validation requirements"
	Description	= ""
	Extends		= "CFExpose.ComponentExtension"
	output		= "no"
	accessors	= "yes"
>

	<cfProperty name="required"					type="boolean" />
	<cfProperty name="title"					type="string" />
	<cfProperty name="invalidMessage"			type="string" />
	<cfProperty name="type"						type="string" />
	<cfProperty name="ValidWhenArray"			type="array" />
	<cfProperty name="ValidWhenGroupingArray"	type="array" />
	<cfScript>
		variables.setupCollection={};

		variables.ValidWhenArray		= arrayNew(1);
		variables.ValidWhenGroupingArray	= arrayNew(1);

		variables.title = '';
		variables.invalidMessage = '';
		variables.type = '';
	</cfScript>

	<cfFunction
		name		= "init"
		output		= "no"
		access		= "public"
		returnType	= "Validation"
	>
		<cfArgument name="required"			required="no"	type="boolean"		hint="" />
		<cfArgument name="pattern"			required="no"	type="string"		hint="" />
		<cfArgument name="type"				required="no"	type="variableName" hint="phone,firstNameLastName,variableName,email,integer" />
		<cfArgument name="minLength"		required="no"	type="numeric"		hint="" />
		<cfArgument name="invalidMessage"	required="no"	type="string"		hint="" />
		<cfScript>
			if(structKeyExists(arguments , "type"))
				setValidationType(arguments.type);

			Return super.init(argumentCollection=arguments);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getRequired"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return isRequired();
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getInvalidMessage"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(len(variables.invalidMessage))
				return variables.invalidMessage;

			local.valType = getValidationType();

			switch (local.valType)
			{
				case "phone":
					return "Must be a valid US Phone Number. Area code required";

				case "variableName":
					return "Must start with a letter or underscore and contains letters, numbers, underscores, and periods only";

				case "email":
					return "Invalid Email Address";

				case "integer":
					return "Invalid Number. Must be whole number. No decimals, commas or dollar signs";

				case "firstNameLastName":
					return "Must be atleast a first and last name";
			}

			return "";
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getTitle"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(len(variables.title))
				return variables.title;

			local.valType = getValidationType();

			switch (local.valType)
			{
				case "phone":
					return "Invalid Phone Number";

				case "variableName":
					return "Invalid Variable Name";

				case "email":
					return "";

				case "integer":
					return "";

				case "firstNameLastName":
					return "Invalid Name";
			}

			return "";
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getSetupCollection"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn variables.setupCollection />
	</cfFunction>

	<cfFunction
		name		= "isRequired"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.Required = arguments.yesNo;

			if(!structKeyExists(variables, "Required"))
				variables.Required = 1;

			return variables.Required;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setValidationType"
		returnType	= "Validation"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="type" required="yes" type="variableName" hint="" />
		<cfScript>
			variables.type = arguments.type;
			variables.setupCollection.pattern = typeToPattern(type=arguments.type);
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getValidationType"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn variables.type />
	</cfFunction>

	<cfFunction
		Name		= "typeToPattern"
		returnType	= "string"
		Access		= "private"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="type" required="yes" type="variableName" hint="" />
		<cfScript>
			switch(arguments.type)
			{
				case "phone":
					return "^(1[ ]*[-\.]?)?[\(]?[0-9]{3}[\)]?[ ]*[-\.]?[ ]*[0-9]{3}[ ]*[-\.]?[ ]*[0-9]{4}[ ]*(([xX]|[eE][xX][tT])\.?[ ]*([0-9]+))*$";

				case "integer":
					return "^[0-9]+$";

				case "firstNameLastName":
					return "[a-zA-Z]+[ ][a-zA-Z]+$";

				case "email":
					return "^[\w\-\.]+@([\w\-]+\.)+[\w]{2,3}$";
					//return "^(([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+([;.](([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+)*$";

				case "variableName":
					return "^[a-zA-Z_][a-zA-Z0-9_.]*$";

				case "monthDayYear":
					variables.setupCollection.type = "date";
					return "^\d{1,2}[/-]\d{1,2}[/-]\d{4}$";
			}
		</cfScript>
		<cfThrow message="An invalid validation type has been specified" detail="#arguments.type# is an unsupported validation type" />
	</cfFunction>

	<!--- Is Valid Methods --->
		<cfFunction
			name		= "getStatusStruct"
			returnType	= "struct"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				local.value			= getValue();
				local.isRequired	= isRequired();
				local.isVal			= 1;
				local.isValFormat	= 1;

				//required and no length
				if(local.isRequired AND !len(local.value))
					local.isVal = false;
				else if(!variables.isValFormat())
				{
					local.isValFormat = 0;
					local.isVal = 0;
				}

				/* is valid when conditions . !!!TODO: This is not yet implemented */
					local.validWhenArray = getIsValidWhenArray();
					for(local.aIndex=1; local.aIndex LTE arrayLen(local.validWhenArray); ++local.aIndex)
					{
						local.when = local.validWhenArray[local.aIndex];
						CFMethods().throw('getIsValidWhenArray() not yet implemented for server-side validation');
					}

					local.validWhenArray = getIsValidWhenGroupingArray();
					for(local.aIndex=1; local.aIndex LTE arrayLen(local.validWhenArray); ++local.aIndex)
					{
						local.when = local.validWhenArray[local.aIndex];
						CFMethods().throw('getIsValidWhenGroupingArray() not yet implemented for server-side validation');
					}
				/* end */

				local.statusStruct=
				{
					isValFormat		= local.isValFormat
					,isVal			= local.isVal
					,value			= local.value
					,invalidMessage	= getInvalidMessage()
				};

				return local.statusStruct;
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
			<cfReturn getStatusStruct().isVal />
		</cfFunction>

		<cfFunction
			name		= "isValFormat"
			returnType	= "boolean"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				if(structKeyExists(variables.setupCollection, "pattern"))
				{
					local.value = getValue();

					local.isPatternFound = reFindNoCase(variables.setupCollection.pattern, local.value, 1, false);

					if(!local.isPatternFound)
						return false;
				}

				return true;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "setValue"
			returnType	= "Validation"
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
	<!--- end --->

	<cfFunction
		Name		= "setIsValidWhen"
		returnType	= "Validation"
		Access		= "public"
		Output		= "no"
		Hint		= "When input recieved, matches either value or pattern arguments then this input becomes valid"
		Description	= "Not specifiying a value or pattern argument will make this input valid as long as a value is present from the input argument. ANY validWhen condition set will make this input valid (does not check all validWhen conditions)"
	>
		<cfArgument name="Input"					required="yes"	type="CFExpose.ColumnKit.Column"	hint="" />
		<cfArgument name="value"					required="no"	type="string"						hint="" />
		<cfArgument name="pattern"					required="no"	type="string"						hint="" />
		<cfArgument name="isValidWhenNotMatched"	required="no"	type="boolean"		default="no"	hint="" />
		<cfScript>
			CFMethods().structDeleteNulls(arguments);
			arrayAppend(variables.validWhenArray , arguments);
			return this;
		</cfScript>
	</cfFunction>
<!---
	/* !!! DO NOT DELETE, WILL NEED THESE AGAIN !!! */

	<cfFunction
		Name		= "addIsValidWhenGrouping"
		returnType	= "void"
		Access		= "public"
		Output		= "no"
		Hint		= "When input recieved, matches either value or pattern arguments then this input becomes valid as long as all other validWhenGrouping conditions are true as well"
		Description	= "Not specifiying a value or pattern argument will make this input valid as long as a value is present from the input argument."
	>
		<cfArgument name="Input"					required="yes"	type="Movic.Column"					hint="" />
		<cfArgument name="value"					required="no"	type="string"						hint="" />
		<cfArgument name="pattern"					required="no"	type="string"						hint="" />
		<cfArgument name="isValidWhenNotMatched"	required="no"	type="boolean"		default="no"	hint="" />
		<cfScript>
			arguments.name = arguments.input.name;
			structDelete(arguments, "input", true);
			arrayAppend(variables.ValidWhenGroupingArray, arguments);
		</cfScript>
	</cfFunction>
	/* !!! DO NOT DELETE, WILL NEED THESE AGAIN !!! */
--->
	<cfFunction
		Name		= "getIsValidWhenGroupingArray"
		returnType	= "array"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfReturn variables.ValidWhenGroupingArray />
	</cfFunction>

	<cfFunction
		Name		= "getIsValidWhenArray"
		returnType	= "array"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfReturn variables.ValidWhenArray />
	</cfFunction>

</cfComponent>