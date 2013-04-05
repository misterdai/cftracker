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
			local.DataMetaReader = local.Row.getDataMetaReader();
			local.targetHash = local.DataMetaReader.getTargetHash();

			local.columnRefArray = arrayNew(1);
			local.ColumnArray = local.Row.getInsertReadyColumnArray();

			/* massage columns */
				for(local.x=arrayLen(local.ColumnArray); local.x GT 0; --local.x)
				{
					local.Column = local.ColumnArray[local.x];
					local.TempRow = local.Column.getRow();

					local.TempDataMetaReader = local.TempRow.getDataMetaReader();

					//don't update columns from other tables
					if( local.TempDataMetaReader.getTargetHash() NEQ local.targetHash )
					{
						arrayDeleteAt(local.ColumnArray, local.x);
						continue;
					}

					local.colRef = local.Column.getColumnName();
					arrayPrepend(local.columnRefArray, local.colRef);
				}
			/* end */

			local.columnRefList = arrayToList(local.columnRefArray);

			local.tableRef = local.DataMetaReader.getTableRef(0);

			/* query attributes */
				local.cfQueryStruct.name='local.insert';
				local.Datasource = getDatasource();
				if(structKeyExists(local, "Datasource"))
					local.cfQueryStruct.datasourceName = local.Datasource.getName();
			/* end */
		</cfScript>
		<cfQuery attributeCollection="#local.cfQueryStruct#">
			INSERT		#local.tableRef#
						(#local.columnRefList#)
			VALUES		(
					<cfLoop from="1" to="#arrayLen(local.ColumnArray)#" index="local.index">
						<cfScript>
							local.Column = local.ColumnArray[local.index];
							local.value = trim(local.Column.getValue());
						</cfScript>
						<cfif local.index GT 1 >,</cfif><cfQueryParam value="#local.value#" cfsqltype="cf_sql_#local.Column.getCfSqlType()#" />
					</cfLoop>
						)

			SELECT SCOPE_IDENTITY() AS keyValue
		</cfQuery>
		<cfScript>
			setResultQuery(local.insert);
			local.idValue = val(local.insert.keyValue[1]);

			if(local.idValue)
			{
				local.IdColumn = local.Row.getIdentityColumn();
				local.IdColumn.setValue(local.idValue);
				popJoins();
			}

			return local.idValue;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "popJoins"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.Row = getRow();
			local.IdColumn = local.Row.getIdentityColumn();

			if(structKeyExists(local, "IdColumn"))
			{
				local.idValue = local.IdColumn.getValue();

				/* set identity row for any joins */
					local.jArray = local.Row.getJoinArray();

					if(arrayLen(local.jArray))
					{
						local.notation = local.IdColumn.getNotationRef(0);

						for(local.jIndex=arrayLen(local.jArray); local.jIndex GT 0; --local.jIndex)
						{
							local.conditionArray = local.jArray[local.jIndex].ConditionModel.getConditions();

							/* condition loop */
								for(local.cIndex=arrayLen(local.conditionArray); local.cIndex GT 0; --local.cIndex)
								{
									local.conditionStruct = local.conditionArray[local.cIndex];

									if(local.conditionStruct.conditionType neq 'column')
										continue;

									local.ColumnA = local.conditionStruct.Column;
									local.ColumnB = local.conditionStruct.ColumnTo;

									if(local.ColumnA.getNotationRef(0) EQ local.notation)
									{
										local.ColumnB.setValue(local.idValue);
									}else if(local.ColumnB.getNotationRef(0) EQ local.notation)
									{
										local.ColumnA.setValue(local.idValue);
									}
								}
							/* end */
						}
					}
				/* end : id reporting for joins */
			}

			return this;
		</cfScript>
	</cfFunction>
</cfComponent>