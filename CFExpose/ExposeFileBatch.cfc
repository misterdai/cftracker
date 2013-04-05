<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	accessors	= "yes"
	extends		= "Batch"
>

	<cfProperty name="Size"			type="numeric" />
	<cfProperty name="Index"		type="numeric" />
	<cfProperty name="BatchSize"	type="numeric" />
	<cfProperty name="PageCount"	type="numeric" setter="no" />
	<cfProperty name="Page"			type="numeric" setter="no" />
	<cfProperty name="PageStartIndex"	type="numeric" setter="no" />
	<cfProperty name="PageLastIndex"	type="numeric" setter="no" />

	<cfProperty name="File" type="ExposeFile" />

	<cfScript>
		variables.size = 0;
		variables.batchSize = 0;
		variables.index = 1;
	</cfScript>

	<cfFunction
		name		= "getBatchSize"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(variables.batchSize eq 0)
				variables.BatchSize = getSize();

			return variables.BatchSize;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getSize"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(variables.size eq 0)
				variables.size = getFile().getLineNumberCount();

			return variables.size;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "gotoPage"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="page" required="yes" type="numeric" hint="" />
		<cfScript>
			super.gotoPage(arguments.page);
			getFile().gotoLine( getPageStartIndex() );
			return this;
		</cfScript>
	</cfFunction>

</cfComponent>