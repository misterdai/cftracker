<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	Extends		= "Transaction"
>

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

			local.PkColumn = local.Row.getIdentityColumn();
			local.pkColumnName = local.PkColumn.getColumnName();
			local.pkColumnValue = local.PkColumn.getValue();
			local.tableRef = local.Row.getDataMetaReader().getTableRef(0);

			/* query attributes */
				local.cfQueryStruct.name='local.delete';
				local.Datasource = getDatasource();
				if(structKeyExists(local, "Datasource"))
					local.cfQueryStruct.datasourceName = local.Datasource.getName();
			/* end */
		</cfScript>
		<cfQuery attributeCollection="#local.cfQueryStruct#">
			DELETE		#local.tableRef#
			WHERE		[#local.pkColumnName#] = <cfQueryParam value="#local.pkColumnValue#" cfsqltype="cf_sql_integer" />

			SELECT @@ROWCOUNT as rowEffectedCount
		</cfQuery>
		<cfset setResultQuery(local.delete) />
		<cfReturn val(local.delete.rowEffectedCount[1]) />
	</cfFunction>

</cfComponent>