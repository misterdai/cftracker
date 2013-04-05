<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	Extends		= "Transaction"
	accessors	= "yes"
>

	<cfProperty name="Row"				type="Row" />
	<cfProperty name="ResultQuery"		type="query" />
	<cfProperty name="ConditionSeries"		type="ConditionSeries" />

	<cfProperty name="ColumnSort"		type="CFExpose.ColumnKit.ColumnSort" />
	<cfProperty name="SummaryMode"		type="boolean" />
	<cfProperty name="pagingAttributes"	type="struct" />
	<cfProperty name="MaxResults"		type="numeric" />

	<cfFunction
		name		= "setQuery"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Query" required="yes" type="query" hint="" />
		<cfScript>
			variables.Query = arguments.Query;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getQuery"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( structKeyExists(variables, "Query") )
				return variables.Query;
		</cfScript>
		<cfThrow message="Query Not Yet Set" detail="Use the method 'setQuery' in component '#getMetaData(this).name#'" />
	</cfFunction>

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

			local.EntityReader = new CFExpose.ColumnKit.DataMetaEntityReader();
			local.query = getQuery();
			local.Row = getRow();
			local.columnNameList = local.Row.getNameList();

			local.PkColumn = local.Row.getIdentityColumn();
			local.rowId = 0;

			if(structKeyExists(local, "PkColumn"))
				local.rowId = local.PkColumn.getValue();

			if(isSummaryMode())
			{
				local.columnNameList = local.PkColumn.getName();

				local.summaryList = local.Row.getSummaryColumnNameList();

				if(len(local.summaryList))
					local.columnNameList = listAppend(local.columnNameList,local.summaryList);
			}

			local.maxResults = getMaxResults();

			local.queryAttributes.name='local.execute';
			local.queryAttributes.dbtype='query';

			if( local.maxResults )
				local.queryAttributes.maxRows = local.maxResults;

			local.ColumnSort = getColumnSort();
			local.ConSeries = getConditionSeries();
		</cfScript>
		<cfQuery name="local.execute" dbtype="query">
				SELECT		#local.columnNameList#
				FROM		[local].[query]
				WHERE		0 = 0
				<cfif structKeyExists(local, "ConSeries") >
					<cfset local.conArray = local.ConSeries.getArray() />
					<cfLoop array="#local.conArray#" index="local.series">
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
			<cfif len(local.rowId) AND local.rowId NEQ 0 >
				AND			#local.EntityReader.getColumnRef(local.PkColumn, 0)# = <cfQueryParam value="#local.rowId#" />
			</cfif>
			<cfif structKeyExists(local, "ColumnSort") >
				ORDER BY #local.ColumnSort.getString()#
			</cfif>
		</cfQuery>
		<cfScript>
			if( isPagingEnabled() )
			{
				local.pageCount = 1;
				local.pagingAttrs = getPagingAttributes();

				if(local.maxResults)
					local.pageCount = ceiling(local.execute.recordCount / local.maxResults);

				queryAddColumn(local.execute, local.pagingAttrs.totalRowCountColumnName, arrayNew(1));
				queryAddColumn(local.execute, local.pagingAttrs.totalPageCountColumnName, arrayNew(1));
				queryAddColumn(local.execute, local.pagingAttrs.rowNumberColumnName, arrayNew(1));

				for(local.currentRow=1; local.currentRow LTE local.execute.recordCount; ++local.currentRow)
				{
					querySetCell(local.execute, local.pagingAttrs.totalRowCountColumnName, local.execute.recordCount, local.currentRow);
					querySetCell(local.execute, local.pagingAttrs.totalPageCountColumnName, local.pageCount, local.currentRow);
					querySetCell(local.execute, local.pagingAttrs.rowNumberColumnName, local.currentRow, local.currentRow);
				}
			}

			setResultQuery(local.execute);
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "isPagingEnabled"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return structKeyExists(variables, "pagingAttributes");
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setMaxResults"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="MaxResults" required="yes" type="numeric" hint="" />
		<cfScript>
			variables.MaxResults = arguments.MaxResults;
			setPagingAttributes();
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getMaxResults"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( NOT structKeyExists(variables, "MaxResults") )
				return 0;

			return variables.MaxResults;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getPagingAttributes"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return variables.pagingAttributes;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setPagingAttributes"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="currentPage"				required="no"	type="numeric"		hint="default=1" />
		<cfArgument name="TotalRowCountColumnName"	required="no"	type="variableName"	hint="default=TotalRowCount" />
		<cfArgument name="rowNumberColumnName"		required="no"	type="variableName" hint="default=RowNumber" />
		<cfArgument name="totalPageCountColumnName"	required="no"	type="variableName"	hint="default=TotalPageCount" />
		<cfArgument name="maxResults"				required="no"	type="numeric"		hint="" />
		<cfScript>
			CFMethods().structDeleteNulls(arguments);

			if(!structKeyExists(variables, 'pagingAttributes'))
			{
				variables.pagingAttributes.currentPage = 1;
				variables.pagingAttributes.TotalRowCountColumnName = 'TotalRowCount';
				variables.pagingAttributes.rowNumberColumnName = 'RowNumber';
				variables.pagingAttributes.totalPageCountColumnName = 'totalPageCount';
			}

			if(structKeyExists(arguments, "maxResults"))
			{
				setMaxResults(arguments.maxResults);
				structDelete(arguments, "maxResults");
			}

			structAppend(variables.pagingAttributes, arguments);

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setColumnSort"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="ColumnSort" required="yes" type="CFExpose.ColumnKit.ColumnSort" hint="" />
		<cfScript>
			variables.ColumnSort = arguments.ColumnSort;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getColumnSort"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( structKeyExists(variables, "ColumnSort") )
				return variables.ColumnSort;
		</cfScript>
	</cfFunction>

</cfComponent>