<cfComponent
	Hint		= ""
	output		= "no"
	extends		= "ComponentExtension"
	accessors	= "yes"
>

	<cfProperty name="Var" type="any" />
	<cfset variables.setup = structNew() />

	<cfFunction
		name		= "init"
		returnType	= "ExposeVariable"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="variable" required="no" type="any" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "variable"))
				setVar(arguments.variable);

			return super.init(argumentCollection=arguments);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setVar"
		returnType	= "ExposeVariable"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="variable" required="yes" type="any" hint="" />
		<cfif structKeyExists(variables.setup , "varValidateTypeName") >
			<cfif
				variables.setup.isBaseVariableType
			AND
				!isValid(variables.setup.varValidateTypeName , arguments.variable)
			>
				<cfThrow
					message	= "Invalid set of variable type"
					detail	= "Variable attempting to be set is not type '#variables.setup.varValidateTypeName#'"
				/>
			</cfif>
			<cfif
				!variables.setup.isBaseVariableType
			AND
				!isInstanceOf(arguments.variable, variables.setup.varValidateTypeName)
			>
			<cfThrow
				message	= "Invalid set of variable type"
				detail	= "Variable attempting to be set is not type '#variables.setup.varValidateTypeName#' but is type '#getMetaData(arguments.variable).name#'"
			/>
			</cfif>
		</cfif>
		<cfset variables.setup.variable = arguments.variable />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getVar"
		returnType	= "any"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="onVoidReturn" required="no" type="any" hint="" />
		<cfScript>
			if( structKeyExists(variables.setup , "variable") )
				return variables.setup.variable;

			if(structKeyExists(arguments , "onVoidReturn"))
				return arguments.onVoidReturn;
		</cfScript>
		<cfThrow
			message	= "Expose variable not yet set in component '#getMetaData(this).name#'"
			detail	= "Use the method 'setVar' to set variable. You may also use a default return value when using the method 'getVar' such as getVar(1) and the value 1 will be returned if variable is not yet set"
		/>
	</cfFunction>

	<cfFunction
		name		= "setVarValidateByTypeName"
		returnType	= "ExposeVariable"
		access		= "private"
		output		= "no"
		description	= ""
		hint		= "restricts the type of variable that can be set. Intended for use only by extending components"
	>
		<cfArgument name="name" required="yes" type="variableName" hint="" />
		<cfScript>
			if( arguments.name EQ 'any' )return this;

			variables.setup.isBaseVariableType = listFindNoCase("array,Boolean,date,numeric,query,string,struct,UUID,GUID,binary,integer,float,eurodate,time,creditcard,email,ssn,telephone,zipcode,url,regex,range,component,variableName" , arguments.name);

			variables.setup.varValidateTypeName = arguments.Name;

			return this;
		</cfScript>
	</cfFunction>


</cfComponent>