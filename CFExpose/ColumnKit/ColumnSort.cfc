<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	extends		= "CFExpose.ComponentExtension"
	accessors	= "yes"
>

	<cfProperty name="orderByArray" type="array" />
	<cfset variables.orderByArray = arrayNew(1) />

	<cfFunction
		name		= "getDefinitionCount"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return arrayLen(variables.orderByArray);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getString"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.oCount = arrayLen(variables.orderByArray);

			if(!arrayLen(variables.orderByArray))
				return '';
		</cfScript>
		<cfSaveContent Variable="local.output">
			<cfLoop from="1" to="#local.oCount#" index="local.oIndex">
				<cfset local.ordStruct = variables.orderByArray[local.oIndex] />
				<cfSwitch expression="#local.ordStruct.sortType#">
					<cfCase value="columnName">
						<cfOutput>#local.ordStruct.columnName#</cfOutput> <cfif !local.ordStruct.isAsc >DESC</cfif>
					</cfCase>
				</cfSwitch>
				<cfif local.oIndex NEQ local.oCount >
					,
				</cfif>
			</cfLoop>
		</cfSaveContent>
		<cfReturn trim( reReplaceNoCase(local.output, '\r|\t|\n', '', 'all') ) />
	</cfFunction>

	<cfFunction
		name		= "setColumnName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="columnName"	required="yes"	type="string"				hint="" />
		<cfArgument name="isAsc"		required="no"	type="boolean"	default="1"	hint="asc or desc" />
		<cfScript>
			arguments.sortType = 'columnName';
			arrayAppend(variables.orderByArray, arguments);
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setColumn"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Column"		required="yes"	type="Column"	hint="" />
		<cfArgument name="isAsc"		required="no"	type="boolean"	default="1"	hint="asc or desc" />
		<cfScript>
			arguments.columnName = arguments.Column.getNotationRef(0);
			setColumnName(argumentCollection=arguments);
			return this;
		</cfScript>
	</cfFunction>

</cfComponent>
