<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	extends		= "NamePositionModel"
	accessors	= "yes"
	Column		= "Column"
	Schema		= ""
	Catalog		= ""
	Table		= ""
>

	<cfProperty name="nameArray"			type="array" />
	<cfProperty name="elementArray"			type="array" />
	<cfProperty name="IdentityColumnName"	type="string" />
	<cfProperty name="IdentityColumnValue"	type="string" />
	<cfProperty name="DataMetaReader"		type="DataMetaReader" />
	<cfProperty name="joinArray"			type="array" />
	<cfProperty name="Decorator"			type="RowDecorator" />

	<cfProperty name="TableName" type="string" />

	<cfScript>
		variables.joinArray		= arrayNew(1);
	</cfScript>

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
		name		= "autoLoadColumns"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.DataMetaReader = getDataMetaReader();

			if(isNull(local.DataMetaReader))
				return this;

			local.columnArray = local.DataMetaReader.getColumnArray();

			for(local.cIndex=1; local.cIndex LTE arrayLen(local.columnArray); ++local.cIndex)
			{
				local.cStruct = local.columnArray[local.cIndex];

				if(isNameDefined(local.cStruct.column_name))//? already defined ?
					continue;

				local.argStruct=
				{
					name				= local.cStruct.name
					,columnName			= local.cStruct.column_name
					,isIdentity			= local.cStruct.Is_Identity
					,isAllowNullValue	= local.cStruct.Is_Nullable
					,isReadOnly			= !local.cStruct.IsEditable
				};

				if(val(local.cStruct.CHARACTER_MAXIMUM_LENGTH))
					local.argStruct.maxLength = local.cStruct.CHARACTER_MAXIMUM_LENGTH;

				setColumnByAttributes(argumentCollection=local.argStruct);
			}

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setByName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Element"	required="yes"	type="Column"		hint="" />
		<cfArgument name="name"		required="yes"	type="string"		hint="" />
		<cfArgument name="isAppend" required="no"	type="boolean"	default="1"	hint="" />
		<cfScript>
			/* define row */
				local.Row = arguments.Element.getRow();

				if(!structKeyExists(local, 'Row'))
					arguments.Element.setRow(this);
			/* end */

			super.setByName(argumentCollection=arguments);

			if(arguments.Element.isIdentity() AND !len(getIdentityColumnName()))
				setIdentityColumnName(arguments.Element.getName());

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
		<cfArgument name="Column"			required="yes"	type="Column"		hint="" />
		<cfArgument name="isAppend"			required="no"	type="boolean"	default="1"	hint="" />
		<cfArgument name="decoratorName"	required="no"	type="string"	hint="" />
		<cfArgument name="decoratorType"	required="no"	type="string"	hint="" />
		<cfScript>
			if(structKeyExists(arguments, "decoratorName") or structKeyExists(arguments, "decoratorType"))
				setColumnDecoratorByAttributes(argumentCollection=arguments);

			setByName(arguments.Column, arguments.Column.getName(), arguments.isAppend);

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setDataMetaReader"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="DataMetaReader" required="yes" type="DataMetaReader" hint="" />
		<cfScript>
			variables.DataMetaReader = arguments.DataMetaReader;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getDataMetaReader"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( structKeyExists(variables, "DataMetaReader") )
				return variables.DataMetaReader;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getTableName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(structKeyExists(variables, "tableName") AND len(variables.tableName))
				return variables.tableName;

			variables.tableName = Expose(this).getAttribute("Table");

			if(variables.tableName EQ 'Yes')
				variables.tableName = listLast(getMetaData(this).name,'.');

			return variables.tableName;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getSchemaName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(structKeyExists(variables, "schemaName") AND len(variables.schemaName))
				return variables.schemaName;

			variables.schemaName = Expose(this).getAttribute("schema");

			return variables.schemaName;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getCatalogName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(structKeyExists(variables, "catalogName") AND len(variables.catalogName))
				return variables.catalogName;

			variables.catalogName = Expose(this).getAttribute("catalog");

			return variables.catalogName;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setColumnByAttributes"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="name"				required="no"	type="string"	hint="" />
		<cfArgument name="columnName"		required="no"	type="string"	hint="" />
		<cfArgument name="label"			required="no"	type="string"	hint="" />
		<cfArgument name="isIdentity"		required="no"	type="boolean"	hint="" />
		<cfArgument name="isAllowNullValue"	required="no"	type="boolean"	hint="" />
		<cfArgument name="maxLength"		required="no"	type="numeric"	hint="" />
		<cfArgument name="ColumnClassName"	required="no"	type="string"	hint="" />
		<cfArgument name="decoratorName"	required="no"	type="string"	hint="" />
		<cfArgument name="decoratorType"	required="no"	type="string"	hint="" />
		<cfArgument name="Row"				required="no"	type="Row"		hint="" />
		<cfArgument name="dataType"			required="no"	type="string"	hint="" />
		<cfArgument name="hint"				required="no"	type="string"	hint="" />
		<cfArgument name="isSummaryColumn"	required="no"	type="boolean"	hint="" />
		<cfScript>
			if(!structKeyExists(arguments, "Row"))
				arguments.Row = this;

			if(!structKeyExists(arguments, 'name') AND structKeyExists(arguments, "columnName"))
				arguments.name = arguments.columnName;

			if(!structKeyExists(arguments, 'ColumnClassName'))
				arguments.ColumnClassName = iExpose().getAttribute('Column');

			arguments.DataMetaReader = this.getDataMetaReader();

			local.isNameDefined = isNameDefined(arguments.name);

			if(local.isNameDefined)
			{
				arguments.Column = getByName(arguments.name).init(argumentCollection=arguments);

				/* methods typically run by setColumn */
					local.isApplyDecorator = structKeyExists(arguments, "decoratorName") or structKeyExists(arguments, "decoratorType");

					if(local.isApplyDecorator)
						setColumnDecoratorByAttributes(argumentCollection=arguments);
				/* end */

			}else
			{
				arguments.Column = new(arguments.ColumnClassName,arguments);
				structDelete(arguments, "name");

				setColumn(argumentCollection=arguments);
			}

				/* make sure the owning row is aware of this column */
				if(structKeyExists(arguments, "Row"))
				{
					local.rowHasColumn = arguments.Row.isNameDefined(arguments.Column.getName());

					if(!local.rowHasColumn)
						arguments.Row.setColumn( arguments.Column );
				}

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setColumnDecoratorByAttributes"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Column"			required="yes" type="Column" hint="" />
		<cfArgument name="decoratorName"	required="no"	type="string"	hint="" />
		<cfArgument name="decoratorType"	required="no"	type="string"	hint="" />
		<cfScript>
			if(structKeyExists(arguments, "decoratorName"))
				arguments.name = arguments.decoratorName;

			if(structKeyExists(arguments, "decoratorType"))
				arguments.type = arguments.decoratorType;

			local.Decorator = getDecorator().setColumnDecoratorByName(argumentCollection=arguments);

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isInsertReady"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.editableArray = getEditableColumnArray();

			for(local.cIndex=arrayLen(local.editableArray); local.cIndex GT 0; --local.cIndex)
			{
				local.Column = local.editableArray[local.cIndex];

				if(!len(local.Column.getValue()) AND !local.Column.isAllowNullValue())
					return false;
			}

			return true;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getInsertReadyColumnArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.returnArray = arrayNew(1);
			local.editableArray = getEditableColumnArray();

			for(local.cIndex=arrayLen(local.editableArray); local.cIndex GT 0; --local.cIndex)
			{
				local.Column = local.editableArray[local.cIndex];
				local.valueLen = len(local.Column.getValue());

				if(local.valueLen)
					arrayPrepend(local.returnArray, local.Column);
			}

			return local.returnArray;
		</cfScript>
	</cfFunction>

	<!--- Identity Column Methods --->
		<cfFunction
			name		= "setIdentityColumnName"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="name" required="yes" type="string" hint="" />
			<cfScript>
				variables.IdentityColumnName = arguments.name;
				local.IdColumn = getByName(arguments.name);

				if(!structKeyExists(local, 'IdColumn'))
					setColumnByAttributes(name=arguments.name, identity=1);

				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "isIdentityColumnDefined"
			returnType	= "boolean"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				return structKeyExists(variables, "IdentityColumnName");
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getIdentityColumnName"
			returnType	= "string"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				if(isIdentityColumnDefined())
					return variables.IdentityColumnName;

				/* search defined columns for an identity specification */
					local.cArray = getArray();

					for(local.Column in local.cArray)
					{
						if(local.Column.isIdentity() AND objectEquals(local.Column.getRow(), this))
						{
							variables.IdentityColumnName = local.Column.getName();
							return variables.IdentityColumnName;
						}
					}
				/* end */

				return '';
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getIdentityColumn"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= "may return void"
			description	= ""
		>
			<cfScript>
				return getByName(getIdentityColumnName());
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getIdentityColumnValue"
			returnType	= "string"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				local.IdentityColumn = getIdentityColumn();

				if(structKeyExists(local, "IdentityColumn"))
					return local.IdentityColumn.getValue();

				//return 0;
				return '';
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "setIdentityColumnValue"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="value" required="yes" type="string" hint="" />
			<cfScript>
				local.IdentityColumn = getIdentityColumn();

				if(structKeyExists(local, "IdentityColumn"))
					local.IdentityColumn.setValue(arguments.value);

				return this;
			</cfScript>
		</cfFunction>
	<!--- end : Identity Column Methods --->

	<cfFunction
		name		= "getValueStruct"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="isEmptyStringMode" required="no" type="boolean" default="0" hint="" />
		<cfScript>
			local.struct = structNew();
			local.cArray = getArray();

			for(local.x=1; local.x LTE arrayLen(local.cArray); ++local.x)
			{
				local.Col = local.cArray[local.x];
				local.value = local.Col.getValue();

				if(len(local.value) or arguments.isEmptyStringMode)
					local.struct[local.Col.getName()] = local.value;
			}

			return local.struct;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setColumnValuesByStruct"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="struct" required="yes" type="struct" hint="" />
		<cfScript>
			local.qColumnNameList = structKeyList(arguments.struct);

			local.columnArray = getArray();

			while(arrayLen(local.columnArray))
			{
				loca.Column = local.columnArray[1];
				local.name = loca.Column.getName();

				local.find = listFindNoCase(local.qColumnNameList, local.name);

				if(local.find && isSimpleValue(arguments.struct[local.name]))
					loca.Column.setValue(arguments.struct[local.name]);

				arrayDeleteAt(local.columnArray, 1);
			}

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setColumnValuesByQuery"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="query"	required="yes"	type="query" hint="" />
		<cfArgument name="row"		required="no"	type="numeric" default="1" hint="" />
		<cfScript>
			local.qColumnNameList = arguments.query.columnList;
			local.columnArray = getArray();

			for(local.x=arrayLen(local.columnArray); local.x GT 0; --local.x)
			{
				loca.Column = local.columnArray[local.x];
				local.name = loca.Column.getName();

				local.find = listFindNoCase(local.qColumnNameList, local.name);

				if(local.find)
					loca.Column.setValue(arguments.query[local.name][arguments.row]);
			}

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getIdentityColumnArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= "loops all columns looking for identity specification"
		description	= ""
	>
		<cfScript>
			local.cArray = getArray();
			local.iArray = arrayNew(1);

			for(local.x=arrayLen(local.cArray); local.x GT 0; --local.x)
				if(local.cArray[local.x].isIdentity())
					arrayPrepend(local.iArray, local.cArray[local.x]);

			return local.iArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "dropColumn"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Column" required="yes" type="Column" hint="" />
		<cfScript>
			local.tick = getTickCount();
			arguments.Column.tick = local.tick;
			local.cArray = getArray();

			for(local.x=arrayLen(local.cArray); local.x GT 0; --local.x)
			{
				local.Column = local.cArray[local.x];
				if(structKeyExists(local.Column, "tick") AND local.tick EQ local.Column.tick)
					arrayDeleteAt(local.cArray, local.x);
			}

			structDelete(arguments.Column, "tick");

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getFileColumnArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.returnArray = arrayNew(1);
			local.array = getArray();

			for(local.x=arrayLen(local.array); local.x GT 0; --local.x)
				if(local.array[local.x].isFileMode())
					arrayPrepend(local.returnArray, local.array[local.x]);

			return local.returnArray;
		</cfScript>
	</cfFunction>

	<!--- column type definitions --->
		<cfFunction
			name		= "getSummaryColumnNameList"
			returnType	= "string"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				if( !structKeyExists(variables, "SummaryColumnNameList") )
				{
					local.returnString = '';
					local.Columns = getSummaryColumnArray();

					for(local.x=1; local.x LTE arrayLen(local.Columns); ++local.x)
						local.returnString &= local.Columns[local.x].getName() & ',';

					if(len(local.returnString))
						local.returnString = left(local.returnString,len(local.returnString)-1);

					return local.returnString;
				}

				return variables.SummaryColumnNameList;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getSummaryColumnArray"
			returnType	= "array"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				local.rArray = arrayNew(1);
				local.columnArray = getArray();

				for(local.x=1; local.x LTE arrayLen(local.columnArray); ++local.x)
					if(local.columnArray[local.x].isSummaryColumn())
						arrayAppend(local.rArray, local.columnArray[local.x]);

				return local.rArray;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getEditableColumnNameList"
			returnType	= "string"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				if( !structKeyExists(variables, "EditableColumnNameList") )
				{
					local.returnString = '';
					local.Columns = getEditableColumnArray();

					for(local.x=1; local.x LTE arrayLen(local.Columns); ++local.x)
						local.returnString &= local.Columns[local.x].getName() & ',';

					if(len(local.returnString))
						return left(local.returnString,len(local.returnString)-1);

					return '';
				}

				return variables.EditableColumnNameList;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "setSummaryColumnNameList"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="SummaryColumnNameList" required="yes" type="string" hint="" />
			<cfset variables.SummaryColumnNameList = arguments.SummaryColumnNameList />
			<cfReturn this />
		</cfFunction>
	<!--- end: column type definitions --->

	<!--- validations --->
		<cfFunction
			name		= "isVal"
			returnType	= "boolean"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				return arrayLen(getInvalidArray()) eq 0;
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
			<cfScript>
				local.invalidArray = arrayNew(1);
				local.cArray = getArray();
				local.tableRef = getDataMetaReader().getTableRef();

				for(local.x=1; local.x LTE arrayLen(local.cArray); ++local.x)
				{
					local.Column = local.cArray[local.x];
					local.Row = local.Column.getRow();

					local.isAutoValidate = 0;

					if(structKeyExists(local, "Row"))
						local.isAutoValidate = local.Row.getDataMetaReader().getTableRef() EQ local.tableRef;

					local.validationStruct = local.Column.getValidationStatusStruct(local.isAutoValidate);

					if(!local.validationStruct.isVal)
						arrayAppend(local.invalidArray, local.validationStruct);
				}

				return local.invalidArray;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "setEditableColumnNameList"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="EditableColumnNameList" required="yes" type="string" hint="" />
			<cfset variables.EditableColumnNameList = arguments.EditableColumnNameList />
			<cfReturn this />
		</cfFunction>

		<cfFunction
			name		= "getEditableColumnArray"
			returnType	= "array"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				local.rArray = arrayNew(1);
				local.colArray = getArray();

				for(local.x=1; local.x LTE arrayLen(local.colArray); ++local.x)
					if(!local.colArray[local.x].isReadOnly())
						arrayAppend(local.rArray, local.colArray[local.x]);

				return local.rArray;
			</cfScript>
		</cfFunction>
	<!--- end: validations --->

	<!--- Join Methods --->
		<cfFunction
			name		= "setJoin"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="Row"				required="yes"	type="Row"					hint="" />
			<cfArgument name="ConditionModel"	required="yes"	type="CFExpose.TransKit.ConditionModel"	hint="" />
			<cfArgument name="joinType"			required="yes"	type="variableName"		default="Inner"	hint="" />
			<cfScript>
				/* add columns to this model */
	/*
					local.cArray = arguments.Row.getArray();
					for(local.x=1; local.x LTE arrayLen(local.cArray); ++local.x)
						setColumn(local.cArray[local.x]);
	*/
				/* end */
				arrayAppend(variables.joinArray, arguments);

				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getJoinArray"
			returnType	= "array"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="tableName" required="no" type="string" hint="only returns joins matching table name" />
			<cfScript>
				var local = {};

				local.joinArray = variables.joinArray;
				if(!structKeyExists(arguments, 'tableName'))
					return local.joinArray;

				local.returnArray = arrayNew(1);
				for(local.x=arrayLen(local.joinArray); local.x GT 0; --local.x)
				{
					local.DataMetaReader = local.joinArray[local.x].Row.getDataMetaReader();

					if(local.DataMetaReader.getTableName() EQ arguments.tableName)
						arrayPrepend(local.returnArray, local.joinArray[local.x]);
				}

				return local.returnArray;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getRowByTableName"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="tableName" required="yes" type="string" hint="" />
			<cfScript>
				var local = structNew();

				local.DataMetaReader = getDataMetaReader();

				if(local.DataMetaReader.getTableName() EQ arguments.tableName)
					return this;

				local.joinArray = getJoinArray();

				for(local.x=arrayLen(local.joinArray); local.x GT 0; --local.x)
				{
					local.Row = local.joinArray[local.x].Row;
					local.DataMetaReader = local.Row.getDataMetaReader();

					if(local.DataMetaReader.getTableName() EQ arguments.tableName)
						return local.Row;
				}
			</cfScript>
		</cfFunction>
	<!--- end : join methods --->

	<cfFunction
		name		= "decorateQuery"
		returnType	= "query"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="query" required="yes" type="query" hint="" />
		<cfScript>
			local.ExQuery = Expose(arguments.query);
			local.Decorator = getDecorator();
			local.ExQuery.deleteColumnDataTypes();

			for(local.rowIndex=1; local.rowIndex LTE arguments.query.recordCount; ++local.rowIndex)
			{
				setColumnValuesByQuery(arguments.query, local.rowIndex);
				local.valueStruct = getDecorator().getValueStruct();
				local.ExQuery.setRowByStruct(local.valueStruct).gotoNextRow();
			}

			local.returnQuery = local.ExQuery.getVar();

			return local.returnQuery;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getDecorator"
		returnType	= "RowDecorator"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(!structKeyExists(variables, 'Decorator'))
				variables.Decorator = new RowDecorator(Row=this);

			return variables.Decorator;
		</cfScript>
	</cfFunction>

</cfComponent>