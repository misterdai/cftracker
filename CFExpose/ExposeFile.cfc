<cfComponent
	Hint		= "per file functionality"
	output		= "no"
	extends		= "ExposeVariable"
>

	<cfProperty name="Var"				type="any" />
	<cfProperty name="Info"				type="struct" setter="false" />
	<cfProperty name="LineNumberCount"	type="numeric" setter="false" />
	<cfProperty name="Batch"			type="CFExpose.Batch" />
	<cfScript>
		setVarValidateByTypeName('string');
	</cfScript>

	<cfFunction
		name		= "getBatch"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= "controls the file line walking"
		description	= ""
	>
		<cfScript>
			if(!structKeyExists(variables, 'Batch'))
				variables.Batch = new ExposeFileBatch(File=this);

			return variables.Batch;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "write"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="content" required="yes" type="string" hint="" />
		<cfFile action="write" file="#getVar()#" output="#arguments.content#" addNewLine="no" fixnewline="yes" nameConflict="overwrite" />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "enableFullControl"
		returnType	= "ExposeFile"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "fileSetAccessMode(getVar(), '777')"
	>
		<cfset fileSetAccessMode(getVar(), '777') />
		<cfReturn this />
	</cfFunction>

	<cfFunction
		name		= "getInfo"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfReturn GetFileInfo(getVar()) />
	</cfFunction>

	<cfFunction
		name		= "rename"
		returnType	= "ExposeFile"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="rename" required="yes" type="string" hint="" />
		<cfset var local = structNew() />
		<cfset local.currentNamePath = getVar() />
		<cfset local.newNamePath = getDirectoryFromPath(local.currentNamePath) & arguments.rename />
		<cfFile action="rename" destination="#local.newNamePath#" source="#local.currentNamePath#" />
		<cfset setVar(local.newNamePath) />
		<cfReturn this />
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
		name		= "getSize"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="format" required="no" type="variableName" default="mb" hint="mb or kb(also:k)" />
		<cfset var local = structNew() />
		<cfDirectory directory="#getDirectoryFromPath(getVar())#" name="local.fileRead" action="list" recurse="no" type="file" sort="asc" filter="#listLast(getVar(),'\\/')#" />
		<cfSwitch expression="#arguments.format#">
			<cfCase value="k,kb" delimiters=",">
				<cfReturn local.fileRead.size />
			</cfCase>
			<cfDefaultCase>
				<cfReturn local.fileRead.size / (1024*1024) />
			</cfDefaultCase>
		</cfSwitch>
	</cfFunction>

	<!--- open file functionality --->
		<cfFunction
			name		= "open"
			returnType	= "exposeFile"
			access		= "public"
			output		= "no"
			description	= "reserves file reading"
			hint		= "Part 1 of 2 step process: Do not forget to close() when done"
		>
			<cfScript>
				variables.openedFile = FileOpen(getvar() , 'read');
				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getOpenedFile"
			returnType	= "any"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				if(structKeyExists(variables, "OpenedFile"))
					return variables.OpenedFile;

				open();
				return variables.OpenedFile;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "close"
			returnType	= "ExposeFile"
			access		= "public"
			output		= "no"
			description	= "unreserves file reading"
			hint		= "Part 2 of 2 step process: unlocking the file previously locked using the method 'open'"
		>
			<cfScript>
				getBatch().restart();
				if(structKeyExists(variables, "openedFile"))
				{
					fileClose(variables.openedFile);
					structDelete(variables , "openedFile" , true);
				}
				return this;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "isOpen"
			returnType	= "boolean"
			access		= "private"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfReturn structKeyExists(variables , "openedFile") />
		</cfFunction>

		<cfFunction
			name		= "errorWhenClosedForMethod"
			returnType	= "void"
			access		= "private"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="methodName" required="yes" type="variableName" hint="" />
			<cfif NOT isOpen() >
				<cfThrow
					message	= "You have not yet opened the file: #getVar()#"
					detail	= "The method '#arguments.methodName#' requires you first 'open' the file by using the method 'open'. But be sure to unlock the file after working with the file with the method 'close'"
				/>
			</cfif>
		</cfFunction>

		<cfFunction
			name		= "getNextLines"
			returnType	= "string"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfArgument name="lineCount" required="no" type="numeric" hint="" />
			<cfScript>
				var local = structNew();

				if(!structKeyExists(arguments, 'lineCount'))
					arguments.lineCount = getBatch().getBatchSize();

				local.linesLeft = getLineNumberCount() - getBatch().getIndex();
				if(arguments.lineCount GT local.linesLeft)
					arguments.lineCount = local.linesLeft;

				local.openFile = getOpenedFile();

				if(FileIsEOF(local.openFile))
					return '';

				local.fileRead = FileReadLine(local.openFile);
				local.Batch = getBatch();

				errorWhenClosedForMethod('getNextLines');

				for(local.lineLoop=2; local.lineLoop LTE arguments.lineCount; ++local.lineLoop)
				{
					local.fileRead &= chr(10) & FileReadLine(local.openFile);
					local.Batch.next();
					if(FileIsEOF(local.openFile))break;
				}

				Return local.fileRead;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "isEndOfFile"
			returnType	= "boolean"
			access		= "public"
			output		= "no"
			hint		= ""
			description	= ""
		>
			<cfScript>
				return fileIsEOF(getOpenedFile());
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "getLineNumberCount"
			returnType	= "numeric"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfScript>
				if(!structKeyExists(variables, 'lineNumberCount'))
				{
					variables.lineNumberCount = 0;

					local.openFile = FileOpen(getvar() , 'read');

					while(NOT FileIsEOF(local.openFile))
					{
						FileReadLine(local.openFile);
						++variables.lineNumberCount;
					}

					FileClose(local.openFile);
				}

				return variables.lineNumberCount;
			</cfScript>
		</cfFunction>

		<cfFunction
			name		= "isEndReached"
			returnType	= "boolean"
			access		= "public"
			output		= "no"
			description	= ""
			hint		= ""
		>
			<cfset errorWhenClosedForMethod('isEndReached') />
			<cfReturn FileIsEOF(variables.openedFile) />
		</cfFunction>
	<!--- end --->

	<cfFunction
		name		= "gotoLine"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="lineNumber" required="yes" type="numeric" hint="" />
		<cfScript>
			arguments.lineNumber = round(abs(arguments.lineNumber));

			if(arguments.lineNumber GT getBatch().getIndex())
				close();

			local.openFile = getOpenedFile();
			local.Batch = getBatch();

			while(!FileIsEOF(local.openFile) and local.Batch.getIndex() LT arguments.lineNumber)
			{
				FileReadLine(local.openFile);
				local.Batch.next();
			}

			return this;
		</cfScript>
	</cfFunction>

</cfComponent>