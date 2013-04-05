<cfComponent
	Hint		= "directory based functionality. Set directory once, perform all actions"
	Output		= "no"
	extends		= "ExposeVariable"
>

	<cfFunction
		name		= "getChildDirectories"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="listInfo" required="no" type="string" hint="" />
		<cfScript>
			arguments.type = 'dir';
			arguments.directory = getVar();
			return CFMethods().directoryQuery(argumentCollection=arguments);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setVar"
		returnType	= "ExposeDirectory"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="variable" required="yes" type="string" hint="" />
		<cfScript>
			var lastSpec = listLast(arguments.variable,'/\');

			//last spec contain a dot notation AND confirmed not a directory, trim last spec
			if(reFindNoCase("\..+$", lastSpec, 1, false) AND NOT directoryExists(arguments.variable))
				arguments.variable = getDirectoryFromPath(arguments.variable);

				return super.setVar(arguments.variable);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setPath"
		returnType	= "ExposeFile"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "same as using setVar(file-path)"
	>
		<cfArgument name="filePath" required="yes" type="string" hint="" />
		<cfReturn super.setVar(arguments.filePath) />
	</cfFunction>

	<cfFunction
		name		= "exists"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn directoryExists(getVar()) />
	</cfFunction>

	<cfFunction
		name		= "create"
		returnType	= "any"
		access		= "public"
		output		= "no"
		description	= "creates the set directory"
		hint		= ""
	>
		<cfDirectory directory="#getVar()#" action="create" recurse="yes" />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "delete"
		returnType	= "ExposeDirectory"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfif exists() >
			<cfDirectory directory="#getVar()#" action="delete" recurse="yes" />
		</cfif>
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "deleteSubFoldersByName"
		returnType	= "query"
		access		= "public"
		output		= "no"
		description	= "returns query of folders deleted"
		hint		= "great for deleting hidden directories created throughout folders by third party software such as .svn folders for subversioning"
	>
		<cfArgument name="subFolderName"	required="yes" type="string" hint="" />
		<cfset var local = structNew() />
		<cfset local.path = getVar() />
		<cfDirectory directory="#local.path#" name="local.dirQuery" action="list" recurse="yes" type="dir" sort="directory desc" filter="#arguments.subFolderName#" />
		<cfLoop query="local.dirQuery">
			<cfDirectory directory="#local.path#/#local.dirQuery.name#" action="delete" recurse="yes" />
		</cfLoop>
		<cfReturn local.dirQuery />
	</cfFunction>

	<cfFunction
		name		= "replaceAllInFiles"
		returnType	= "any"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="searchString"		required="yes"	type="string"					hint="" />
		<cfArgument name="replaceString"	required="yes"	type="string"					hint="" />
		<cfArgument name="filter"			required="no"	type="string"					hint="file filter" />
		<cfArgument name="maxDepth"			required="no"	type="numeric"	default="10"	hint="" />
		<cfArgument name="skipNameList"		required="no"	type="string"					hint="" />
		<cfScript>
			var local = structNew();

			local.dirQuery		= readFilesOrderedByHierachy(argumentCollection=arguments);
			local.returnQuery	= queryNew(local.dirQuery.columnList);
			local.columnArray	= listToArray(local.dirQuery.columnList);

			for(local.itemIndex=local.dirQuery.recordCount; local.itemIndex GT 0; --local.itemIndex)
			{
				if(local.dirQuery.type[local.itemIndex] NEQ 'file')
					continue;

				local.filePath		= local.dirQuery.directory[local.itemIndex]&'/'&local.dirQuery.name[local.itemIndex];
				local.fileContents	= fileRead(local.filePath);

				if(NOT findNoCase(arguments.searchString, local.fileContents))
					continue;

				local.fileContents = replaceNoCase(local.fileContents, arguments.searchString, arguments.replaceString, 'all');

				fileWrite(local.filePath, local.fileContents);

				/* append to return query that it was modified */
					queryAddRow(local.returnQuery);
					for(local.aIndex=arraylen(local.columnArray); local.aIndex GT 0; --local.aIndex)
					{
						local.columnName = local.columnArray[local.aIndex];
						querySetCell(local.returnQuery, local.columnName, local.dirQuery[local.columnName][local.itemIndex], local.returnQuery.recordCount);
					}
				/* end */
			}

			return local.returnQuery;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getChildQuery"
		returnType	= "query"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="sort"			required="no"	type="string"		default="asc"	hint="" />
		<cfArgument name="filter"		required="no"	type="string"		default=""		hint="" />
		<cfArgument name="recurse"		required="no"	type="boolean"		default="no"	hint="" />
		<cfArgument name="type"			required="no"	type="variableName"	default="all"	hint="" />
		<cfset var local = structNew() />
		<cfDirectory directory="#getVar()#" name="local.results" action="list" recurse="#arguments.recurse#" type="#arguments.type#" sort="#arguments.sort#" filter="#arguments.filter#" />
		<cfReturn local.results />
	</cfFunction>

	<cfFunction
		Name		= "readFilesOrderedByHierachy"
		returnType	= "query"
		Access		= "public"
		Output		= "no"
		Hint		= "Returns cfDirectory recursive directory read. Ordered by sort condition and grouped by folder depth"
		Description	= "Useful when you want to utilize scripts that have an order dependency represented by folder depth"
	>
		<cfArgument name="sort"				required="no"	type="string"	default="asc"	hint="" />
		<cfArgument name="filter"			required="no"	type="string"					hint="" />
		<cfArgument name="maxDepth"			required="no"	type="numeric"	default="10"	hint="" />
		<cfArgument name="skipNameList"		required="no"	type="string"					hint="" />
		<cfArgument name="listInfo"			required="no"	type="string"					hint="name|all" />
		<cfArgument name="directory"		required="no"	type="string" 					hint="this argument only here to expose recursion. this argument should never be set" />
		<cfArgument name="slash"			required="no"	type="string"					hint="\ or / ... leave blank for auto detect" />
		<cfScript>
			var local = structNew();

			if(!structKeyExists(arguments, 'slash'))
				arguments.slash = CFMethods().CF().getSystemSlash();

			if( NOT structKeyExists(arguments, "directory") )
				arguments.directory = getVar();

			local.directoryCollection=
			{
				directory	= arguments.directory
				,sort		= arguments.sort
				,name		= 'local.dirQuery'
				,action		= 'list'
				,type		= 'dir'
				,listInfo	= 'name'
			};

			local.fileCollection=
			{
				directory	= arguments.directory
				,sort		= arguments.sort
				,name		= 'local.fileQuery'
				,action		= 'list'
				,type		= 'file'
			};

			if(structKeyExists(arguments,"filter"))
				local.fileCollection.filter=arguments.filter;

			if(structKeyExists(arguments, "listInfo"))
				local.fileCollection.listInfo=arguments.listInfo;
		</cfScript>
		<cfDirectory attributeCollection="#local.fileCollection#" />
		<cfDirectory attributeCollection="#local.directoryCollection#" />
		<cfScript>
			local.ExposedFile	= new('ExposeQuery').init(local.fileQuery);
			local.ExposedDir	= new('ExposeQuery').init(local.dirQuery);

			if( structKeyExists( arguments , "skipNameList" ) )
			{
				/* loop files */
					for( local.x=1; local.x lte local.fileQuery.recordCount; ++local.x )
					{
						local.directory	= local.fileQuery.directory[local.x];
						local.name		= local.fileQuery.name[local.x];
						local.path		= listAppend(local.directory , local.name , arguments.slash) & arguments.slash;

						if( listFindNoCase( arguments.skipNameList , local.name ) )
						{
							local.ExposedFile.deleteRow(local.x);
							--local.x;
						}
					}
				/* end */
			}

			/* loop directories */
				if( arguments.maxDepth )
				{
					for( local.x=1; local.x lte local.dirQuery.recordCount; ++local.x)
					{
						local.directory = arguments.directory;
						local.name		= local.dirQuery.name[local.x];
						local.path		= listAppend( local.directory , local.name , arguments.slash ) & arguments.slash;

						if
						(
							structKeyExists(arguments , "skipNameList")
						AND
							listFindNoCase(arguments.skipNameList , local.name)
						)
							local.dirQuery = local.ExposedDir.deleteRow(local.x).getVar();
						else
						{
							local.collection			= duplicate(arguments);
							local.collection.maxDepth	= arguments.maxDepth - 1;
							local.collection.directory	= local.path;
							local.collection.slash		= arguments.slash;

							if(structKeyExists(arguments, "listInfo"))
								local.collection.listInfo = arguments.listInfo;

							local.childQuery = readFilesOrderedByHierachy(argumentCollection=local.collection);

							if(structKeyExists(arguments, "listInfo") AND arguments.listInfo EQ 'name')
								local.childQuery = Expose(local.childQuery).prependToColumn(local.name & arguments.slash, 'name').getVar();

							local.ExposedFile.appendQuery(local.childQuery);

						}
					}
				}
			/* end */

			Return local.ExposedFile.getVar();
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getImageFiles"
		access		= "public"
		returnType	= "query"
		output		= "no"
		hint		= "Returns image only files query with image columns information"
	>
		<cfArgument name="max"			required="no"	type="numeric"		hint="" />
		<cfset var local = structNew() />
		<cfset local.path = getVar() />
		<cfDirectory action="list" name="local.imageDir" directory="#local.path#" filter="*.gif|*.jpeg|*.jpg|*.png" />
		<cfset queryAddColumn( local.imageDir , "width" , arrayNew(1) ) />
		<cfset queryAddColumn( local.imageDir , "height" , arrayNew(1) ) />

		<cfoutput query="local.imageDir">
			<cfTry>
				<cfimage
					name	= "cfImage"
					source	= "#local.path##name#"
					action	= "read"
				/>
				<cfCatch>
					<cfset local.imageDir.width[local.imageDir.currentRow] = 0 />
					<cfset local.imageDir.height[local.imageDir.currentRow] = 0 />
				</cfCatch>
			</cfTry>
			<cfset local.imageDir.width[local.imageDir.currentRow] = cfImage.width />
			<cfset local.imageDir.height[local.imageDir.currentRow] = cfImage.height />
		</cfoutput>

		<cfif structKeyExists( arguments , "max" ) >
			<cfset local.imageDir = Expose(local.imageDir).selectTopRows(arguments.max ) />
		</cfif>

		<cfReturn local.imageDir />
	</cfFunction>

	<cfFunction
		name		= "copyTo"
		access		= "public"
		output		= "no"
		returnType	= "string"
	>
		<cfArgument name="destination"	required="yes"	type="string" />
		<cfArgument name="nameConflict"	required="no"	type="string"	default="error" />
		<cfArgument name="filter"		required="no"	type="string"	default="*" />
		<cfArgument name="source"		required="no"	type="string" 		hint="this argument only here to expose recursion. this argument should never be set" />
		<cfScript>
			var local = structNew();

			local.systemSlash = CFMethods().CF().getSystemSlash();

			local.returnVariable = "";
			if( NOT structKeyExists(arguments, "source") )
				arguments.source = getVar();

			if( right(arguments.source,1) neq local.systemSlash )
				arguments.source = arguments.source & local.systemSlash;

			if( right(arguments.destination,1) neq local.systemSlash )
				arguments.destination = arguments.destination & local.systemSlash;
		</cfScript>
		<!--- create destination dir if not exist --->
			<cfif not directoryExists(arguments.destination) >
				<cfdirectory action="CREATE" directory="#arguments.destination#" />
				<cfset local.returnVariable = listAppend(local.returnVariable, arguments.destination , chr(10) ) />
			</cfif>
		<!--- end --->

		<!--- get all files listed --->
			<cfDirectory
				action		= "list"
				Directory	= "#arguments.source#"
				Name		= "local.qryDirList"
				filter		= "#arguments.filter#"
			/>
		<!--- end --->

		<cfoutput query="local.qryDirList">
			<cfif Type eq "Dir" >
				<cfset local.temp = copyTo(source=arguments.source&local.qryDirList.name[local.qryDirList.currentRow], destination=arguments.destination&local.qryDirList.name[local.qryDirList.currentrow], nameConflict=arguments.nameConflict, filter=arguments.filter) />
				<cfset local.returnVariable = listAppend(local.returnVariable, local.temp, chr(10)) />
			<cfelseif
				arguments.nameConflict eq "overwrite"
			or
				NOT fileExists(arguments.destination&local.qryDirList.name[local.qryDirList.currentRow])
			>
				<cffile
					action		= "COPY"
					source		= "#arguments.source&local.qryDirList.Name[local.qryDirList.currentrow]#"
					destination	= "#arguments.destination&local.qryDirList.Name[local.qryDirList.currentrow]#"
				>
				<cfset local.returnVariable = listAppend(local.returnVariable, arguments.destination&local.qryDirList.Name[local.qryDirList.currentrow], chr(10)) />
			<cfelseif
				arguments.nameConflict neq "skip"
			>
				<cfThrow message="<b>Cannot Copy</b>: #arguments.source&name#<br />Naming Conflict at: #arguments.destination&name#<hr />To overwrite set nameConflict='overwrite'<br />Currently nameConflict='#arguments.nameConflict#'" />
			</cfif>
		</cfoutput>
		<cfReturn local.returnVariable />
	</cfFunction>

	<cfFunction
		name		= "getUrlRelativeToCurrentRequest"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn getUrlRelativeToDirectoryUrl(expandPath('./'), cgi.script_name) />
	</cfFunction>

	<cfFunction
		name		= "getCommonPathWithDirectory"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "gets common parent directory path"
	>
		<cfArgument name="path2" required="yes" type="string" hint="" />
		<cfScript>
			var local = structNew();

			arguments.path1 = getVar();

			local.path1Array	= listToArray(arguments.path1, '/\');
			local.path2Array	= listToArray(arguments.path2, '/\');
			local.path1Len		= arrayLen(local.path1Array);
			local.path2Len		= arrayLen(local.path2Array);

			if(local.path1Len > local.path2Len)
				local.longestListLen = local.path1Len;
			else
				local.longestListLen = local.path2Len;

			if(local.path1Len > local.path2Len)
				local.shortestListLen = local.path2Len;
			else
				local.shortestListLen = local.path1Len;

			for(local.pathIndex=1; local.pathIndex LTE local.shortestListLen; ++local.pathIndex)
			{
				if(local.path1Array[local.pathIndex] NEQ local.path2Array[local.pathIndex])
				{
					--local.pathIndex;
					break;
				}
			}

			if(local.pathIndex EQ local.shortestListLen+1)
				local.pathIndex=local.pathIndex-1;//throw '#local.pathIndex# #arguments.path1# - #arguments.path2#';

			for(local.listIndex=local.longestListLen; local.listIndex > local.pathIndex; --local.listIndex)
				if(local.path1Len GTE local.listIndex)
					arguments.path1	= listDeleteAt(arguments.path1, local.listIndex, '/\');

			return arguments.path1;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getUrlRelativeToDirectoryUrl"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= "a return of empty string indicates an incompatible path"
		description	= ""
	>
		<cfArgument name="pathForUrl"	required="yes" type="string" hint="" />
		<cfArgument name="urlForPath"	required="yes" type="string" hint="" />
		<cfScript>
			var local = structNew();

			local.instancePath	= getVar();
			local.mappingUrl	= '';
			local.pathForUrl	= arguments.pathForUrl;

			/* Remove file names. Ensure pathForUrl & urlForPath both do no contain a file name */
				if(reFindNoCase("[^.]+\.[^.]+$", listLast(local.pathForUrl,'/\'), 1, false))
					local.pathForUrl = listDeleteAt(local.pathForUrl, listLen(local.pathForUrl,'/\'), '/\');

				if(reFindNoCase("[^.]+\.[^.]+$", listLast(arguments.urlForPath,'/\'), 1, false))
					arguments.urlForPath = listDeleteAt(arguments.urlForPath, listLen(arguments.urlForPath,'/\'), '/\');
			/* end */

			/* Do the application url and mapping have a common parent path */
				local.commonParentPath = getCommonPathWithDirectory(local.pathForUrl);

				local.commonPathLen = listLen(local.commonParentPath,'/\');

				if(local.commonPathLen)
				{
					local.newPath = replace(local.instancePath,'\','/','all');

					/* trim folders off mapping */
						local.mapPathLen = listLen(local.newPath,'/\');
						local.rootdiff = local.mapPathLen - local.commonPathLen;

						if(local.rootdiff)
							for(local.pathIndex=1; local.pathIndex LTE (local.mapPathLen-local.rootdiff); ++local.pathIndex)
								local.newPath = listDeleteAt(local.newPath,1,'/\');
					/* end */

					/* trim folders off application url */
						local.appPathLen = listLen(local.pathForUrl,'/\');
						local.diff = local.appPathLen - local.commonPathLen;

						local.appUrlPathLen = listLen(arguments.urlForPath,'/\');
						local.appUrlDiff = local.appUrlPathLen - local.diff;

						local.urlForPath = arguments.urlForPath;

						if(local.diff GT 0 AND local.appUrlDiff GT 0)
							for(local.pathIndex=local.appUrlPathLen; local.pathIndex GT local.appUrlDiff; --local.pathIndex)
								local.urlForPath = listDeleteAt(local.urlForPath,local.pathIndex,'/\');

						if(local.appUrlDiff GT 0 AND local.rootdiff GT 0)
						{
							/* ensure paths will attach correctly */
								if(left(local.newPath,1) EQ '/')
									local.newPath = right(local.newPath,len(local.newPath)-1);

								if(right(local.urlForPath,1) NEQ '/')
									local.urlForPath = local.urlForPath & '/';

								local.mappingUrl = local.urlForPath & local.newPath;

								if(right(local.mappingUrl,1) NEQ '/')
									local.mappingUrl &= '/';
							/* end */
						}else if(local.diff GTE 1 AND local.appUrlDiff EQ 0)
						{
							local.rightOfPath = reReplaceNoCase(local.instancePath, '([^/\\]+(\/|\\)){#local.commonPathLen#}', '', 'one');
							local.rightOfPath = listChangeDelims(local.rightOfPath, '/', "\");
							local.mappingUrl = local.rightOfPath;

							if(right(local.mappingUrl,1) NEQ '/')
								local.mappingUrl &= '/';
						}else if(local.diff GTE 1 AND (local.appUrlDiff EQ 0 OR NOT local.rootdiff))
						{
							local.mappingUrl = arguments.urlForPath;
							for(local.x=1; local.x LTE local.diff; ++local.x)
								local.mappingUrl = listDeleteAt(local.mappingUrl, listLen(local.mappingUrl,'/\'), '/\');

							if(right(local.mappingUrl,1) NEQ '/')
								local.mappingUrl &= '/';
						}else if(local.rootdiff GT 0 AND local.appUrlDiff EQ 0)
						{
							local.mappingUrl = listChangeDelims(local.newPath, '/', "\");

							if(right(local.mappingUrl,1) NEQ '/')
								local.mappingUrl &= '/';
						}
					/* end */

				}
			/* end */

			return local.mappingUrl;
		</cfScript>
	</cfFunction>

</cfComponent>