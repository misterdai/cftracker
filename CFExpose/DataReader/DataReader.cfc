<cfComponent
	Description	= ""
	Hint		= ""
	Output		= "no"
	accessors	= "yes"
	Extends		= "CFExpose.ComponentExtension"
>

	<cfProperty name="CurrentRowNumber"	type="numeric" />
	<cfProperty name="ColumnList"		type="string" />
	<cfProperty name="RowCount"			type="numeric" />

	<cfScript>
		variables.currentRowNumber = 1;
	</cfScript>

	<cfFunction
		name		= "next"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			setCurrentRowNumber( getCurrentRowNumber() + 1 );
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "each"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="method"		required="yes" type="any" hint="" />
		<cfArgument name="columnList"	required="no" type="string" hint="" />
		<cfScript>
			local.rowCount = getRowCount();
			local.savedRowNumber = getCurrentRowNumber();
			setCurrentRowNumber(1);

			for(local.rowIndex=1; local.rowIndex LTE local.rowCount; ++local.rowCount)
			{
				arguments.method( getStruct() );
				next();
			}

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getByName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfScript>
			local.struct = getStruct(arguments.name);
			return local.struct[arguments.name];
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isLastRow"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return getCurrentRowNumber() GTE getRowCount();
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "toStructOfArrays"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="columnList" required="no" type="string" hint="" />
		<cfThrow message="function not yet created" detail="" />
	</cfFunction>

	<cfFunction
		name		= "paramColumnList"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="columnList" required="no" type="string" hint="" />
		<cfScript>
			if(structKeyExists(arguments, 'columnList'))
				return arguments.columnList;

			return getColumnList();
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
		<cfArgument name="columnList" required="no" type="string" hint="" />
		<cfScript>
			arguments.columnList = paramColumnList(arguments.columnList);
			local.columnArray = listToArray(arguments.columnList);
			local.struct = structNew();

			for(local.colIndex=arrayLen(local.columnArray); local.colIndex GT 0; --local.colIndex)
			{
				local.columnName = local.columnArray[local.colIndex];
				local.struct[local.columnName] = getByName(local.columnName);
			}

			return local.struct;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setCurrentRowNumber"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="CurrentRowNumber" required="yes" type="numeric" hint="" />
		<cfScript>
			variables.CurrentRowNumber = arguments.CurrentRowNumber;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getCurrentRowNumber"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return variables.currentRowNumber;
		</cfScript>
	</cfFunction>

</cfComponent>