<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	extends		= "Column"
	accessors	= "yes"
>

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

			local.sqlType = '';

			local.Dmr = getDataMetaReader();

			if(structKeyExists(local, "Dmr"))
			{
				local.colMap = local.Dmr.getColumnMap( getColumnName() );
				local.sqlType = local.colMap.type_name;
			}

			switch(local.sqlType)
			{
				case 'bit':
					variables.DataType = 'boolean';
					break;

				default:
					variables.DataType = 'string';
			}

			return variables.DataType;
		</cfScript>
	</cfFunction>

</cfComponent>
