<cfComponent
	Hint		= "directory based functionality. Set directory once, perform all actions"
	Output		= "no"
	extends		= "CFExpose.ExposeFile"
	accessors	= "yes"
>

	<cfProperty name="LineNumberCount"	type="numeric" setter="false" />
	<cfProperty name="Batch"			type="CFExpose.Batch" />
	<cfProperty name="CsvConfig"		type="CsvConfig" />
	<cfProperty name="Parser"			type="CsvConfig" />
	<cfProperty name="HeaderRow"		type="string" />

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
		name		= "getParser"
		returnType	= "CsvString"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(structKeyExists(variables, "Parser"))
				return variables.Parser;

			variables.Parser = new CsvString(CsvConfig=getCsvConfig());

			//sets string
			gotoNextPage();

			return variables.Parser;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "gotoNextPage"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			local.Parser = getParser();

			local.ReadBatchSize = getBatch().getBatchSize();
			local.CsvConfig = getCsvConfig();

			local.isFirstRowAsHeaders = local.CsvConfig.isFirstRowAsHeaders();
			local.isFirstPage = getBatch().getPage() EQ 1;

			if(local.isFirstRowAsHeaders AND local.isFirstPage)
			{
				local.readLines = getNextLines(local.ReadBatchSize+1);

				local.Parser.setCsvString(local.readLines);
			}
			else
			{
				local.readLines = getNextLines(local.ReadBatchSize);
				local.readLines = getHeaderRow() & chr(10) & local.readLines;
				local.Parser.setCsvString(local.readLines);
			}

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setHeaderRow"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="HeaderRow" required="yes" type="string" hint="" />
		<cfScript>
			variables.HeaderRow = arguments.HeaderRow;
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getHeaderRow"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if( NOT structKeyExists(variables, "HeaderRow") )
			{
				local.openedFile = FileOpen(getVar());
				local.lineOne = FileReadLine(local.openedFile);
				FileClose(local.openedFile);
				return local.lineOne;
			}

			return variables.HeaderRow;
		</cfScript>
	</cfFunction>

</cfComponent>