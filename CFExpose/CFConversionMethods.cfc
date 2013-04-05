<cfComponent
	Hint		= ""
	Output		= "no"
	Extends		= "CFStringMethods"
>

	<cfFunction
		name		= "convertBytes"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= "Cast kilobytes to MM/GB. Casted to GB when over 1024 MB"
		description	= ""
	>
		<cfArgument name="bytes"		required="yes"	type="string"						hint="val() will be applied to this argument" />
		<cfArgument name="unit"			required="no"	type="variableName"	default="B"		hint="Current unit : B,KB,MB,GB,TB,PB" />
		<cfArgument name="formatMask"	required="no"	type="numeric"		default="9.99"	hint="Only applied when not whole number" />
		<cfArgument name="maxUnit"		required="no"	type="variableName"					hint="!Not yet implemented max is petabyte" />
		<cfScript>
			var local = structNew();

			arguments.bytes = val(arguments.bytes);

			local.unitList = "B,KB,MB,GB,TB,PB";
			local.currentUnitPost = listFindNoCase(local.unitList, arguments.unit);

			if(arguments.bytes LT 1024 OR !local.currentUnitPost OR local.currentUnitPost EQ listLen(local.unitList))
			{
				if(arguments.bytes NEQ ceiling(arguments.bytes))
					arguments.bytes = numberformat(arguments.bytes, arguments.formatMask);

				return arguments.bytes  & ' ' & arguments.unit;
			}

			local.nextUnit = listGetAt(local.unitList, local.currentUnitPost+1);

			return convertBytes(arguments.bytes/1024, local.nextUnit);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "urlToCFFileUploadUrl"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= "only need for if ColdFusion 9.0.0 is involved. ColdFusion 9.0.1 and greater do not need this function"
		hint		= "makes url string ready for cfFileUpload flash based functionality"
	>
		<cfArgument name="url"					required="yes"	type="string"	hint="" />
		<cfArgument name="isUrlEncodeFormat"	required="no"	type="boolean" default="1" hint="Ignored if ColdFusion Version Greater Than 9.0.0" />
		<cfScript>
			var local = structNew();

			/* Only ColdFusion 9.0.1 or later ONLY */
				local.isColdFusionFirstNine=
				(
					listFirst(server.coldfusion.productversion) EQ 9
				AND
					listGetAt(server.coldfusion.productversion,2) EQ 0
				AND
					listGetAt(server.coldfusion.productversion,3) EQ 0
				);

				if(NOT local.isColdFusionFirstNine)
					return arguments.url;
			/* end */

			/* ONLY ColdFusion 9.0.0 */
				local.urlVarStart = find('?',arguments.url);

				if(NOT local.urlVarStart)
				{
					local.left	= arguments.url & '?';
					local.right	= '';
				}else
				{
					local.left	= left(arguments.url, local.urlVarStart);
					local.right	= right(arguments.url, len(arguments.url)-local.urlVarStart);
				}

				/* Only ColdFusion 9.0.0 ... after version 9.0.1 we don't need all this */

					if(local.isColdFusionFirstNine)
					{
						if(structKeyExists(session, "urlToken"))
						{
							if(local.urlVarStart)
								local.right = local.right & '&';

							local.right = local.right & session.urlToken;
						}
					}
				/* end */

				if(arguments.isUrlEncodeFormat)
					local.returnUrl = local.left & urlEncodedFormat(local.right);
				else
					local.returnUrl = local.left & local.right;

				return local.returnUrl;
			/* end */
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "csvFileToQuery"
		returnType	= "query"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="filePath"					required="yes"	type="string"								hint="" />
		<cfArgument name="delimiter"				required="no"	type="string"	default=","					hint="" />
		<cfArgument name="textQualifier"			required="no"	type="string"								hint="" />
		<cfArgument name="rowDelimiters"			required="no"	type="string"	default="#chr(10)&chr(13)#"	hint="" />
		<cfArgument name="isFirstRowColumnHeads"	required="no"	type="boolean"	default="yes"				hint="" />
		<cfArgument name="maxRows"					required="no"	type="numeric"								hint="" />
		<cfArgument name="startingRow"				required="no"	type="numeric"								hint="" />
		<cfScript>
			var local = structNew();

			if(structKeyExists(arguments,"maxrows"))
			{
				local.openFile		= fileOpen(arguments.filePath, "read");
				local.fileRead		= "";
				local.lineReadCount	=	0;

				if(arguments.isFirstRowColumnHeads)
					local.fileRead = FileReadLine(local.openFile) & chr(10);

				if(structKeyExists(arguments , "startingRow"))
					for(local.x=1; local.x LTE arguments.startingRow; ++local.x)
						FileReadLine(local.openFile);

				while(NOT FileIsEOF(local.openFile) AND local.lineReadCount LTE arguments.maxRows)
				{
					local.fileRead &= FileReadLine(local.openFile) & chr(10);
					++local.lineReadCount;
				}

				FileClose(local.openFile);
			}else
				local.fileRead = fileRead(arguments.filePath);


			local.argumentCollection = {csvString=local.fileRead};
			structAppend(local.argumentCollection , arguments);

			return csvToQuery(argumentCollection=local.argumentCollection);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "toJson"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "a more controllable serialization of a coldfusion variable"
	>
		<cfArgument name="var"						required="yes"	type="any"						hint="" />
		<cfArgument name="serializeQueryByColumns"	required="no"	type="boolean"	default="no"	hint="" />
		<cfArgument name="isYesNoToString"			required="no"	type="boolean"	default="no"	hint="" />
		<cfArgument name="isStringNumbers"			required="no"	type="boolean"					hint="when not defined, yes when variable is complex" />
		<cfScript>
			var local = structNew();

			local.returnString = "";

			if(not structKeyExists(arguments , "isStringNumbers"))
				arguments.isStringNumbers = isSimpleValue(arguments.var);

			if(arguments.isStringNumbers OR arguments.isYesNoToString)
			{
				arguments.paddingString = '!@@'&getTickCount()&'@@!';//create replace token that's atleast a little random as to never replace an actual value from string.
				arguments.var = serializeJson(padJsonValue(argumentCollection=arguments));//insert the pad token where specified so serializeJson thinks they are strings

				return reReplace(arguments.var , arguments.paddingString , '' , 'all');//remove the pad token
				//return reReplace(arguments.var , '(''|")'&arguments.paddingString , '\1' , 'all');//remove the pad token
			}

			/* no extra formating required... let coldfusion do the job the way it does */
				structDelete(arguments , "isYesNoToString" , true);
				structDelete(arguments , "isStringNumbers" , true);

				Return serializeJson(arguments.var, arguments.serializeQueryByColumns);
			/* end */
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "padJsonValue"
		returnType	= "any"
		access		= "public"
		output		= "no"
		description	= "follow thru for the method 'toJson' that handles parsing specificity"
		hint		= "recursive"
	>
		<cfArgument name="var"				required="yes"	type="any"						hint="" />
		<cfArgument name="isYesNoToString"	required="no"	type="boolean"	default="no"	hint="" />
		<cfArgument name="isStringNumbers"	required="no"	type="boolean"	default="no"	hint="when not defined, yes only when var is complex" />
		<cfArgument name="paddingString"	required="no"	type="string"	default=" "		hint="" />
		<cfScript>
			if(isSimpleValue(arguments.var))
			{
				if
				(
					arguments.isStringNumbers
				AND
					isNumeric(arguments.var)
				)
					return arguments.paddingString & arguments.var;

				if(arguments.isYesNoToString AND reFindNoCase("^(yes|no)$" , local.value , 1 , false ))
					return arguments.paddingString & arguments.var;

				return arguments.var;
			}

			local.cloneArguments=duplicate(arguments);
			structDelete(local.cloneArguments , "var" , true);

			if(isStruct(arguments.var))
			{
				for(local.key in arguments.var)
				{
					local.cloneArguments.var = arguments.var[local.key];
					arguments.var[local.key] = padJsonValue(argumentCollection=local.cloneArguments);
				}
			}else if(isArray(arguments.var))
			{
				local.arrayLen = arrayLen(arguments.var);
				for(local.key=1; local.key LTE local.arrayLen; ++local.key)
				{
					local.cloneArguments.var = arguments.var[local.key];
					arguments.var[local.key] = padJsonValue(argumentCollection=local.cloneArguments);
				}
			}else if(isQuery(arguments.var))
			{
				arguments.var = duplicate(Expose(arguments.var).deleteColumnDataTypes().getVar());//must remove query column data types to not allow ColdFusion to validate against the pad token

				/* row loop */
					local.columnList 	= arguments.var.columnList;
					local.columnLength	= listLen(arguments.var.columnList);

					for(local.rowLoop=1; local.rowLoop LTE arguments.var.recordCount; ++local.rowLoop)
					{

						for(local.columnLoop=1; local.columnLoop LTE local.columnLength; ++local.columnLoop)
						{
							local.columnName = listGetAt(local.columnList,local.columnLoop);
							local.cloneArguments.var = arguments.var[local.columnName][local.rowLoop];
							querySetCell(arguments.var , local.columnName , padJsonValue(argumentCollection=local.cloneArguments) , local.rowLoop);
						}
					}
				/* end */
			}

			return arguments.var;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "jsonQueryToQuery"
		returnType	= "query"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "jsonQuery should be like : {columns:[], data:[[],[],[]]}"
	>
		<cfArgument name="jsonQuery" required="yes" type="struct" hint="" />
		<cfScript>
			var local = structNew();

			/* column list */
				local.columnNameList	= ArrayToList(arguments.jsonQuery.columns);
				local.columnCount		= arrayLen(arguments.jsonQuery.columns);
			/* end */

			local.query = queryNew(local.columnNameList);

			/* row loop */
				local.dataCount = arrayLen(arguments.jsonQuery.data);
				for(local.currentRow=1; local.currentRow LTE local.dataCount; ++local.currentRow)
				{
					queryAddRow(local.query);

					/* column loop */
						for(local.currentColumn=1; local.currentColumn LTE local.columnCount; ++local.currentColumn)
							querySetCell(local.query, arguments.jsonQuery.columns[local.currentColumn], arguments.jsonQuery.data[local.currentRow][local.currentColumn], local.currentRow);
					/* end */
				}
			/* end */

			return local.query;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "arrayStructKeyValuesToArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="array"		required="yes"	type="array"					hint="" />
		<cfArgument name="keyName"		required="yes"	type="variableName"				hint="" />
		<cfScript>
			var local = structNew();

			local.returnArray = arrayNew(1);
			local.arrayLen = arrayLen(arguments.array);

			for(local.x=1; local.x LTE local.arrayLen; ++local.x)
			{
				if( !isStruct(arguments.array[local.x]) AND !isObject(arguments.array[local.x]))
					throw
					(
						message	= "Element Number #local.x# of #local.arrayLen# in arrayStruct is not a structured variable as expected",
						detail	= "The struct key '#arguments.keyName#' could not be returned as not all elements in array are structured variables"
					);

				if( !structKeyExists(arguments.array[local.x] , arguments.keyName) )
					throw
					(
						message	= "Element Number #local.x# of #local.arrayLen# in arrayStruct does not contain the key '#arguments.keyName#'",
						detail	= "The struct key '#arguments.keyName#' could not be returned as is cannot be found"
					);

				arrayAppend(local.returnArray , arguments.array[local.x][arguments.keyName]);
			}

			return local.returnArray;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "XmlToStruct"
		access		= "public"
		returntype	= "struct"
		output		= "no"
		hint		= "Parse raw XML response body into ColdFusion structs and arrays and return it."
	>
		<cfArgument name="xml"					required="yes"	type="any"	 />
		<cfArgument name="isChildsAllAsArray"	required="no"	type="boolean"	default="yes"	hint="When true, XML columns that have child nodes will be analized to see if storing as an array is necessary (only stored as an array when two or more children are found to have the same name). When false, XML columns that have child nodes may need to be tested against for sub children when 'crawling' threw the child node structure. If you don't know the XML your dealing with, or it is dynamic then it is highly suggested that all children be stored as an array" />
		<cfScript>
			var local = structNew();

			local.axml				= XmlSearch( XmlParse(arguments.xml) , "/node()" );
			local.axml				= local.axml[1];
			local.return_struct		= structNew();
			local.childCount		= arrayLen(local.axml.XmlChildren);
			local.duplicatesList	= "";

			/* For each children of context node: */
				for( local.i=1; local.i LTE local.childCount; local.i=local.i+1 )
				{
					local.node			= local.axml.XmlChildren[local.i];
					local.nodeName		= replace( local.node.XmlName , local.node.XmlNsPrefix & ":" , "");//Read XML node name without namespace
					local.subChildCount	= arrayLen(local.node.XmlChildren);

					if( not structKeyExists( local.return_struct , local.nodeName ) )
					{
						if( local.subChildCount AND arguments.isChildsAllAsArray )
							local.return_struct[local.nodeName] = arrayNew(1);//always array the children
						else
						{
							/* find if we have duplicate childNames ... if so, then array ELSE struct */
								local.list			= "";
								local.hasDuplicate	= 0;

								for( local.x=1; local.x LTE local.childCount; local.x=local.x+1)
								{
									local.subNode		= local.axml.XmlChildren[local.x];
									local.subNodeName	= replace( local.subNode.XmlName , local.subNode.XmlNsPrefix & ":" , "");

									if( local.i NEQ local.x )
									{
										local.list=listAppend( local.list , local.subNodeName );

										if( listFindNoCase( local.list , local.nodeName ) )
										{
											local.hasDuplicate=1;
											break;
										}
									}
								}

								if( local.hasDuplicate )
								{
									local.return_struct[local.nodeName] = arrayNew(1);//found 2 children with the same name, so we must make an array
									local.duplicatesList = listAppend( local.duplicatesList , local.nodeName );
								}else
									local.return_struct[local.nodeName] = structNew();//children as struct
							/* end */
						}
					}

					/*
						This is not a struct. This may be first tag with same name.
						This may also be one and only tag with this name.

						If context child node has child nodes (which means it will be complex type):
					*/
						if( isArray(local.return_struct[local.nodeName]) )
						{
							if(local.subChildCount)
								arrayAppend( local.return_struct[local.nodeName] , XmlToStruct( local.node , arguments.isChildsAllAsArray ) );//array append children
							else
								arrayAppend( local.return_struct[local.nodeName] , local.node.xmlText );
						}else if( isStruct(local.return_struct[local.nodeName]) AND local.subChildCount)
							structAppend( local.return_struct[local.nodeName] , XmlToStruct( local.node , arguments.isChildsAllAsArray ) );
						else
							local.return_struct[local.nodeName] = local.node.XmlText;
					/* end */

					/* ATTRIBUTES */
						/* check if there are no attributes with xmlns: , we dont want namespaces to be in the response */
							if( isStruct(local.node.XmlAttributes) )
							{
								 local.attrib_list = StructKeylist(local.node.XmlAttributes);
								 local.attrArray = listToArray(local.attrib_list);
								 local.attrCount = arrayLen(local.attrArray);
								 for( local.attrib=1; local.attrib LTE local.attrCount; ++local.attrib )
									 if(local.attrArray[local.attrib] CONTAINS "xmlns:")
										structDelete( local.node.XmlAttributes , local.attrArray[local.attrib]);//remove any namespace attributes
							}
						/* end */

						local.attr_node_name = local.nodeName & '_attributes';

						if(
							(
								isStruct(local.node.XmlAttributes)
							AND
								StructCount(local.node.XmlAttributes)
							)
						OR
							structKeyExists( local.return_struct , local.attr_node_name )
						OR
							listFindNoCase( local.duplicatesList , local.nodeName )
						){
							if(
								not structKeyExists( local.return_struct , local.attr_node_name )
							AND
								(
									arguments.isChildsAllAsArray
								OR
									listFindNoCase( local.duplicatesList , local.nodeName )
								)
							)
								local.return_struct[local.attr_node_name] = arrayNew(1);

							/* if there are any attributes left, append them to the response */
								if( structKeyExists( local.return_struct , local.attr_node_name ) AND isArray(local.return_struct[local.attr_node_name]) )
									arrayAppend( local.return_struct[local.attr_node_name] , local.node.XmlAttributes );
								else
									local.return_struct[local.attr_node_name] = local.node.XmlAttributes;
							/* end */
						}
					/* end */
				}
			/* end */

			/* loop duplicates and remove blank attribute structures */
				local.dupArray	= listToArray(local.duplicatesList);
				local.itemCount = arrayLen(local.dupArray);
				for( local.x=1; local.x LTE local.itemCount; local.x=local.x+1 )
				{
					local.attName	= local.dupArray[local.x] & "_attributes";
					local.attArr	= local.return_struct[local.attName];
					local.attLen	= arrayLen( local.attArr );
					local.isBlank	= 1;
					for( local.y=1; local.y LTE local.attLen; local.y=local.y+1 )
					{
						if( structCount(local.attArr[local.y]) )
						{
							local.isBlank=0;
							break;
						}
					}

					if(local.isBlank)
						structDelete( local.return_struct , local.attName );
				}
			/* end */

			return local.return_struct;
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "stringToCFSqlType"
		returnType	= "variableName"
		Access		= "public"
		Output		= "no"
		Hint		= "returns an appropriate cf_sql data type name based on the argument received"
		Description	= "Returns: cf_sql_integer, cf_sql_BIGINT, cf_sql_DOUBLE, CF_SQL_TimeStamp, CF_SQL_LONGVARCHAR or CF_SQL_VARCHAR"
	>
		<cfArgument name="string"	required="yes"	type="string"	hint="" />
		<cfScript>
			if(
				isNumeric(arguments.string)
			AND
				(
					arguments.string eq 0
				OR
					left(arguments.string,1) neq 0
				)
			AND
				listLen(arguments.string , '.') eq 1
			){
				if( arguments.string lte 2222222222 )Return "cf_sql_integer";
				Return "cf_sql_BIGINT";
			}else if(
				isNumeric(arguments.string)
			AND
				listLen(arguments.string,'.') eq 2
			){
				Return "cf_sql_DOUBLE";
			}else if(
				LSIsCurrency(arguments.string)
			AND
				left(arguments.string,1) neq 0
			){
				if( arguments.string lte 2222222222 )Return "cf_sql_integer";
				Return "cf_sql_BIGINT";
			}else if( isdate(arguments.string) )
			{
				Return "CF_SQL_TimeStamp";
			}else if(
				listlen(arguments.string,chr(10)) gte 4
			OR
				len(arguments.string) gt 255
			){
				Return "CF_SQL_LONGVARCHAR";
			}else
			{
				Return "CF_SQL_VARCHAR";
			}
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "dataTypeTocfSqlType"
		returnType	= "variableName"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="data_type"	required="yes"	type="variableName" hint="" />
		<cfScript>
			Switch (arguments.data_type)
			{
				Case "bigint":
					Return "CF_SQL_BIGINT";
					break;

				Case "binary":
					Return "CF_SQL_BINARY";
					break;

				Case "bit":
					Return "CF_SQL_BIT";
					break;

				Case "blob":
				Case "tinyblob":
				Case "mediumblob":
					Return "CF_SQL_BLOB";
					break;

				Case "char":
					Return "CF_SQL_CHAR";
					break;

				Case "date":
					Return "CF_SQL_DATE";
					break;

				Case "CF_SQL_DECIMAL":
					Return "decimal";
					break;

				Case "double":
					Return "CF_SQL_DOUBLE";
					break;

				Case "float":
					Return "CF_SQL_FLOAT";
					break;

				Case "mediumint":
				case "int":
					Return "CF_SQL_INTEGER";
					break;

				Case "real":
					Return "CF_SQL_REAL";
					break;

				Case "smallint":
					Return "CF_SQL_SMALLINT";
					break;

				Case "time":
					Return "CF_SQL_TIME";
					break;

				Case "datetime":
				Case "timestamp":
					Return "CF_SQL_TIMESTAMP";
					break;

				Case "tinyint":
					Return "CF_SQL_TINYINT";
					break;

				Case "varbinary":
					Return "CF_SQL_VARBINARY";

				Default:
					Return "CF_SQL_VARCHAR";
			};
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "csvToQuery"
		returnType	= "query"
		Access		= "public"
		Output		= "no"
		Hint		= ""
	>
		<cfArgument name="csvString"				required="yes"	type="string"								hint="" />
		<cfArgument name="delimiter"				required="no"	type="string"	default=","					hint="" />
		<cfArgument name="textQualifier"			required="no"	type="string"								hint="typically quotes. escape with same char twice" />
		<cfArgument name="rowDelimiters"			required="no"	type="string"	default="#chr(10)&chr(13)#"	hint="" />
		<cfArgument name="isFirstRowColumnHeads"	required="no"	type="boolean"	default="no"				hint="" />
		<cfArgument name="maxRows"					required="no"	type="numeric"								hint="" />
		<cfScript>
			var local = structNew();

			arguments.var = arguments.csvString;
			if(structKeyExists(arguments, "delimiter"))
				arguments.valueDelimiter = arguments.delimiter;

			if(structKeyExists(arguments, "maxRows"))
				arguments.maxRowCount = arguments.maxRows;

			local.ExposeFileCsv = new ExposeCsv(argumentCollection=arguments);

			return local.ExposeFileCsv.getQuery();
		</cfScript>
	</cfFunction>

	<!--- struct to HTML string methods --->
		<cfFunction
			name		= "structToTagString"
			returnType	= "string"
			access		= "public"
			output		= "no"
			description	= "returns xml string conversion of coldfusion struct. All keys in struct that are string will be attributes. All keys in struct that are struct will be subtags"
			hint		= "Two alike tag names is obviously not possible. Arrays or other complex key values within the struct are ignored. No way to define inner tag Html"
		>
			<cfArgument name="attributeStruct"			required="no"	type="struct"						hint="" />
			<cfArgument name="tagName"					required="yes"	type="variableName"					hint="tag type actually" />
			<cfArgument name="tagBody"					required="no"	type="string"						hint="aka innerHtml" />
			<cfArgument name="attributeNameOrderList"	required="no"	type="string"		default=""		hint="type in the list of attribute as you would like them returned. Good for making the attribute 'name', appear first" />
			<cfScript>
				var local = structNew();

				local.returnString = "<#arguments.tagName#";
				local.attributeString = "";

				/* attributes */
					if(structKeyExists(arguments, "attributeStruct") AND structCount(arguments.attributeStruct))
					{
						local.attributeString = structToStringTagAttributes(attributeStruct=arguments.attributeStruct, attributeNameOrderList=arguments.attributeNameOrderList);

						local.tagBody = '';

						/* check for depth */
							for(local.keyName IN arguments.attributeStruct)
							{
								local.key = arguments.attributeStruct[local.keyName];
								if(isStruct(local.key))
									local.tagBody &= structToTagString(attributeStruct=local.key, tagName=local.keyName, attributeNameOrderList=arguments.attributeNameOrderList);
							}
						/* end */

						if(len(local.tagBody))
						{
							if(!structKeyExists(arguments, 'tagBody'))
								arguments.tagBody = '';

							arguments.tagBody &= local.tagBody;
						}
					}
				/* end */

				if(len(local.attributeString))
					local.returnString &= " " & local.attributeString;//append string of attributes

				if(structKeyExists(arguments, "tagBody"))
					Return local.returnString & ">" & arguments.tagBody & "</" & arguments.tagName& ">";//return string with inner content

				Return local.returnString & " />";//return string having no children
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "structToStringTagAttributes"
			returnType	= "string"
			access		= "public"
			output		= "no"
			description	= "takes only struct keys that are simple values, and converts them to key-name=key-value pairs"
			hint		= ""
		>
			<cfArgument name="attributeStruct"			required="yes"	type="struct"					hint="" />
			<cfArgument name="valueQualifier"			required="no"	type="string"	default=""""	hint="" />
			<cfArgument name="attributeNameOrderList"	required="no"	type="string"	default=""		hint="type in the list of attribute as you would like them returned. Good for making the attribute 'name', appear first" />
			<cfScript>
				var local = structNew();

				local.returnString = "";

				//structDeleteNulls(arguments.attributeStruct);
				local.structKeyList = structKeyList(arguments.attributeStruct);

				if(structKeyExists(arguments, "attributeNameOrderList") AND listLen(arguments.attributeNameOrderList))
				{
					local.anol = listToArray(arguments.attributeNameOrderList);
					local.newStructKeyList = duplicate(local.structKeyList);

					for(local.currentRow=arrayLen(local.anol); local.currentRow > 0; --local.currentRow)
					{
						local.name = local.anol[local.currentRow];
						local.listFindResult = listFindNoCase(local.newStructKeyList, local.name);
						if(local.listFindResult)
						{
							local.newStructKeyList = listDeleteAt(local.newStructKeyList, local.listFindResult);
							local.newStructKeyList = listPrepend(local.newStructKeyList, local.name);
						}
					}

					local.structKeyList = local.newStructKeyList;
				}

				local.structKeyArray = listToArray(local.structKeyList);

				for(local.currentRow = 1; local.currentRow LTE arrayLen(local.structKeyArray); ++local.currentRow)
				{
					local.keyName = local.structKeyArray[local.currentRow];
					local.key = arguments.attributeStruct[local.keyName];

					if(isSimpleValue(local.key))
					{
						if(len(local.returnString))local.returnString &= " ";//add space after last item
						local.returnString &= local.keyName & "=" & arguments.valueQualifier & htmlEditFormat(local.key) & arguments.valueQualifier;//add loop item
					}
				}

				return local.returnString;
			</cfScript>
		</cfFunction>
	<!--- end --->

	<cfFunction
		name		= "attributeStringToStruct"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		description	= "uses a regular expression to extract attribute name & values from a supplied string"
		hint		= "string can contain html tags and such"
	>
		<cfArgument name="attributeString" required="yes" type="string" hint="" />
		<cfScript>
			var local = structNew();

			local.argRegx = "\w+([\s\r\t\n]+)?=([\s\r\t\n]+)?([""'])?(((\3{2}|\3{0}|.)+?\3{1}?)|[^'""=\s\r\t\n]+)";

			//local.detailStruct.argumentCollection = getArgumentCollectionFromInvokationString();
			local.argumentFindStruct = reFindAllNoCase(local.argRegx , arguments.attributeString);
			local.argumentFindStruct.string = arguments.attributeString;
			local.foundArguments = structNew();

			for(local.argFindLoop=1; local.argFindLoop LTE arrayLen(local.argumentFindStruct.len); ++local.argFindLoop)
			{
				local.argLen	= local.argumentFindStruct.len[local.argFindLoop];
				local.argPos	= local.argumentFindStruct.pos[local.argFindLoop];
				local.argString	= mid(arguments.attributeString , local.argPos , local.argLen);

				local.argName	= listFirst(local.argString,'=');
				//local.argValue	= listLast(local.argString,'=');

				local.rightLength = len(local.argString)-len(local.argName);

				local.argValue	= right(local.argString , local.rightLength);
				local.argName	= trim(local.argName);

				local.argValue	= trim(local.argValue);
				local.argValue	= reReplaceNoCase(local.argValue , '^=([\s\r\t\n]+)?(''|")?' , '' , 'all');//remove equal sign and option quoted value identifier
				local.argValue	= reReplaceNoCase(local.argValue , '(''|")$' , '' , 'all');//remove last quotes
				local.argValue	= reReplaceNoCase(local.argValue , '(''|")\1' , '\1' , 'all');//replace quote-quote aka escaped quote characters into single quote


				local.foundArguments[local.argName] = local.argValue;
			}

			return local.foundArguments;
		</cfScript>
	</cfFunction>

	<cfFunction
		Name		= "parseCss"
		returnType	= "array"
		Access		= "public"
		Output		= "no"
		Hint		= "returns an array of a css name/value pairs"
	>
		<cfArgument name="cssContent"	required="no" type="string" hint="" />
		<cfArgument name="cssURL"		required="no" type="string" hint="" />
		<cfset var cssStruct = "" />
		<cfset arguments.returnVariableName = "cssStruct" />
		<cfModule template="Templates/Procedures/cssReader.cfm" attributeCollection="#arguments#" />
		<cfReturn cssStruct />
	</cfFunction>

</cfComponent>