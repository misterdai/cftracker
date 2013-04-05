<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	Extends		= "Query"
	accessors	= "yes"
>

	<cfProperty name="Row"					type="CFExpose.ColumnKit.Row" />
	<cfProperty name="ResultQuery"			type="query" />
	<cfProperty name="ConditionSeries"		type="ConditionSeries" />
	<!---
	<cfProperty name="ConditionModel"		type="ConditionModel" />
	--->
	<cfProperty name="ExecutedQueryString"	type="string" />
	<cfProperty name="ColumnSort"			type="CFExpose.ColumnKit.ColumnSort" />
	<cfProperty name="SummaryMode"			type="boolean" />
	<cfProperty name="pagingAttributes"		type="struct" />
	<cfProperty name="MaxResults"			type="numeric" />

	<cfFunction
		name		= "isSummaryMode"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="yesNo" required="no" type="boolean" hint="" />
		<cfScript>
			if(structKeyExists(arguments, "yesNo"))
				variables.SummaryMode = arguments.yesNo;

			if(!structKeyExists(variables, "SummaryMode"))
				variables.SummaryMode = 0;

			return variables.SummaryMode;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setSummaryMode"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="SummaryMode" required="yes" type="boolean" hint="" />
		<cfset variables.SummaryMode = arguments.SummaryMode />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "execute"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			var local = {};

			local.Row = getRow();

			local.DataMetaReader = local.Row.getDataMetaReader();
			local.nameList = local.Row.getNameList();

			local.ConditionSeries = getConditionSeries();
			local.JoinArray = local.Row.getJoinArray();

			/* pk column assignment */
				local.PkColumn = local.Row.getIdentityColumn();

				local.rowId = 0;

				if(isSummaryMode())
				{
					local.nameList = local.Row.getSummaryColumnNameList();

					for(local.jIndex=arrayLen(local.JoinArray); local.jIndex GT 0; --local.jIndex)
					{
						local.TempRow = local.JoinArray[local.jIndex].Row;
						local.TempIdentColumn = local.TempRow.getIdentityColumn();
						local.tempPkName = local.TempIdentColumn.getName();

						local.isAddColumn = !listFindNoCase(local.nameList, local.tempPkName);
						local.isAddColumn = local.isAddColumn AND structKeyExists(local, "TempIdentColumn");

						if(local.isAddColumn)
						{
							local.Row.setColumn(local.TempIdentColumn);
							local.nameList = listAppend(local.nameList, local.tempPkName);
						}
					}
				}

				if(structKeyExists(local, "PkColumn"))
				{
					local.pkColName = local.PkColumn.getName();
					local.rowId = local.PkColumn.getValue();

					if(!listFindNoCase(local.nameList, local.pkColName))
						local.nameList = listAppend(local.nameList, local.pkColName);
				}
			/* end */

			/* proper column names */
				local.selectColumnNameArray = arrayNew(1);
				local.columnNameArray = listToArray(local.nameList);

				for(local.x=arrayLen(local.columnNameArray); local.x GT 0; --local.x)
				{
					local.name = local.columnNameArray[local.x];
					local.TempCol = local.Row.getByName(local.name);
					local.TempRow = local.TempCol.getRow();

					local.isSelectColumn=
					(
						structKeyExists(local, "TempRow")
/*
					AND	(
							isInstanceOf(local.TempCol, 'CFExpose.ColumnKit.ColumnDbTable')
						OR	isInstanceOf(local.TempCol, 'CFExpose.ColumnKit.ColumnEntity')
						)
*/
					);

					if(local.isSelectColumn)
						arrayAppend(local.selectColumnNameArray, local.TempCol.getNotationRef());
				}

				local.columnNameList = arrayToList(local.selectColumnNameArray);
			/* end */

			local.maxResults = getMaxResults();
			local.ColumnSort = getColumnSort();

			local.tableRef = local.DataMetaReader.getTableRef();

			/* query attributes */
				local.cfQueryStruct.name='local.execute';
				local.Datasource = getDatasource();
				if(structKeyExists(local, "Datasource"))
					local.cfQueryStruct.datasourceName = local.Datasource.getName();
			/* end */
		</cfScript>
		<cfQuery attributeCollection="#local.cfQueryStruct#">
			<cfSaveContent Variable="local.queryString">
					SELECT	<cfif isPagingEnabled() >
								#getPagingAttributes().rowNumberColumnName#=Row_Number() OVER(ORDER BY <cfif structKeyExists(local, "ColumnSort") >#local.ColumnSort.getString()#<cfElse>ISNULL(99,1)</cfif>),
							</cfif>
							<cfif len(local.columnNameList) >
								#local.columnNameList#
							<cfElse>
								*
							</cfif>
					FROM		#local.tableRef# WITH (NOLOCK)
				<cfLoop from="1" to="#arrayLen(local.JoinArray)#" index="local.eIndex">
					<cfScript>
						local.jType = uCase(local.JoinArray[local.eIndex].joinType);
						local.jConditions = local.JoinArray[local.eIndex].ConditionModel.getArray();

						local.TempDataReader = local.JoinArray[local.eIndex].Row.getDataMetaReader();
						local.joinTableRef = local.TempDataReader.getTableRef();
					</cfScript>
					#local.jType# JOIN		#local.joinTableRef# WITH (NOLOCK)
					ON			0 = 0
					<cfLoop array="#local.jConditions#" index="local.cIndex">
						<cfSwitch expression="#local.cIndex.conditionType#">
							<cfCase value="columnValue">
					AND			[#local.cIndex.name#] = <cfQueryParam value="#local.cIndex.value#" />
							</cfCase>
							<cfCase value="value">
					AND			<cfQueryParam value="#local.cIndex.value#" /> = <cfQueryParam value="#local.cIndex.valueTo#" />
							</cfCase>
							<cfCase value="column">
					AND			#local.cIndex.Column.getNotationRef(0)# = #local.cIndex.ColumnTo.getNotationRef(0)#
							</cfCase>
							<cfCase value="Row">
								<cfThrow message="Row conditions has not yet been properly implemented" detail="" />
							</cfCase>
							<cfDefaultCase>
								<cfThrow
									message	= "Invalid Condition Type of '#local.cIndex.conditionType#'"
									detail	= "Valid Types are: value and column"
								/>
							</cfDefaultCase>
						</cfSwitch>
					</cfLoop>
				</cfLoop>
					WHERE		0 = 0
				<cfif structKeyExists(local, "ConditionSeries") >
					<cfset local.conSeriesArray = local.ConditionSeries.getArray() />
					<cfLoop array="#local.conSeriesArray#" index="local.series">
						<cfset local.conditions = local.series.ConditionModel.getArray() />
						<cfif arrayLen(local.conditions) >
							#local.series.compoundType#
							(
								<cfLoop from="1" to="#arrayLen(local.conditions)#" index="local.cIndex">
									<cfset local.condition = local.conditions[local.cIndex] />
									<cfSwitch expression="#local.condition.conditionType#">
										<cfCase value="columnValue">
											<cfset local.TempRow = local.condition.Column.getRow() />
											<cfif structKeyExists(local, 'TempRow') >
												<cfScript>
													local.value = local.condition.Column.getValue();
													local.andOr = '';

													switch(local.condition.matchType)
													{
														case 'like':
															local.matchType = 'LIKE';
															local.value = '%' & local.value & '%';
															break;

														case 'likeleft':
															local.matchType = 'LIKE';
															local.value = '%' & local.value;
															break;

														case 'likeright':
															local.matchType = 'LIKE';
															local.value = local.value & '%';
															break;

														default:
															local.matchType = '=';
													}

													if( local.cIndex GT 1 )
														local.andOr = local.condition.compoundType;
												</cfScript>
													#local.andOr#	#local.condition.Column.getNotationRef(0)# #local.matchType# <cfQueryParam value="#local.value#" />
											</cfif>
										</cfCase>
										<cfCase value="Row">
											<cfThrow message="Row conditions has not yet been properly implemented" detail="" />
										</cfCase>
									</cfSwitch>
								</cfLoop>
							)
						</cfif>
					</cfLoop>
				</cfif>
				<cfif isNumeric(local.rowId) AND local.rowId >
					AND			#local.PkColumn.getNotationRef(0)# = <cfQueryParam value="#local.rowId#" cfsqltype="cf_sql_integer" />
				</cfif>
				<cfif !isPagingEnabled() AND structKeyExists(local, "ColumnSort") AND local.ColumnSort.getDefinitionCount() >
					ORDER BY #local.ColumnSort.getString()#
				</cfif>
			</cfSaveContent>
			<cfif isPagingEnabled() >
				<cfScript>
					local.maxResults	= getMaxResults();
					local.pagingAttrs	= getPagingAttributes();
					local.endRow = (local.maxResults * local.pagingAttrs.currentPage);
					local.startRow = local.endRow - local.maxResults + 1;
				</cfScript>
				WITH RawResults AS
				(
					#local.queryString#
				)

				SELECT	*
						,#local.pagingAttrs.TotalRowCountColumnName#=(SELECT count(*) FROM RawResults)
						,#local.pagingAttrs.totalPageCountColumnName#=CEILING((SELECT CAST(count(*) AS DECIMAL) / <cfQueryParam value="#local.maxResults#" cfsqltype="cf_sql_integer" /> FROM RawResults))
				FROM	RawResults
				WHERE	#local.pagingAttrs.rowNumberColumnName#
				BETWEEN	<cfQueryParam value="#local.startRow#" cfsqltype="cf_sql_integer" list="no" null="no" />
				AND		<cfQueryParam value="#local.endRow#" cfsqltype="cf_sql_integer" />
			<cfElse>
				#local.queryString#
			</cfif>
		</cfQuery>
		<cfScript>
			setExecutedQueryString(local.queryString);
			setResultQuery(local.execute);
			return this;
		</cfScript>
	</cfFunction>

</cfComponent>