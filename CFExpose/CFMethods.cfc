<cfComponent
	Hint		= ""
	Output		= "no"
>

	<!--- ColdFusion tags as functions --->
		<cfFunction
			name		= "dbInfo"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="datasource"	required="no"	type="string" hint="" />
			<cfArgument name="type"			required="no"	type="string" hint="" />
			<cfArgument name="dbname"		required="no"	type="string" hint="" />
			<cfArgument name="table"		required="no"	type="string" hint="" />
			<cfset structDeleteNulls(arguments) />
			<cfset arguments.name = 'local.query' />
			<cfDbInfo attributeCollection="#arguments#" />
			<cfReturn local.query />
		</cfFunction>

		<cfFunction
			name		= "location"
			returnType	= "void"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfArgument name="url"			required="yes"	type="string" hint="" />
			<cfArgument name="addtoken"		required="no"	type="string" hint="" />
			<cfArgument name="statusCode"	required="no"	type="string" hint="" />
			<cfset structDeleteNulls(arguments) />
			<cfLocation attributeCollection="#arguments#" />
		</cfFunction>

		<cfFunction
			name		= "header"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= "CFHeader equivalent. returns self"
			description	= ""
		>
			<cfArgument name="statusCode"	required="no" type="string" hint="" />
			<cfArgument name="statusText"	required="no" type="string" hint="" />
			<cfArgument name="charset"		required="no" type="string" hint="" />
			<cfArgument name="name"			required="no" type="string" hint="" />
			<cfArgument name="value"		required="no" type="string" hint="" />
			<cfset structDeleteNulls(arguments) />
			<cfHeader attributeCollection="#arguments#" />
			<cfReturn this />
		</cfFunction>

		<cfFunction
			name		= "dump"
			returnType	= "string"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="var"		required="yes"	type="any"							hint="" />
			<cfArgument name="label"	required="no"	type="string"						hint="" />
			<cfArgument name="expand"	required="no"	type="boolean"		default="yes"	hint="" />
			<cfArgument name="format"	required="no"	type="variableName" default="html"	hint="" />
			<cfset var local = structNew() />
			<cfset structDeleteNulls(arguments) />
			<cfSaveContent Variable="local.returnString"><cfDump attributeCollection="#arguments#" /></cfSaveContent>
			<cfReturn local.returnString />
		</cfFunction>

		<cfFunction
			name		= "abort"
			returnType	= "string"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfAbort />
		</cfFunction>

		<cfFunction
			Name		= "throw"
			returnType	= "any"
			Access		= "public"
			Output		= "no"
			Hint		= "see cfThrow tag"
		>
			<cfArgument name="message"		required="no"	type="any"			default=""	hint="type is 'any' to allow error object passed as only argument. Example: throw(cfCatch-Variable)" />
			<cfArgument name="type"			required="no"	type="variableName"				hint="" />
			<cfArgument name="detail"		required="no"	type="string"		default=""	hint="" />
			<cfArgument name="errorCode"	required="no"	type="string"					hint="" />
			<cfArgument name="extendedInfo"	required="no"	type="string"					hint="" />
			<cfArgument name="object"		required="no"	type="any"					hint="java error object variable such as the 'cfCatch' the comes from the cfCatch tag in ColdFusion" />
			<cfset structDeleteNulls(arguments) />
			<cfif structKeyExists( arguments , "message" ) AND NOT isSimpleValue(arguments.message) >
				<cfset arguments.object = arguments.message />
			</cfif>
			<cfif structKeyExists( arguments , "object" ) >
				<cfThrow object="#arguments.object#" />
			</cfif>
			<cfThrow attributeCollection="#arguments#" />
			<cfReturn this />
		</cfFunction>

		<cfFunction
			name		= "htmlHead"
			returnType	= "any"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= "see cfHtml tag"
		>
			<cfArgument name="text" required="yes" type="string" hint="" />
			<cfHtmlHead text="#arguments.text#" />
			<cfReturn this />
		</cfFunction>

	<cfFunction
		name		= "cookie"
		returnType	= "CFMethods"
		access		= "public"
		output		= "no"
		hint		= "see cfcookie"
		description	= ""
	>
		<cfArgument name="name"		required="no"	type="string"	hint="" />
		<cfArgument name="value"	required="no"	type="string"	hint="" />
		<cfArgument name="domain"	required="no"	type="string"	hint="" />
		<cfArgument name="expires"	required="no"	type="string"	hint="" />
		<cfset structDeleteNulls(arguments) />
		<cfCookie attributeCollection="#arguments#" />
		<cfReturn this />
	</cfFunction>
	<!--- end : ColdFusion tags as functions --->

	<!--- near ColdFusion tags (with alterations) as functions --->
		<cfFunction
			name		= "cfSetting"
			returnType	= "void"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= "see cfSetting tag"
		>
			<cfArgument name="showDebugOutput"		required="no"	type="boolean"	hint="" />
			<cfArgument name="requestTimeOut"		required="no"	type="numeric"	hint="" />
			<cfArgument name="enableCFoutputOnly"	required="no"	type="boolean"	hint="" />
			<cfset structDeleteNulls(arguments) />
			<cfSetting attributeCollection="#arguments#" />
		</cfFunction>

		<cfFunction
			name		= "flushOutput"
			returnType	= "void"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="interval" required="yes" type="numeric" default="100" hint="" />
			<cfFlush interval="#arguments.interval#">
		</cfFunction>

		<cfFunction
			name		= "directoryQuery"
			returnType	= "any"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= "return type is based on 'listInfo' argument"
		>
			<cfArgument name="directory"	required="yes"	type="string"						hint="The absolute path of the directory for which to list the contents. Alternatively, you can specify IP address as in the following example: directoryQuery('//12.3.123.123/c_drive/test');" />
			<cfArgument name="recurse"		required="no"	type="boolean"		default="no"	hint="Whether ColdFusion performs the action on subdirectories: If true, contents of all subdirectories are also listed." />
			<cfArgument name="listInfo"		required="no"	type="variableName"	default="query"	hint="name: returns an array of names of files and directories. path: returns an array of paths of files and directories. query: returns a query." />
			<cfArgument name="filter"		required="no"	type="string"						hint="File extension filter applied to returned names, for example, *.cfm. One filter can be applied." />
			<cfArgument name="sort"			required="no"	type="string"						hint="Query columns by which to sort a directory listing. Delimited list of columns from query output. Example:directory ASC, size DESC, datelastmodified" />
			<cfArgument name="type"			required="no"	type="variableName"					hint="file|directory|all" />
			<cfScript>
				var local = structNew();

				structDeleteNulls(arguments);

				if(listFirst(server.coldfusion.productVersion) GTE 9)
				{
					arguments.filter='*';
					arguments.sort='';
					return directoryList(arguments.directory, arguments.recurse, arguments.listInfo, arguments.filter, arguments.sort);
				}

				arguments.name = "local.returnQuery";
			</cfScript>
			<cfDirectory attributeCollection="#arguments#" />
			<cfScript>
				switch(arguments.listInfo)
				{
					case 'name':
						return listToArray(valueList(local.returnQuery.name , "~") , "~");

					case 'path':
					{
						local.returnArray = arrayNew(1);
						for(local.index=1; local.index LTE local.returnQuery.recordCount; local.index=local.index+1)
							arrayAppend(local.returnArray, local.returnQuery.directory[local.index] & local.returnQuery.name[local.index]);

						return local.returnArray;
					}
				}

				return local.returnQuery;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "fileUpload"
			returnType	= "struct"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="destination"	required="yes"	type="string"						hint="" />
			<cfArgument name="fileField"	required="yes"	type="string"						hint="" />
			<cfArgument name="accept"		required="no"	type="string"						hint="" />
			<cfArgument name="nameConflict"	required="no"	type="variableName"	default="error"	hint="" />
			<cfset arguments.action	= 'upload' />
			<cfset arguments.result = 'arguments.result' />
			<cfFile attributeCollection='#arguments#' />
			<cfReturn arguments.result />
		</cfFunction>

		<cfFunction
			name		= "fileRename"
			returnType	= "void"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= "see cfFile action='rename'"
		>
			<cfArgument name="source"		required="yes"	type="string"	hint="" />
			<cfArgument name="destination"	required="yes"	type="string"	hint="" />
			<cfFile action="rename" source="#arguments.source#" destination="#arguments.destination#" />
		</cfFunction>

		<cfFunction
			name		= "scriptInvoke"
			returnType	= "any"
			access		= "public"
			output		= "no"
			description	= "a cfinvoke for cfScript"
			hint		= ""
		>
			<cfArgument name="method"			required="yes"	type="string"		hint="" />
			<cfArgument name="component"		required="yes"	type="any"			hint="" />
			<cfArgument name="invokeArguments"	required="no"	type="struct"	default="#structNew()#"	hint="" />
			<cfset var local = structNew() />
			<cfInvoke
				method				= "#arguments.method#"
				component			= "#arguments.component#"
				returnVariable		= "local.returnVariable"
				argumentCollection	= "#arguments.invokeArguments#"
			/>
			<cfReturn local.returnVariable />
		</cfFunction>
	<!--- end : near ColdFusion tags (with alterations) as functions --->

	<!--- extra useful methods --->
		<cfFunction
			name		= "cleanseHqlString"
			returnType	= "string"
			access		= "public"
			output		= "no"
			hint		= "ColdFusion 9 has issues with hql string if they are untrimmed or contain tabs"
			description	= ""
		>
			<cfArgument name="hql" required="yes" type="string" hint="" />
			<cfScript>
				return reReplaceNoCase(trim(arguments.hql), '\t+', ' ', 'all');
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getVariableTypeName"
			returnType	= "variableName"
			access		= "public"
			output		= "no"
			hint		= "using built-in CF functionality, returns a name string for the type of variable. Returns string of null when argument is undeterminable null"
			description	= ""
		>
			<cfArgument name="variable" required="yes" type="any" hint="" />
			<cfScript>
				if( isArray(arguments.variable) )
					return "array";
				if( isValid("component",arguments.variable) OR isInstanceOf(arguments.variable, 'WEB-INF.cfTags.component'))
					return "component";
				if( isStruct(arguments.variable) )
					return "struct";
				if( isQuery(arguments.variable) )
					return "query";
				if( isXML(arguments.variable) )
					return "xml";
				if( isNumeric(arguments.variable) )
					return "number";
				if( isSimpleValue(arguments.variable) )
					return "string";
				if( isCustomFunction(arguments.variable) )
					return "function";

				return 'null';
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "isMethodReturnComponent"
			returnType	= "boolean"
			access		= "public"
			output		= "no"
			hint		= "only argument should actually be a function variable, not a string"
			description	= ""
		>
			<cfArgument name="method" required="yes" type="any" hint="" />
			<cfScript>
				var local = structNew();

				local.methodMetaData = getMetaData(arguments.method);

				return
					structKeyExists(local.methodMetaData , "returnType")
				AND
					len(local.methodMetaData.returnType)
				AND
					!listFindNoCase('query,numeric,struct,string,array,any,variableName,boolean,void', local.methodMetaData.returnType);
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "arrayAppendArray"
			returnType	= "array"
			access		= "public"
			output		= "no"
			description	= "append argument 2 onto argument 1"
			hint		= ""
		>
			<cfArgument name="arrayOnto" required="yes" type="array"	hint="" />
			<cfArgument name="arrayFrom" required="yes" type="array"	hint="" />
			<cfScript>
				var local = structNew();
				local.len = arrayLen(arguments.arrayFrom);
				for(local.x=1; local.x LTE local.len; local.x=local.x+1)
					arrayAppend(arguments.arrayOnto, arguments.arrayFrom[local.x]);

				return arguments.arrayOnto;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "structDeleteNulls"
			returnType	= "struct"
			access		= "public"
			output		= "no"
			description	= "Primarily used to delete keys in an arguments collection/scope that are undefined arguments (not required and no default)."
			hint		= "Great for cleansing argument scopes that goto to CF tag invokations using the short attribute technique of 'attributeCollection'. The built-in coldfusion function 'serializeJSON' makes undefined unrequired arguments report as 'null' (this corrects that). When using the FOR loop and using and IN type loop within cfScript tag, it will loop on these 'nulls' and errors at any referencing of them being that they are truley considered 'void' aka undefined. Again, this function cleanses those voids"
		>
			<cfArgument name="struct"				required="yes"	type="struct" hint="" />
			<cfArgument name="isEmptyStringNull"	required="no"	type="boolean" default="no" hint="" />
			<cfScript>
				var local = structNew();

				if(arguments.isEmptyStringNull)
				{
					for(local.keyName in arguments.struct)
						if( NOT structKeyExists(arguments.struct , local.keyName) OR arguments.struct[local.keyName] EQ '')
							structDelete(arguments.struct , local.keyName);
				}else
				{
					for(local.keyName in arguments.struct)
						if( NOT structKeyExists(arguments.struct , local.keyName))
							structDelete(arguments.struct , local.keyName);
				}

				return arguments.struct;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "structDeleteEmptyStringValues"
			access		= "public"
			returnType	= "struct"
			hint		= "Fingers a struct and deletes all empty-string values... TODO: allow for recursive specification"
		>
			<cfArgument name="argument_struct"	required="yes"	type="struct" />
			<cfArgument name="isRecursive"		required="no"	type="boolean"	default="no" hint="if a sub struct is incountered, it too will have empty-string values removed" />
			<cfScript>
				var local = structNew();

				for(local.loop in arguments.argument_struct)
				{
					local.loop = arguments.argument_struct[local.x];

					if(
						isSimpleValue(argument_struct[local.loop])
					AND
						NOT len(argument_struct[local.loop])
					)structDelete(argument_struct,local.loop);

					//?recursive on sub structs?
					if(arguments.isRecursive AND isStruct(argument_struct[local.loop]))
						argument_struct[local.loop] = structDeleteEmptyStringValues(argument_struct[local.loop],true);
				}

				Return argument_struct;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "variableNameToTitle"
			returnType	= "string"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= "turns names like 'userName' into 'User Name' or 'Postal_Address' into 'Postal Address'"
		>
			<cfArgument name="name" required="yes" type="string" hint="" />
			<cfScript>
				/* underscore replacement */
					arguments.name	= reReplaceNoCase(arguments.name , "^_|_$" , "" , "all");
					arguments.name	= replace(arguments.name,'_',' ','all');
				/* end */

				/* camel case replacement */
					arguments.name = reReplace(arguments.name , "([a-z])([A-Z]+)" , "\1 \2" , "all" );//lower then upper case word separation
				/* end */

				if(len(arguments.name) GT 1)//Capital first letter
					arguments.name = ucase(left(arguments.name,1)) & right(arguments.name,len(arguments.name)-1);

				return arguments.name;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "reFindAllNoCase"
			returnType	= "struct"
			access		= "public"
			output		= "no"
			description	= "reFind & reFindNoCase only match subexpressions at best. This function returns struct just like reFind BUT returns all matches, not just the first"
			hint		= "ColdFusion reFind does not find all matches"
		>
			<cfArgument name="regX"				required="yes"	type="string"				hint="" />
			<cfArgument name="string"			required="yes"	type="string"				hint="" />
			<cfArgument name="startingPosition"	required="yes"	type="numeric"	default="1"	hint="" />
			<cfScript>
				var local = structNew();

				local.returnStruct = {pos=arrayNew(1) , len=arrayNew(1)};

				while(reFindNoCase(arguments.regX , arguments.string , arguments.startingPosition , false))
				{
					local.find = reFindNoCase(arguments.regX , arguments.string , arguments.startingPosition , true);
					arrayAppend(local.returnStruct.pos , local.find.pos[1]);
					arrayAppend(local.returnStruct.len, local.find.len[1]);
					arguments.startingPosition = local.find.pos[1]+local.find.len[1];
				}

				return local.returnStruct;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "listDeleteLast"
			returnType	= "string"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= "deletes the last element of a list and then returns the new list"
		>
			<cfArgument name="list"			required="yes"	type="string"				hint="" />
			<cfArgument name="delimiters"	required="no"	type="string"	default=","	hint="" />
			<cfReturn listDeleteAt(arguments.list, listLen(arguments.list,arguments.delimiters), arguments.delimiters) />
		</cfFunction>

		<cfFunction
			name		= "trueFalseFormat"
			returnType	= "boolean"
			access		= "public"
			output		= "no"
			description	= "really helps ensuring a variable is either true or false versus 1/0 yes/no"
			hint		= "Always returns false when variable received is not even a boolean"
		>
			<cfArgument name="booleanVariable" required="yes" type="any" hint="" />
			<cfScript>
				if(not isBoolean(arguments.booleanVariable))return false;
				if(arguments.booleanVariable)return true;
				return false;
			</cfScript>
		</cfFunction>

		<cfFunction
			Name		= "genderFormat"
			returnType	= "string"
			Access		= "public"
			Output		= "no"
			Hint		= "converts boolean to male/female or boy/girl"
		>
			<cfArgument name="var"			required="yes"	type="boolean"	hint="" />
			<cfArgument name="isMaleFormat"	required="no"	type="boolean"	default="yes"	hint="When true returns: Male or Female. Otherwise returns Man or Woman" />
			<cfArgument name="isAdult"		required="no"	type="boolean"	default="yes"	hint="When true returns: Male, Female, Man or Woman. When false returns: Boy or Girl" />
			<cfScript>
				if( val(arguments.var) )
				{
					if( arguments.isMaleFormat )
					{
						Return "Male";
					}else if( arguments.isAdult )
					{
						Return "Man";
					}else
					{
						Return "Boy";
					}
				}

				if( arguments.isMaleFormat )
				{
					Return "Female";
				}else if( arguments.isAdult )
				{
					Return "Woman";
				}

				Return "Girl";
			</cfScript>
		</cfFunction>
	<!--- end : extra useful methods --->

</cfComponent>