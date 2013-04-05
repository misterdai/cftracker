<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	extends		= "Column"
	accessors	= "yes"
>

	<cfProperty name="Row"					type="Row" />
	<cfProperty name="name"					type="string" />
	<cfProperty name="columnName"			type="string" />
	<cfProperty name="value"				type="string" />
	<cfProperty name="label"				type="string" />
	<cfProperty name="displayValue"			type="string" />
	<cfProperty name="defaultValue"			type="string" />
	<cfProperty name="ReadOnly"				type="boolean" />
	<cfProperty name="hint"					type="string" />
	<cfProperty name="maxLength"			type="numeric" />
	<cfProperty name="Identity"				type="boolean" />
	<cfProperty name="DataType"				type="string" />
	<cfProperty name="CfSqlType"			type="string" />
	<cfProperty name="DataMetaReader"		type="DataMetaReader" />

	<cfProperty name="ValidationModel"		type="ValidationModel" />
	<cfProperty name="ValidationFormat"		type="string" />
	<cfProperty name="InvalidMessage"		type="string" />
	<cfProperty name="InvalidFormatMessage"	type="string" />
	<cfProperty name="allowNullValue"		type="boolean" />

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

			local.ExpEntity = getDataMetaReader().getExposedEntity();
			local.name = getName();

			if( local.ExpEntity.isPropertyDefined(local.name) )
			{
				local.propTag = local.ExpEntity.getPropertyByName(local.name);

				if(structKeyExists(local.propTag, "type"))
				{
					variables.DataType = local.propTag.type;
					return variables.DataType;
				}else if(structKeyExists(local.propTag, "ormtype"))
				{
					variables.DataType = local.propTag.ormtype;
					return variables.DataType;
				}
			}

			return 'string';
		</cfScript>
	</cfFunction>

</cfComponent>
