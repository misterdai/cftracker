<cfComponent
	Hint		= "directory based functionality. Set directory once, perform all actions"
	Output		= "no"
	extends		= "CFExpose.ComponentExtension"
	accessors	= "yes"
>

	<cfProperty name="TextQualifier"		type="string" />
	<cfProperty name="ValueDelimiter"		type="string" />
	<cfProperty name="FirstRowAsHeaders"	type="boolean" />
	<cfProperty name="RowDelimiters"		type="string" />
	<cfProperty name="MaxRowCount"			type="numeric" />

	<cfFunction
		name		= "getRowDelimiters"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(structKeyExists(variables, "RowDelimiters"))
				return variables.RowDelimiters;

			return chr(10)&chr(13);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isFirstRowAsHeaders"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.FirstRowAsHeaders = arguments.yesNo;

			if(!structKeyExists(variables, "FirstRowAsHeaders"))
				return 1;

			return variables.FirstRowAsHeaders;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getValueDelimiter"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(structKeyExists(variables, 'ValueDelimiter'))
				return variables.ValueDelimiter;

			return ',';
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getTextQualifier"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(structKeyExists(variables, 'TextQualifier'))
				return variables.TextQualifier;

			return '';
		</cfScript>
	</cfFunction>

</cfComponent>