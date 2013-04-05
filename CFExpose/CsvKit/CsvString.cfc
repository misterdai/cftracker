<cfComponent
	Hint		= "directory based functionality. Set directory once, perform all actions"
	Output		= "no"
	extends		= "CFExpose.ComponentExtension"
	accessors	= "yes"
>

	<cfProperty name="CsvConfig"			type="CsvConfig" />
	<cfProperty name="CsvString"			type="string" />
	<cfProperty name="HeaderRow"			type="string" />
	<cfProperty name="ColumnNameArray" type="array" />
	<cfScript>
		variables.columnNameArray = arrayNew(1);
	</cfScript>

	<cfFunction
		name		= "getCsvConfig"
		returnType	= "CsvConfig"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(!structKeyExists(variables, "CsvConfig"))
				variables.CsvConfig = new CsvConfig();

			return variables.CsvConfig;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getStructOfArrays"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.structOfArrays = structNew();
			local.Converts = CFMethods().Conversions();
			local.CsvConfig = getCsvConfig();

			local.delimiter = local.CsvConfig.getValueDelimiter();
			local.rowDelimiters = local.CsvConfig.getRowDelimiters();
			local.textQualifier = local.CsvConfig.getTextQualifier();
			local.maxRows = local.CsvConfig.getMaxRowCount();

			if( NOT len(local.textQualifier) )
				structDelete(local,"textQualifier");

			local.columnNameArray = getColumnNameArray();
			for(local.aIndex=arrayLen(local.columnNameArray); local.aIndex > 0; --local.aIndex)
			{
				local.columnName = local.columnNameArray[local.aIndex];
				local.structOfArrays[local.columnName] = arrayNew(1);
			}

			local.csvString = getCsvString();

			/* Loop Rows */
				/* loop variable setup */
					local.rowLoop = 1;

					local.rowCount = listLen(local.csvString, local.rowDelimiters);
				/* end */

				for( ; local.rowLoop LTE local.rowCount; ++local.rowLoop )
				{
					local.row = trim(listGetAt(local.csvString, local.rowLoop, local.rowDelimiters));

					if(
						len(local.row)
					AND
						left(local.row,1) neq chr(35)
					)
					{
						local.rowString = listGetAt(local.csvString, local.rowLoop, local.rowDelimiters);
						if(structKeyExists(local, 'textQualifier'))
							local.rowArray = local.Converts.qualifiedListToArray(local.rowString, local.delimiter, local.textQualifier );
						else
							local.rowArray = listToArray(local.rowString, local.delimiter);

						for( local.j=1; local.j LTE arrayLen(local.rowArray); ++local.j )
						{
							local.columnName = local.columnNameArray[local.j];
							arrayAppend(local.structOfArrays[local.columnName], local.rowArray[local.j]);
						}
					}

					if(structKeyExists(local, "maxRows") AND local.maxRows LTE local.rowLoop)
						break;
				}
			/* end: loop rows */

			return local.structOfArrays;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "softCleanseColumnName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="columnName" required="yes" type="string" hint="" />
		<cfScript>
			arguments.columnName = trim(arguments.columnName);
			arguments.columnName = reReplaceNoCase(arguments.columnName, '^\[', '', 'all');
			arguments.columnName = reReplaceNoCase(arguments.columnName, '\]$', '', 'all');
			return trim(arguments.columnName);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getQuery"
		returnType	= "query"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= "!you must close the file session!"
	>
		<cfScript>
			local.structOfArrays = getStructOfArrays();

			local.newQuery = queryNew("");

			/* build column names */
				for(local.columnName in local.structOfArrays)
				{
					local.newColumnName = reReplaceNoCase(local.columnName, "((^[0-9]+)|[^A-Z0-9_])" , "" , "all" );
					queryAddColumn(local.newQuery, local.newColumnName, local.structOfArrays[local.columnName]);
				}
			/* end */

			return local.newQuery;
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
			local.struct = getStructOfArrays();

			if(!structKeyExists(local.struct, arguments.columnName))
				return 0;

			local.length=0;
			local.array = local.struct[arguments.columnName];

			for(local.x=arrayLen(local.array); local.x GT 0; --local.x)
				local.length = max(len(local.array[local.x]), local.length);

			return local.length;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "loadColumnHeadRow"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			//?already loaded?
			if(arrayLen(variables.columnNameArray))
				return this;

			local.Converts = CFMethods().Conversions();
			local.CsvConfig = getCsvConfig();

			variables.columnNameArray = arrayNew(1);
			local.delimiter = local.CsvConfig.getValueDelimiter();
			local.textQualifier = local.CsvConfig.getTextQualifier();
			local.rowDelimiters = local.CsvConfig.getRowDelimiters();
			local.isFirstRowAsHeaders = local.CsvConfig.isFirstRowAsHeaders();

			local.headString = getHeaderRow();
			if(isNull(local.headString) OR !len(local.headString))
			{
				local.csvString = getCsvString();
				local.headString = listFirst(local.csvString, local.rowDelimiters);
			}

			setHeaderRow(local.headString);

			/* Get Column Len, by distecting row1 */
				if(structKeyExists(local, 'textQualifier') AND len(local.textQualifier))
					local.arrayCol = local.Converts.qualifiedListToArray(local.headString, local.delimiter, local.textQualifier);
				else
					local.arrayCol = listToArray(local.headString, local.delimiter);
			/* end */

			/* define return query column heads */
				for(local.i=1; local.i LTE arrayLen(local.arrayCol); ++local.i)
				{
					if(local.isFirstRowAsHeaders)
						local.columnName = local.arrayCol[local.i];
					else
						local.columnName = 'Column#local.i#';

					local.columnName = softCleanseColumnName(local.columnName);
					arrayAppend(variables.columnNameArray, local.columnName);
				}
			/* end */

			//remove first line
			if(local.isFirstRowAsHeaders)
			{
				local.csvString = listDeleteAt(local.csvString,1,local.rowDelimiters);
				setCsvString(local.csvString);
			}

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setCsvString"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="csvString" required="yes" type="string" hint="" />
		<cfScript>
			variables.csvString = trim(arguments.csvString);
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getColumnNameArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(arrayLen(variables.columnNameArray))
				return variables.columnNameArray;

			loadColumnHeadRow();
			return variables.columnNameArray;
		</cfScript>
	</cfFunction>

</cfComponent>