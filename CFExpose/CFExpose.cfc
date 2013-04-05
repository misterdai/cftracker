<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	extends		= "CFMethodsController"
>

	<cfFunction
		name		= "Expose"
		returnType	= "ExposeVariable"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "types:component,object,entity,query,directory,file"
	>
		<cfArgument name="var"	required="yes"	type="any"			hint="" />
		<cfArgument name="type"	required="no"	type="variableName"	hint="" />
		<cfScript>
			if(not structKeyExists(arguments , "type"))
			{
				arguments.type="";

				//!!deprecated : delete next condition and result soon after 05/15/2012
				if(isSimpleValue(arguments.var) AND arguments.var eq 'coldfusion')
					createObject("component", "CFMethods").throw('Developer error. Use CFMethods().CF() instead of Expose("coldfusion")');

				if(isQuery(arguments.var))
					arguments.type='query';
				else if(isObject(arguments.var))
					arguments.type='component';
			}

			switch(arguments.type)
			{
				case 'component'	:
				case 'object'		: return createObject("component", "ExposeComponent").init(arguments.var);
				case 'entity'		: return createObject("component", "ExposeEntity").init(arguments.var);
				case 'query'		: return createObject("component", "ExposeQuery").init(arguments.var);
				case 'directory'	: return createObject("component", "ExposeDirectory").init(arguments.var);
				case 'file'			: return createObject("component", "ExposeFile").init(arguments.var);
				default				: return createObject("component", "ExposeVariable").init(arguments.var);
			}
		</cfScript>
	</cfFunction>

</cfComponent>
