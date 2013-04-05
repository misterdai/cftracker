<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	extends		= "CFExpose.ColumnKit.NamePositionModel"
	accessors	= "yes"
	Decorator	= "DecorateColumn"
>

	<cfProperty name="nameArray"	type="array" />
	<cfProperty name="Array"		type="array" set="no" />
	<cfProperty name="Row"			type="CFExpose.ColumnKit.Row" />

	<cfFunction
		name		= "getByName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfScript>
			local.Column = super.getByName(arguments.name);

			if(!structKeyExists(local, 'Column'))
			{
				local.Column = getRow().getByName(arguments.name);

				if(isNull(local.Column))
				{
					throw(message='The column #arguments.name#, could not be found.');
				}

				setColumnDecoratorByName(local.Column);
				local.Column = super.getByName(arguments.name);
			}

			return local.Column;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setColumnDecorator"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Column"		required="yes" type="Column" hint="" />
		<cfArgument name="Decorator"	required="yes" type="DecorateColumn" hint="" />
		<cfScript>
			arguments.Decorator.setColumn(arguments.Column);
			return setByName(arguments.Decorator, arguments.Column.getName());
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setColumnDecoratorByName"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="Column"	required="yes"	type="Column"	hint="" />
		<cfArgument name="name"		required="no"	type="string"	hint="" />
		<cfArgument name="type"		required="no"	type="string"	hint="" />
		<cfScript>
			if(!structKeyExists(arguments, 'name'))
				arguments.name = iExpose(this).getAttribute('Decorator');

			local.Decorator = new(arguments.name);

			if(structKeyExists(arguments, "type"))
				local.Decorator.setType(arguments.type);

			setColumnDecorator(arguments.Column, local.Decorator);

			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getOutputByName"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="name" required="yes" type="string" hint="" />
		<cfScript>
			return getByName(arguments.name).getOutput();
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getValueStruct"
		returnType	= "struct"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="isEmptyStringMode" required="no" type="boolean" default="0" hint="" />
		<cfScript>
			local.struct = structNew();
			local.cArray = getRow().getArray();

			for(local.x=1; local.x LTE arrayLen(local.cArray); ++local.x)
			{
				local.Column = local.cArray[local.x];
				local.name = local.Column.getName();
				local.Decorator = getByName(local.name);
				local.value = local.Decorator.getOutput();

				if((structKeyExists(local, "value") and len(local.value)) or arguments.isEmptyStringMode)
					local.struct[local.Decorator.getColumn().getName()] = local.value;

			}

			return local.struct;
		</cfScript>
	</cfFunction>

</cfComponent>