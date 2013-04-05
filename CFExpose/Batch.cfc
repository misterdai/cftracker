<cfComponent
	Description	= ""
	Hint		= ""
	output		= "no"
	accessors	= "yes"
	Extends		= "ComponentExtension"
>

	<cfProperty name="Size"			type="numeric" />
	<cfProperty name="Index"		type="numeric" />
	<cfProperty name="BatchSize"	type="numeric" />
	<cfProperty name="PageCount"	type="numeric" setter="no" />
	<cfProperty name="Page"			type="numeric" setter="no" />
	<cfProperty name="PageStartIndex"	type="numeric" setter="no" />
	<cfProperty name="PageLastIndex"	type="numeric" setter="no" />

	<cfScript>
		variables.size = 0;
		variables.batchSize = 1;
		variables.index = 1;
	</cfScript>

	<cfFunction
		name		= "isMax"
		returnType	= "boolean"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return getIndex() GTE getSize();
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "setIndex"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="num" required="yes" type="numeric" hint="" />
		<cfScript>
			var s = getSize();
			if(num > s)num = s;

			return set('Index',num);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "next"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			setIndex( getIndex() + getBatchSize() );
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "nextPage"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			setIndex( getPageLastIndex()+1 );
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "backPage"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			setIndex( getPageStartIndex() - getBatchSize() );
			return this;
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
			if(arguments.page GT getPage())
			{
				while(arguments.page GT 0 AND arguments.page GT getPage())
					nextPage();
			}else
			{
				while(arguments.page GT 0 AND arguments.page LT getPage())
					backPage();
			}
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "back"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			setIndex( getIndex() - getBatchSize() );
			return this;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "gotoEnd"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return setIndex(getSize());
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "restart"
		returnType	= "any"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return setIndex(0);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getPage"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return ceiling(getIndex() / getBatchSize());
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getPageCount"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return ceiling(getSize() / getBatchSize());
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getPageStartIndex"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return abs(ceiling((getBatchSize() * max(getPage(),1)) - getBatchSize()) + 1);
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "getPageLastIndex"
		returnType	= "numeric"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfScript>
			return min(getPageStartIndex() + getBatchSize() - 1, getSize());
		</cfScript>
	</cfFunction>

</cfComponent>