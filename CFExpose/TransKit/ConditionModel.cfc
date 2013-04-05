<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	Extends		= "CFExpose.ComponentExtension"
	accessors	= "yes"
>

	<cfProperty name="conditions" type="array" />
	<cfScript>
		variables.conditions = arrayNew(1);
	</cfScript>

	<cfFunction
		name		= "getArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfReturn variables.conditions />
	</cfFunction>

	<cfFunction
		name		= "setColumnAsCondition"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= "takes the value and adds a column value condition"
		description	= ""
	>
		<cfArgument name="Column"		required="yes"	type="CFExpose.ColumnKit.Column"		hint="" />
		<cfArgument name="matchType"	required="no"	type="variableName"					default="exact"	hint="exact, like, likeleft, likeright" />
		<cfArgument name="compoundType"	required="no"	type="variableName"					default="and"	hint="and, or" />
		<cfScript>
			arguments.conditionType = 'columnValue';
			arrayAppend(variables.conditions, arguments);
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setColumnCondition"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Column"	required="yes"	type="CFExpose.ColumnKit.Column"	hint="" />
		<cfArgument name="ColumnTo"	required="yes"	type="CFExpose.ColumnKit.Column"	hint="" />
		<cfArgument name="matchType"	required="no"	type="variableName"					default="exact"	hint="exact, like, likeleft, likeright" />
		<cfArgument name="compoundType"	required="no"	type="variableName"					default="and"	hint="and, or" />
		<cfScript>
			arguments.conditionType = 'column';
			arrayAppend(variables.conditions, arguments);
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setValueCondition"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="value" required="yes" type="string" hint="" />
		<cfArgument name="valueTo" required="yes" type="string" hint="" />
		<cfScript>
			arguments.conditionType = 'value';
			arrayAppend(variables.conditions, arguments);
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setByRow"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= "every column that has a value in supplied Row will act as a limiting condition"
	>
		<cfArgument name="Row" required="yes" type="CFExpose.ColumnKit.Row" hint="" />
		<cfScript>
			local.valStruct = arguments.Row.getValueStruct();

			for(local.x in local.valStruct)
				setColumnAsCondition( arguments.Row.getByName(local.x) );

			return this;
		</cfScript>
	</cfFunction>

</cfComponent>
<!---
	<cfFunction
		name		= "setColumnValueCondition"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfArgument name="value" required="yes" type="string" hint="" />
		<cfScript>
			arguments.conditionType = 'columnValue';
			arrayAppend(variables.conditions, arguments);
			return this;
		</cfScript>
	</cfFunction>
--->
