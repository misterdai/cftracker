<cfComponent
	Description	= "adds private extension to all components AND creates access to ColdFusion adon functionality. Also adds private method 'Class' as a helper to all componets to classify themselves"
	Hint		= "recommended all components extend this component."
	output		= "no"
	extends		= "CFMethodsExtension"
>

	<cfFunction
		name		= "init"
		returnType	= "any"
		access		= "public"
		output		= "no"
	>
		<cfScript>
			for(local.key in arguments)
			{
				if(structKeyExists(arguments, local.key))
				{
					if(structKeyExists(variables, "set#local.key#"))
						evaluate("variables.set#local.key#(arguments[local.key])");
					else if(structKeyExists(this, "set#local.key#"))
						evaluate("this.set#local.key#(arguments[local.key])");
				}

				if
				(
					left(local.key,2) EQ 'is'
				AND
					structKeyExists(variables, local.key)
				AND
					isBoolean(arguments[local.key])
				)
					evaluate("variables.#local.key#(arguments[local.key])");
			}

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "new"
		returnType	= "any"
		access		= "private"
		output		= "no"
		hint		= ""
		description	= "ColdFusion 7 and 8 equivalnt to CF9 new syntax"
	>
		<cfArgument name="name"				required="yes"	type="string" hint="" />
		<cfArgument name="initCollection"	required="no"	type="struct" default="#structNew()#" hint="" />
		<cfScript>
			local.Component = Expose(this).getRelativeComponentByName(arguments.name);

			if(structKeyExists(local.Component, "init"))
				local.Component.init(argumentCollection=arguments.initCollection);

			return local.Component;
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
		<cfArgument name="name"		required="yes"	type="string"	hint="" />
		<cfArgument name="value"	required="yes"	type="any"		hint="" />
		<cfArgument name="scope"	required="no"	type="struct"	hint="default=variables scope" />
		<cfScript>
			if(!structKeyExists(arguments, 'scope'))
				arguments.scope = variables;

			arguments.scope[arguments.name] = arguments.value;

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "get"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="name"			required="yes"	type="string"	hint="" />
		<cfArgument name="isThrowError"	required="no"	type="boolean"	hint="" />
		<cfArgument name="scope"		required="no"	type="struct"	hint="default=variables scope" />
		<cfScript>
			if(!structKeyExists(arguments, 'scope'))
				arguments.scope = variables;

			if(structKeyExists(arguments.scope, arguments.name))
				return arguments.scope[arguments.name];

			// ? undefined
			if(!structKeyExists(arguments, 'isThrowError') OR !arguments.isThrowError)
				return;

			arguments.message = '"#arguments.name#", Not Yet Set';
			local.cName = getMetaData(this).name;

			if(structKeyExists(variables, "set#arguments.name#"))
				arguments.detail = 'Use the method "set#arguments.name#" in component "#local.cName#"';
			else
				arguments.detail = 'Use the method "set" in component "#local.cName#"';
		</cfScript>
		<cfThrow message="#local.message#" detail="#local.detail#" />
	</cfFunction>

	<cfFunction
		name		= "param"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= "returns the current value. may return void if value passed is null"
	>
		<cfArgument name="name"		required="yes"	type="string"	hint="" />
		<cfArgument name="value"	required="no"	type="any"		hint="" />
		<cfArgument name="scope"	required="no"	type="struct"	hint="default=variables scope" />
		<cfScript>
			if(!structKeyExists(arguments, "scope"))
				arguments.scope = variables;

			if(!structKeyExists(arguments.scope, arguments.name) AND structKeyExists(arguments, "value"))
			{
				arguments.scope[arguments.name] = arguments.value;
				return arguments.value;
			}

			if(structKeyExists(arguments.scope, arguments.name))
				return arguments.scope[arguments.name];
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "Expose"
		returnType	= "ExposeVariable"
		access		= "private"
		output		= "no"
		description	= ""
		hint		= "types:component,object,entity,query,directory,file"
	>
		<cfArgument name="var"	required="yes"	type="any"			hint="" />
		<cfArgument name="type"	required="no"	type="variableName"	hint="" />
		<cfScript>
			if(NOT structKeyExists(variables, "CFExpose"))
				variables.CFExpose = createObject("component", "CFExpose");

			return variables.CFExpose.Expose(argumentCollection=arguments);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "IFNULL"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= "if argument1 is null or empty string, then returns argument 2 or null"
		description	= ""
	>
		<cfArgument name="var1" required="no" type="any" hint="" />
		<cfArgument name="var2" required="no" type="any" hint="" />
		<cfScript>
			if(structKeyExists(arguments, 'var1') AND (!isSimpleValue(arguments.var1) OR len(arguments.var1)))
				return arguments.var1;

			if(structKeyExists(arguments, "var2"))
				return arguments.var2;

			return;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "iExpose"
		returnType	= "ExposeComponent"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			if(NOT structKeyExists(variables, "_iExpose"))
				variables._iExpose = Expose(this);

			return variables._iExpose;
		</cfScript>
	</cfFunction>

</cfComponent>
