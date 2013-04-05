<cfComponent
	Description		= ""
	Hint			= ""
	output			= "no"
	Extends			= "CFExpose.ComponentExtension"
	accessors		= "yes"
>

	<cfProperty name="Column" type="Column" />
	<cfProperty name="Type" type="string" />

	<cfFunction
		name		= "getOutput"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.Column = getColumn();
			local.value = local.Column.getValue();

			switch(getType())
			{
				case 'yesNo':if(!isBoolean(local.value))break;
					return yesNoFormat(local.value);

				case 'dateTimeShort':
					if(!isDate(local.value))break;
					return dateFormat(local.value,'mm/dd') & ' ' & timeFormat(local.value,'hh:mm tt');

				case 'decimal':
					if(!isNumeric(local.value))break;
					return decimalFormat(local.value);

				case 'deserializeJson':
					if(isJson(local.value))
						return CFMethods().dump(deserializeJson(local.value));

				default:return local.value;
			}
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getType"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(!structKeyExists(variables, 'type'))
			{
				local.Column = getColumn();
				local.Row = local.Column.getRow();
				local.DataMetaReader = local.Row.getDataMetaReader();
				local.dataType = '';

				if(structKeyExists(local, "DataMetaReader"))
				{
					local.MetaColumn = local.DataMetaReader.getColumnByName(local.Column.getName());
					local.dataType = local.MetaColumn.getDataType();
				}

				switch(local.dataType)
				{
					case 'boolean':
						variables.type='YesNo';
						break;

					default:variables.type='string';
				}
			}

			return variables.type;
		</cfScript>
	</cfFunction>

</cfComponent>