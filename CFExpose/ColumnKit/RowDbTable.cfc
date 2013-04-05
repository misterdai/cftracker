<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	extends		= "Row"
	accessors	= "yes"
	Column		= "ColumnDbTable"
>

	<cfProperty name="TableName"			type="string" />
	<cfProperty name="SchemaName"			type="string" />
	<cfProperty name="CatalogName"			type="string" />

	<!--- parent --->
<!---
		<cfProperty name="nameArray"			type="array" />
		<cfProperty name="elementArray"			type="array" />
		<cfProperty name="IdentityColumnName"	type="string" />
		<cfProperty name="IdentityColumnValue"	type="string" />
		<cfProperty name="DataMetaReader" type="DataMetaReader" />
		<cfProperty name="joinArray"			type="array" />
--->
	<!--- end --->

	<cfFunction
		name		= "getIdentityColumnName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(structKeyExists(variables, 'IdentityColumnName'))
				return variables.IdentityColumnName;

			/* see if the super can dig it up */
				variables.IdentityColumnName = super.getIdentityColumnName();

				if(len(variables.IdentityColumnName))
					return variables.IdentityColumnName;
			/* end */

			/* lookup by table */
				local.DataMetaReader = getDataMetaReader();
				local.identityColumnName = local.DataMetaReader.getIdentityColumnName();

				local.Column = getByName(local.identityColumnName);
				if(structKeyExists(local, "Column"))
				{
					variables.identityColumnName = local.identityColumnName;
					return variables.identityColumnName;
				}

				if(len(local.identityColumnName))
				{
					setColumnByAttributes(name=local.identityColumnName, isIdentity=1);
					variables.identityColumnName = local.identityColumnName;
					return variables.identityColumnName;
				}
			/* end */

			return '';
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

			local.tableName = getTableName();

			if(len(local.tableName))
			{
				local.initStruct.tableName = local.tableName;
				local.initStruct.schemaName = getSchemaName();
				local.initStruct.catalogName = getCatalogName();
				variables.DataMetaReader = new('DataMetaDbTableReader',local.initStruct);
				variables.DataMetaReader.setRow(this);
				return variables.DataMetaReader;
			}
		</cfScript>
	</cfFunction>

</cfComponent>