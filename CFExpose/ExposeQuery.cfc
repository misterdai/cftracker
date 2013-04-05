<cfComponent
	Hint		= ""
	output		= "no"
	extends		= "ExposeVariable"
	accessors	= "yes"
>

	<cfProperty name="Var"	type="any" />
	<cfProperty name="CurrentRowNumber" type="numeric" />
	<cfset setVarValidateByTypeName('query') />

	<cfFunction
		name		= "getArrayOfStructs"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="columnList" required="no" type="string" hint="" />
		<cfScript>
			var local = structNew();

			local.returnArray=arrayNew(1);
			local.query = super.getVar();

			if(not structKeyExists(arguments,"columnList"))
				arguments.columnList = local.query.columnList;

			for(local.rowLoop=1; local.rowLoop LTE local.query.recordCount; ++local.rowLoop)//loop rows
			{
				local.valueArray	= arrayNew(1);
				local.columnArray	= listToArray(arguments.columnList);
				local.columnCount	= arrayLen(local.columnArray);

				arrayAppend(local.returnArray , rowToStruct(local.rowLoop, arguments.columnList));
			}

			Return local.returnArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "toArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="columnList"			required="no"	type="string"											hint="" />
		<cfArgument name="isFirstColumnNames"	required="no"	type="boolean"	default="no"							hint="" />
		<cfScript>
			var local = structNew();

			local.returnArray=arrayNew(1);
			local.query = super.getVar();

			if(not structKeyExists(arguments,"columnList"))
				arguments.columnList = local.query.columnList;

			if(arguments.isFirstColumnNames)
				arrayAppend(local.returnArray , listToArray(arguments.columnList));

			for(local.rowLoop=1; local.rowLoop LTE local.query.recordCount; ++local.rowLoop)//loop rows
			{
				local.valueArray	= arrayNew(1);
				local.columnArray	= listToArray(arguments.columnList);
				local.columnCount	= arrayLen(local.columnArray);
				for(local.colLoop=1; local.colLoop LTE local.columnCount; ++local.colLoop)//loop columns
				{
					local.columnName = local.columnArray[local.colLoop];
					arrayAppend(local.valueArray , local.query[local.columnName][local.rowLoop]);
				}
				arrayAppend(local.returnArray , local.valueArray);
			}

			Return local.returnArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "selectTopRows"
		returnType	= "query"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="max"		required="yes"	type="numeric" hint="" />
		<cfScript>
			var local = structNew();

			local.setQuery	= super.getVar();

			local.query			= queryNew(local.setQuery.columnList);
			local.columnArray	= listToArray(local.query.columnList);
			local.columnCount	= arrayLen(local.columnArray);

			if( local.setQuery.recordCount LTE max )
				return local.setQuery;

			for(local.x=1; local.x LTE local.setQuery.recordCount; ++local.x)
			{
				queryAddRow( local.query );

				for(local.y=1; local.y LTE local.columnCount; ++local.y)
				{
					local.column = local.columnArray[local.y];
					querySetCell( local.query , local.column , local.setQuery[local.column][local.x] , local.x );
				}

				if( local.query.recordCount GTE max )
					return local.query;
			}
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "deleteRow"
		returnType	= "ExposeQuery"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="row"		required="yes"	type="numeric"	hint="" />
		<cfScript>
			var local = structNew();

			local.setQuery	= super.getVar();

			local.query			= queryNew(local.setQuery.columnList);
			local.columnArray	= listToArray(local.setQuery.columnList);
			local.recordCount	= local.setQuery.recordCount;
			local.columnCount	= arrayLen(local.columnArray);

			for(local.x=1; local.x lte local.recordCount; ++local.x)
			{
				if( local.x neq arguments.row )
				{
					queryAddRow(local.query);
					for( local.columnLoop=1; local.columnLoop lte local.columnCount; ++local.columnLoop)
					{
						local.columnName = local.columnArray[local.columnLoop];
						querySetCell(local.query , local.columnName , local.setQuery[local.columnName][local.x]);
					}
				}
			}

			return setVar(local.query);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "columnsToArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="columnList" required="yes" type="string" hint="" />
		<cfScript>
			var local = structNew();

			local.query			= super.getVar();
			local.returnArray	= arrayNew(2);
			local.columnArray	= listToArray(arguments.columnList);
			local.columnCount	= arrayLen(local.columnArray);

			/* loop query rows */
				for(local.rowLoop=1; local.rowLoop LTE local.query.recordCount; ++local.rowLoop)
				{
					/* loop columns */
						for(local.columnLoop=1; local.columnLoop LTE local.columnCount; ++local.columnLoop)
						{
							local.columnName = local.columnArray[local.columnLoop];
							local.returnArray[local.rowLoop][local.columnLoop] = local.query[local.columnName][local.rowLoop];
						}
					/* end */
				}
			/* end */

			return local.returnArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "columnToArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="column"	required="yes"	type="string"	hint="" />
		<cfScript>
			var local = structNew();

			local.query=super.getVar();
			local.columnArray=columnsToArray(arguments.column);
			local.returnArray=arrayNew(1);
			local.arrayCount = arrayLen(local.columnArray);

			for(local.rowLoop=1; local.rowLoop LTE local.arrayCount; ++local.rowLoop)
				arrayAppend(local.returnArray , local.columnArray[local.rowLoop][1]);

			return local.returnArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "rowToStruct"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="row" required="no" type="numeric" default="1" hint="" />
		<cfArgument name="columnList" required="no" type="string" hint="" />
		<cfScript>
			var local = structNew();

			local.query			= super.getVar();
			local.returnStruct	= structNew();

			if(not structKeyExists(arguments,"columnList"))
				arguments.columnList = local.query.columnList;

			local.listCount		= listLen(arguments.columnList);

			for(local.x=1; local.x LTE local.listCount; ++local.x)
			{
				local.columnName=listGetAt(arguments.columnList, local.x);
				local.returnStruct[local.columnName] = local.query[local.columnName][arguments.row];
			}

			return local.returnStruct;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "appendQuery"
		returnType	= "ExposeQuery"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="query" required="yes" type="query" hint="" />
		<cfScript>
			var local = structNew();

			local.setQuery		= super.getVar();
			local.columns1		= arguments.query.columnList;
			local.returnQuery		= queryNew('');
			local.ExposeQuery		= createObject("component" , "ExposeQuery").setVar(arguments.query);

			local.columns0			= local.setQuery.columnList;
			local.columnNameArray	= listToArray(local.columns0);
			local.arrayCount		= arrayLen(local.columnNameArray);

			for( local.columnLoop=1; local.columnLoop lte local.arrayCount; ++local.columnLoop )
			{
				local.columnName = local.columnNameArray[local.columnLoop];

				if( listFindNoCase( local.columns1 , local.columnName ) )
				{
					local.columnOneArray = columnToArray(local.columnName);
					local.columnTwoArray = local.ExposeQuery.columnToArray(local.columnName);
					local.columnArray = CFMethods().arrayAppendArray(local.columnOneArray, local.columnTwoArray);

					queryAddColumn( local.returnQuery , local.columnName , local.columnArray );
				}else
					throw( 'Column name "#local.columnName#" could not be found in query that is being append onto' );
			}

			return setVar(local.returnQuery);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "renameColumn"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="fromName"	required="yes"	type="string" hint="" />
		<cfArgument name="toName"	required="yes"	type="string" hint="" />
		<cfScript>
			local.query = getVar();
			local.Columns = local.query.getColumnNames();
			local.orgColumnArray = duplicate(local.columns);

			local.nameFind = arrayFindNoCase(local.Columns, arguments.fromName);

			local.Columns[local.nameFind] = arguments.toName;
			local.query.setColumnNames(local.Columns);

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "deleteColumnDataTypes"
		returnType	= "ExposeQuery"
		Access		= "public"
		Output		= "no"
		Hint		= "When updating query rows, ColdFusion will validate the column data types and this can get in the way. Use this method to remove all query column data type limitations"
		Description	= "Create query clone with no column datatype definitions. IMPORTANT: Remember to set the query value to what is being returned as query is not automatically updated"
	>
		<cfScript>
			var local = structNew();

			local.query = getVar();

			/* change names */
				//this doesn't work cause cf still maintains an underlining reference to name/type
				/*
				local.Columns = local.query.getColumnNames();
				local.orgColumnArray = duplicate(local.columns);

				for(local.columnIndex=arrayLen(local.Columns); local.columnIndex GT 0; --local.columnIndex)
				{
					local.columnName = local.Columns[local.columnIndex];

					local.Columns[ local.columnIndex ] = local.columnName & '_changedName';

				}
				local.query.setColumnNames(local.Columns);
				*/
			/* end */

			/* clone query */
				local.nameArray = local.query.getColumnNames();
				local.newQuery = queryNew('');

				for(local.nameIndex=arrayLen(local.nameArray); local.nameIndex GT 0; --local.nameIndex)
				{
					local.columnName = local.nameArray[local.nameIndex];
					queryAddColumn(local.newQuery, local.columnName, local.query[local.columnName]);
				}

				setVar(local.newQuery);
			/* end */

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "deleteColumn"
		returnType	= "ExposeQuery"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="columnName"	required="yes"	type="string" hint="" />
		<cfScript>
			var local = structNew();
			var setQuery = getVar();

			local.columnList = arrayToList(setQuery.getColumnNames());
			local.columnList = listDeleteAt( local.columnList , listFindNoCase( local.columnList , arguments.columnName ) );

			local.columnListFormatted = "";
			local.columnArray = listToArray(local.columnList);
			for(local.i=1; local.i LTE arrayLen(local.columnArray); local.i=local.i+1)
			{
				local.index = local.columnArray[local.i];
				local.columnListFormatted = listAppend(local.columnListFormatted, "[" & local.index & "]");
			}
		</cfScript>
		<cfQuery name="local.query" dbtype="query">
			SELECT #local.columnListFormatted# FROM setQuery
		</cfQuery>
		<cfReturn setVar(local.query) />
	</cfFunction>

	<cfFunction
		Name		= "randomizeRows"
		returnType	= "ExposeQuery"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfScript>
			var local = structNew();

			local.setQuery		= super.getVar();
			local.columnArray	= listToArray(local.setQuery.ColumnList);
			local.columnCount	= arrayLen(local.columnArray);
			local.arrayCatalog	= arrayNew(1);

			local.newQuery = queryNew(local.setQuery.ColumnList);

			for(local.rowLoop=1; local.rowLoop LTE local.setQuery.recordCount; ++local.rowLoop)
				arrayAppend( local.arrayCatalog , local.rowLoop );

			for(local.rowLoop=1;local.rowLoop LTE local.setQuery.recordCount; ++local.rowLoop)
			{
				queryAddRow( local.newQuery );
				local.randRow = randRange(1, arrayLen(local.arrayCatalog) );
				local.targetRow = local.newQuery.recordCount;

				for(local.x=1; local.x LTE local.columnCount; ++local.x)
				{
					local.columnLoop = local.columnArray[local.x];
					querySetCell( local.newQuery , local.columnLoop , local.setQuery[local.columnLoop][ local.arrayCatalog[local.randRow] ] , local.targetRow );
				}

				arrayDeleteAt( local.arrayCatalog , local.randRow );
			}

			Return setVar(local.newQuery);
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "convert"
		returnType	= "ANY"
		Access		= "private"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="returnFormat"				required="yes"	type="variableName"	default="array"	hint="array,xml or csv" />
		<cfArgument name="isAutoXmlMode"			required="no"	type="boolean"		default="no"	hint="" />
		<cfArgument name="isXmlChildsAllAsArray"	required="no"	type="boolean"		default="yes"	hint="When true, XML columns that have child nodes will be analized to see if storing as an array is necessary (only stored as an array when two or more children are found to have the same name). When false, XML columns that have child nodes may need to be tested against for sub children when 'crawling' threw the child node structure. If you don't know the XML your dealing with, or it is dynamic then it is highly suggested that all children be stored as an array" />
		<cfArgument name="xmlColumnList"			required="no"	type="string"						hint="Any columns in query that are XML can be converted to struct format " />
		<cfScript>
			var local = structNew();

			local.setQuery = super.getVar();

			if( structKeyExists( arguments , 'xmlColumnList' ) )arguments.isAutoXmlMode = false;

			Switch (arguments.returnFormat)
			{
				Case "query":
				{
					Return local.setQuery;
					break;
				}
				Case "array":
				{
					local.return_obj = arrayNew(1);
					for( local.row_loop=1; local.row_loop LTE local.setQuery.recordCount; local.row_loop=local.row_loop+1 )
					{
						local.temp_struct	= structNew();
						local.columnList	= local.setQuery.columnList;
						local.columnCount	= listLen(local.columnList);
						for( local.columnNum=1; local.columnNum LTE local.columnCount; local.columnNum=local.columnNum+1 )
						{
							local.list_loop = listGetAt(local.columnList,local.columnNum);
							if(
								(
									arguments.isAutoXmlMode
								OR
									(
										structKeyExists( arguments , 'xmlColumnList' )
									AND
										listFindNoCase( arguments.xmlColumnList , local.list_loop )
									)
								)
							AND
								isXML(local.setQuery[local.list_loop][local.row_loop])
							)
								local.temp_struct[local.list_loop] = CFMethods().Conversions().XmlToStruct( local.setQuery[local.list_loop][local.row_loop] , arguments.isXmlChildsAllAsArray );
							else
								local.temp_struct[local.list_loop] = local.setQuery[local.list_loop][local.row_loop];
						}
						arrayAppend( local.return_obj , local.temp_struct );
					}
					break;
				}
				Case "xml":
				{
					Throw( "A query to xml mode has net yet been implemented" );
					break;
				};
				Case "csv":
				{
					Return toCsv();
					break;
				};
				default:
				{
					Throw("Invalid returnFormat" , "convert does not understand the type: #arguments.returnFormat#" );
					break;
				};
			};

			Return local.return_obj;
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "toCSV"
		returnType	= "string"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="delimiter"				required="no"	type="string"		hint="#chr(44)#" />
		<cfArgument name="textQualifier"			required="no"	type="string"	default="#chr(34)#" hint="" />
		<cfArgument name="titleArray"				required="no"	type="string"	default="" />
		<cfArgument name="isFirstRowColumnNames"	required="yes"	type="boolean"	default="yes" hint="" />
		<cfArgument name="columnList"				required="no"	type="string"		hint="" />
		<cfScript>
			var local = structNew();

			local.query = getVar();
			local.rowLoop			=	1;
			local.columnLoop		=	1;
			local.returnText		=	arrayNew(1);
			local.tempContent		=	"";

			if(!structKeyExists(arguments, 'columnList'))
				arguments.columnList = arrayToList(local.query.getColumnNames());

			/* set defaults */
				if( not structKeyExists(arguments , "textQualifier") )
					arguments.textQualifier="";

				if( not structKeyExists(arguments , "delimiter"))
					arguments.delimiter=chr(44);
			/* end */
			/* build CSV first row of titles */
				if(arguments.isFirstRowColumnNames)
				{
					if( structKeyExists(arguments , "titleArray") and isArray(arguments.titleArray) )
					{
						local.titleLen = arrayLen(arguments.titleArray);
						for( ; local.columnLoop lte local.titleLen; local.columnLoop=local.columnLoop+1 )
							local.tempContent = listAppend(local.tempContent , arguments.textQualifier & arguments.titleArray[local.columnLoop].title & arguments.textQualifier , arguments.delimiter);
					}else
					{
						local.columnArray = listToArray(arguments.columnList);
						local.columnCount = arrayLen(local.columnArray);
						for( ; local.columnLoop lte local.columnCount; local.columnLoop=local.columnLoop+1 )
							local.tempContent = listAppend( local.tempContent , arguments.textQualifier & local.columnArray[local.columnLoop] & arguments.textQualifier , arguments.delimiter );
					}
					arrayAppend( local.returnText , local.tempContent );
				}
			/* end */
			/* build CSV content */
				for( ; local.rowLoop lte query.recordCount; local.rowLoop=local.rowLoop+1 )
				{
					local.tempContent	=	"";
					local.columnLoop	=	1;

					if( structKeyExists(arguments , "titleArray") and isArray(arguments.titleArray) )
					{
						local.titleLen = arrayLen(arguments.titleArray);
						for( ; local.columnLoop lte local.titleLen; local.columnLoop=local.columnLoop+1 )
							local.tempContent = listAppend( local.tempContent , arguments.textQualifier & rePlaceNoCase( query[arguments.titleArray[local.columnLoop].name][local.rowLoop] , arguments.textQualifier , arguments.textQualifier&arguments.textQualifier , "all" ) & arguments.textQualifier , arguments.delimiter );
					}else
					{
						local.columnArray = listToArray(arguments.columnList);
						local.columnCount = arrayLen(local.columnArray);
						for( ; local.columnLoop lte local.columnCount; local.columnLoop=local.columnLoop+1 )
							local.tempContent = listAppend( local.tempContent , arguments.textQualifier & rePlaceNoCase( query[local.columnArray[local.columnLoop]][local.rowLoop] , arguments.textQualifier , arguments.textQualifier&arguments.textQualifier , "all" ) & arguments.textQualifier , arguments.delimiter );
					}
					arrayAppend(local.returnText , local.tempContent);
				}
			/* end */
			return arrayToList( returnText , chr(10) );
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "columnValueToRowNumberArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="columnName"	required="yes"	type="string"				hint="" />
		<cfArgument name="value"		required="yes"	type="string"				hint="" />
		<cfArgument name="maxRows"		required="yes"	type="numeric"	default="0"	hint="" />
		<cfScript>
			var local = structNew();

			local.query		= getVar();
			local.array		= arrayNew(1);

			if(local.query.recordCount)
				for(local.currentRow=local.query.recordCount; local.currentRow GTE 1; --local.currentRow)
					if(local.query[arguments.columnName][local.currentRow] EQ arguments.value)
					{
						arrayAppend(local.array, local.currentRow);

						if(arguments.maxRows AND arrayLen(local.array) GTE arrayLen(local.array))
							break;
					}

			return local.array;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getRow"
		returnType	= "query"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="rowNumber" required="yes" type="numeric" hint="" />
		<cfScript>
			var local = structNew();

			local.query		= getVar();
			local.newQuery	= queryNew(local.query.columnList);

			if(arguments.rowNumber AND arguments.rowNumber LTE local.query.recordCount)
			{
				local.columnArray = listToArray(local.query.columnList);

				queryAddRow(local.newQuery);

				/* column loop */
					for(local.currentColumn=arrayLen(local.columnArray); local.currentColumn GT 0; --local.currentColumn)
					{
						local.columnName = local.columnArray[local.currentColumn];
						querySetCell(local.newQuery, local.columnName, local.query[local.columnName][arguments.rowNumber], 1);
					}
				/* end */
			}

			return local.newQuery;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "appendToColumn"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= "adds string value to all rows of a column"
		description	= ""
	>
		<cfArgument name="string"		required="yes"	type="string"				hint="" />
		<cfArgument name="columnName"	required="yes"	type="string"				hint="" />
		<cfArgument name="isPrepend"	required="no"	type="boolean"	default="0"	hint="here only avoid duplicate logic for function prependToColumn" />
		<cfScript>
			var local = structNew();

			local.query = getVar();

			if(arguments.isPrepend)
				for(local.x=local.query.recordCount; local.x GT 0; local.x=local.x-1)
					querySetCell(local.query, arguments.columnName, arguments.string&local.query[arguments.columnName][local.x], local.x);
			else
				for(local.x=local.query.recordCount; local.x GT 0; local.x=local.x-1)
					querySetCell(local.query, arguments.columnName, local.query[arguments.columnName][local.x]&arguments.string, local.x);

			setVar(local.query);

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "prependToColumn"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= "adds string value to the begining of all rows of a column"
		description	= ""
	>
		<cfArgument name="string"		required="yes"	type="string"				hint="" />
		<cfArgument name="columnName"	required="yes"	type="string"				hint="" />
		<cfScript>
			arguments.isPrepend = 1;
			return appendToColumn(argumentCollection=arguments);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getColumnMaxLength"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="columnName" required="yes" type="string" hint="" />
		<cfScript>
			local.query = getVar();
			local.length=0;

			for(local.x=1; local.x LTE local.query.recordCount; ++local.x)
			{
				local.len = len(local.query[arguments.columnName][local.x]);
				if(local.len GT local.length)
					local.length = local.len;
			}

			return local.length;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "set"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="columnName"	required="yes"	type="string" hint="" />
		<cfArgument name="value"		required="yes"	type="string" hint="" />
		<cfArgument name="rowNumber"	required="no"	type="numeric" hint="" />
		<cfScript>
			if(!structKeyExists(arguments, 'rowNumber'))
				arguments.rowNumber = getCurrentRowNumber();

			local.query = getVar();

			while(arguments.rowNumber GT local.query.recordCount)
				queryAddRow(local.query);

			local.query[arguments.columnName][arguments.rowNumber] = arguments.value;
			//setVariable(4,local.query[arguments.columnName][arguments.rowNumber]);
			//local.success = querySetCell(local.query, arguments.columnName, arguments.value, arguments.rowNumber);//depr: does not sql queries with sql datatypes

			setVar(local.query);

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setRowByStruct"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="struct" required="yes" type="struct" hint="" />
		<cfArgument name="rowNumber" required="no" type="numeric" hint="" />
		<cfScript>
			local.query = getVar();
			local.colArray = listToArray(local.query.columnList);

			for(local.colIndex=arrayLen(local.colArray); local.colIndex GT 0; --local.colIndex)
			{
				local.columnName = local.colArray[local.colIndex];

				if(!structKeyExists(arguments.struct, local.columnName))
					continue;

				local.value = arguments.struct[local.columnName];

				arguments.columnName = local.columnName;
				arguments.value = local.value;

				//local.query[local.columnName][getCurrentRowNumber()] = local.value;
				set(argumentCollection=arguments);
			}

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "gotoNextRow"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			setCurrentRowNumber( getCurrentRowNumber()+1 );
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setCurrentRowNumber"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="CurrentRowNumber" required="yes" type="numeric" hint="" />
		<cfScript>
			variables.CurrentRowNumber = arguments.CurrentRowNumber;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getCurrentRowNumber"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( NOT structKeyExists(variables, "CurrentRowNumber") )
				return getVar().currentRow;

			return variables.CurrentRowNumber;
		</cfScript>
	</cfFunction>
<!---
	<cfFunction
		name		= "sortByColumn"
		returnType	= "query"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "will only work for columns from database"
	>
		<cfArgument name="columnName"	required="yes"	type="string"					hint="" />
		<cfArgument name="isAsc"		required="no"	type="boolean"	default="yes"	hint="" />
		<cfScript>
			local.query = getVar();
			local.query.sort(local.query.findColumn(arguments.columnName), arguments.isAsc);
			return local.query;
		</cfScript>
	</cfFunction>
--->
</cfComponent>