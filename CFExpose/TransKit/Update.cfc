<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	Extends		= "Transaction"
	accessors	= "yes"
>

	<cfProperty name="Row"				type="Row" />
	<cfProperty name="ResultQuery"		type="query" />
	<cfProperty name="ConditionModel"	type="ConditionModel" />
	<cfProperty name="Datasource"		type="Datasource" />
	<cfProperty name="syntax"			type="string" />

	<cfFunction
		name		= "execute"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			var local = structNew();

			local.Row = getRow();
			local.DataMetaReader = local.Row.getDataMetaReader();

			local.columnNameList = local.Row.getEditableColumnNameList();
			local.PkColumn = local.Row.getIdentityColumn();
			local.pkColumnName = local.PkColumn.getName();
			local.pkColumnValue = local.PkColumn.getValue();

			local.columnNameArray = listToArray(local.columnNameList);
			local.ColumnArray = arrayNew(1);

			for(local.x=arrayLen(local.columnNameArray); local.x GT 0; --local.x)
			{
				local.name = local.columnNameArray[local.x];
				local.Column = local.Row.getByName(local.name);
				local.TempRow = local.Column.getRow();

				if(!structKeyExists(local, "TempRow") OR local.Column.isIdentity())
					continue;

				local.TempDataMetaReader = local.TempRow.getDataMetaReader();

				//don't update columns from other tables
				if( local.TempDataMetaReader.getTargetHash() NEQ local.DataMetaReader.getTargetHash() )
					continue;

				arrayAppend(local.ColumnArray, local.Column);
			}

			local.tableRef = local.DataMetaReader.getTableRef(0);

			/* query tag attributes */
				local.queryAttrs.name = 'local.update';
				local.Datasource = getDatasource();
				if(structKeyExists(local, "Datasource"))
					local.queryAttrs.datasource = local.Datasource.getName();
			/* end */
		</cfScript>
		<cfQuery attributeCollection="#local.queryAttrs#">
			<cfSaveContent Variable="variables.syntax">
				UPDATE		#local.tableRef#
				SET		<cfLoop from="1" to="#arrayLen(local.ColumnArray)#" index="local.index">
							<cfScript>
								local.Column = local.ColumnArray[local.index];
								local.value = trim(local.Column.getValue());
								local.null = !len(local.value);
								local.cfsqltype = 'cf_sql_' & local.Column.getCfSqlType();
							</cfScript>
							<cfif local.index GT 1 >,</cfif>
							[#local.Column.getColumnName()#] = <cfQueryParam value="#local.value#" null="#local.null#" cfsqltype="#local.cfsqltype#" />
						</cfLoop>
				WHERE		#local.PkColumn.getColumnName()# = <cfQueryParam value="#local.pkColumnValue#" cfsqltype="cf_sql_integer" />

				SELECT @@ROWCOUNT as rowEffectedCount
			</cfSaveContent>
			#variables.syntax#
		</cfQuery>
		<cfset setResultQuery(local.update) />
		<cfReturn val(local.update.rowEffectedCount[1]) />
	</cfFunction>

</cfComponent>