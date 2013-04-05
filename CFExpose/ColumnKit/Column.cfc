<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	extends		= "NamedComponent"
	accessors	= "yes"
>

	<cfProperty name="Row"					type="Row" />
	<cfProperty name="columnName"			type="string" />
	<cfProperty name="value"				type="string" />
	<cfProperty name="label"				type="string" />
	<cfProperty name="displayValue"			type="string" />
	<cfProperty name="defaultValue"			type="string" />
	<cfProperty name="hint"					type="string" />
	<cfProperty name="maxLength"			type="numeric" />
	<cfProperty name="Identity"				type="boolean" />
	<cfProperty name="DataType"				type="string" />

	<cfProperty name="DataMetaReader"		type="DataMetaReader" />
	<cfProperty name="ReadOnly"				type="boolean" />
	<cfProperty name="CfSqlType"			type="string" />

	<cfProperty name="ValidationModel"		type="ValidationModel" />
	<cfProperty name="ValidationFormat"		type="string" />
	<cfProperty name="InvalidMessage"		type="string" />
	<cfProperty name="InvalidFormatMessage"	type="string" />
	<cfProperty name="allowNullValue"		type="boolean" />

	<cfFunction
		name		= "setColumnName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= "considered raw column name as perhaps stored in a database sales. The methods getName/setName act as the alias aka sql select as alias."
		description	= ""
	>
		<cfArgument name="ColumnName" required="yes" type="string" hint="" />
		<cfScript>
			variables.ColumnName = arguments.ColumnName;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getColumnName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= "considered raw column name as perhaps stored in a database sales. The methods getName/setName act as the alias aka sql select as alias."
		description	= "if columnname not set, then name returned"
	>
		<cfScript>
			if(structKeyExists(variables, "ColumnName"))
				return variables.ColumnName;

			if(structKeyExists(variables, "name"))
				return variables.name;
		</cfScript>
		<cfThrow message="ColumnName Not Yet Set" detail="Use the method 'setColumnName' in component '#getMetaData(this).name#'" />
	</cfFunction>

	<cfFunction
		name		= "getName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= "if name not set, then columnname returned"
	>
		<cfScript>
			if(structKeyExists(variables, "name"))
				return variables.name;

			if(structKeyExists(variables, "columnName"))
				return variables.columnName;
		</cfScript>
		<cfThrow message="ColumnName Not Yet Set" detail="Use the method 'setColumnName' in component '#getMetaData(this).name#'" />
	</cfFunction>

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
		<cfScript>
			if( NOT structKeyExists(variables, "Value") )
				return getDefaultValue();

			return variables.Value;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setMaxLength"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="MaxLength" required="yes" type="numeric" hint="" />
		<cfScript>
			variables.MaxLength = arguments.MaxLength;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getMaxLength"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( NOT structKeyExists(variables, "MaxLength") )
				return 0;

			return variables.MaxLength;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getLabel"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfScript>
			var local = structNew();

			if( !structKeyExists(variables, 'label') )
			{
				local.name = getname();

				if(len(local.name))
					variables.label = CFMethods().variableNameToTitle(local.name);
				else
					return '';
			}

			return variables.label;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setLabel"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Label" required="yes" type="string" hint="" />
		<cfScript>
			variables.Label = arguments.Label;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setDisplayValue"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="DisplayValue" required="yes" type="string" hint="" />
		<cfScript>
			variables.DisplayValue = arguments.DisplayValue;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getDisplayValue"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			var local = structNew();

			if( NOT structKeyExists(variables, "DisplayValue") )
			{
				local.value = getValue();

				switch(getCfSqlType())
				{
					case 'bit':
					{
						if(isBoolean(local.value))
							return yesNoFormat(local.value);
						break;
					}
				}

				return getValue();
			}

			return variables.DisplayValue;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setCfSqlType"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= "bit, varchar"
		description	= "auto removes string: cf_sql_"
	>
		<cfArgument name="cfSqlType" required="yes" type="string" hint="" />
		<cfset variables.cfSqlType = replace(arguments.cfSqlType,'cf_sql_','') />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getCfSqlType"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( NOT structKeyExists(variables, "cfSqlType") )
			{
				local.dataType = getDataType();

				switch(local.dataType)
				{
					case 'timestamp':variables.cfSqlType='TIMESTAMP';
						break;

					default:variables.cfSqlType='varchar';
				}
			}

			return variables.cfSqlType;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setDefaultValue"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="DefaultValue" required="yes" type="string" hint="" />
		<cfset variables.DefaultValue = arguments.DefaultValue />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getDefaultValue"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( NOT structKeyExists(variables, "DefaultValue") )
				return '';

			return variables.DefaultValue;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isAllowNullValue"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.allowNullValue = arguments.yesNo;

			if(!structKeyExists(variables, "allowNullValue"))
				return !isIdentity();

			return variables.allowNullValue;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getAllowNullValue"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return isAllowNullValue();
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isReadOnly"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.ReadOnly = arguments.yesNo;

			if(!structKeyExists(variables, "ReadOnly"))
				variables.ReadOnly = 0;

			return variables.ReadOnly;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isIdentity"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.Identity = arguments.yesNo;

			if(!structKeyExists(variables, "Identity"))
				variables.Identity = 0;

			return variables.Identity;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setHint"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Hint" required="yes" type="string" hint="" />
		<cfScript>
			variables.Hint = arguments.Hint;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getHint"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(!structKeyExists(variables, 'hint'))
				return '';

			return variables.Hint;
		</cfScript>
	</cfFunction>

	<!--- Validation Methods --->
		<cfFunction
			name		= "getValidationModel"
			returnType	= "CFExpose.ValidationKit.Model"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfif !structKeyExists(variables, "ValidationModel") >
				<cfset variables.ValidationModel = new('CFExpose.ValidationKit.Model') />
			</cfif>
			<cfReturn variables.ValidationModel />
		</cfFunction>

		<cfFunction
			name		= "getInvalidMessage"
			returnType	= "string"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= "accessor override"
		>
			<cfif !structKeyExists(variables, "InvalidMessage") >
				<cfset variables.InvalidMessage = getLabel() & ', is invalid' />
			</cfif>
			<cfReturn variables.InvalidMessage />
		</cfFunction>

		<cfFunction
			name		= "getInvalidFormatMessage"
			returnType	= "string"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= "accessor override"
		>
			<cfScript>
				if( !structKeyExists(variables, "InvalidFormatMessage") )
				{
					variables.InvalidFormatMessage = getLabel() & ', is not in a valid ';

					local.validationFormat = getValidationFormat();

					if(len(local.validationFormat) and isValid("variableName" , local.validationFormat))
						variables.InvalidFormatMessage &= lcase(local.validationFormat) & ' ';

					variables.InvalidFormatMessage &= 'format';
				}

				return variables.InvalidFormatMessage;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getValidationStatusStruct"
			returnType	= "struct"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="isAutoValidate" required="no" type="boolean" default="yes" hint="" />
			<cfScript>
				local.value = getValue();
				local.ValidationModel = getValidationModel();
				local.ValidationModel.setValue(local.value);

				/* !!! AUTO VALIDATION !!! */
					// !!! do we need to ensure atleast one validation is defined if it does not allow nulls
					if
					(
						arguments.isAutoValidate
					AND	!local.ValidationModel.getCount()
					AND	!isAllowNullValue()
					AND	!isReadOnly()
					AND !isIdentity()
					)
						local.ValidationModel.Validation();
				/* END : AUTO VALIDATION */

				local.valStruct = local.ValidationModel.getStatusStruct();

				/* valid format */
					if(local.valStruct.isVal)
					{
						local.validationFormat = getValidationFormat();

						if(len(local.validationFormat))
						{
							if(isValid("variableName" , local.validationFormat))
							{
								local.isValidFormat = 1;
								switch(local.validationFormat)
								{
									case '?':
										break;

									default:local.isValidFormat = isValid(local.validationFormat , local.value);
								}

								if(!local.isValidFormat)
								{
									local.valStruct.isVal = 0;
									local.valStruct.isValFormat = 0;
								}
							}
						}
					}
				/* end */

				local.inputMetaData=
				{
					 name		= getName()
					,valueExists= len(local.value)
					,hasLength	= len(local.value)
					,isVal		= 1
					,isValFormat= 1
				};

				if(!local.valStruct.isVal)
				{
					if(!local.valStruct.isValFormat)
						local.valStruct.invalidMessage = getInvalidFormatMessage();
					else
						local.valStruct.invalidMessage = getInvalidMessage();

					structAppend(local.inputMetaData, local.valStruct);
				}

				return local.inputMetaData;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "setValidationFormat"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="ValidationFormat" required="yes" type="string" hint="" />
			<cfScript>
				variables.ValidationFormat = arguments.ValidationFormat;
				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getValidationFormat"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= "for types of validation formats, review ColdFusion documentation of the first argument of function isValid()"
			description	= ""
		>
			<cfScript>
				if( NOT structKeyExists(variables, "ValidationFormat") )
					return '';

				return variables.ValidationFormat;
			</cfScript>
		</cfFunction>
	<!--- end : Validation methods --->

	<cfFunction
		name		= "setRow"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Row" required="yes" type="Row" hint="" />
		<cfScript>
			variables.Row = arguments.Row;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getRow"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= "may return void"
		description	= ""
	>
		<cfScript>
			if( structKeyExists(variables, "Row") )
				return variables.Row;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getNotationRef"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="isSelectAsMode"	required="no"	type="boolean"	default="1"	hint="" />
		<cfScript>

			local.columnRef = '[#getColumnName()#]';

			local.Row = getRow();
			if(structKeyExists(local, "Row"))
			{
				local.DataMetaReader = local.Row.getDataMetaReader();

				if(structKeyExists(local, "DataMetaReader"))
					local.columnRef = '#local.DataMetaReader.getAlias()#.' & local.columnRef;
			}

			if(arguments.isSelectAsMode AND getName() != getColumnName())
				local.columnRef = '[' & getName() & '] = ' & local.columnRef;

			return local.columnRef;
		</cfScript>
	</cfFunction>


	<cfFunction
		name		= "getDataType"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(structKeyExists(variables, "DataType"))
				return variables.DataType;

			return 'string';
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getInputName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= "returns a naming convention"
		description	= ""
	>
		<cfScript>
			local.name = getName();
			local.Row = getRow();
			if(structKeyExists(local, 'Row'))
			{
				local.DataMetaReader = local.Row.getDataMetaReader();

				if(structKeyExists(local, 'DataMetaReader'))
					local.name = local.DataMetaReader.getTableName() & '.' & local.name;
			}

			return local.name;
		</cfScript>
	</cfFunction>

	<!--- file conventions --->
		<cfFunction
			name		= "isFileMode"
			returnType	= "boolean"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="yesNo" required="no" type="boolean" hint="" />
			<cfScript>
				if(structKeyExists(arguments, "yesNo"))
					variables.FileMode = arguments.yesNo;

				if(!structKeyExists(variables, "FileMode"))
					variables.FileMode = 0;

				return variables.FileMode;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "setFilePath"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="FilePath" required="yes" type="string" hint="" />
			<cfScript>
				isFileMode(1);
				variables.FilePath = arguments.FilePath;
				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getFilePath"
			returnType	= "string"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfif NOT structKeyExists(variables, "FilePath")>
				<cfThrow message="FilePath Not Yet Set" detail="Use the method 'setFilePath' in component '#getMetaData(this).name#'" />
			</cfif>
			<cfReturn variables.FilePath />
		</cfFunction>

		<cfFunction
			name		= "setFileUrl"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="FileUrl" required="yes" type="string" hint="" />
			<cfScript>
				variables.FileUrl = arguments.FileUrl;
				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getFileUrl"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				if( NOT structKeyExists(variables, "FileUrl") )
					return '';

				return variables.FileUrl;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "setFixedFileName"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="FixedFileName" required="yes" type="string" hint="" />
			<cfset variables.FixedFileName = arguments.FixedFileName />
			<cfReturn this />
		</cfFunction>

		<cfFunction
			name		= "getFixedFileName"
			returnType	= "string"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				if( NOT structKeyExists(variables, "FixedFileName") )
					return '';

				return variables.FixedFileName;
			</cfScript>
		</cfFunction>
	<!--- end --->

</cfComponent>