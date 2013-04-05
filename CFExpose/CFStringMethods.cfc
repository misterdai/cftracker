<cfComponent
	Hint		= ""
	Output		= "no"
	extends		= "CFMethods"
>

	<cfFunction
		name		= "htmlEditFormatDecode"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="string" required="yes" type="string" hint="" />
		<cfScript>
			arguments.string = reReplaceNoCase(arguments.string, '&lt;', '<', 'all');
			arguments.string = reReplaceNoCase(arguments.string, '&gt;', '>', 'all');
			arguments.string = reReplaceNoCase(arguments.string, '&quot;', '"', 'all');
			arguments.string = reReplaceNoCase(arguments.string, '&amp;', '&', 'all');

			return arguments.string;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "removeLeftTabs"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= ""
		description	= ""
	>
		<cfArgument name="string"	required="yes" type="string" hint="" />
		<cfArgument name="tabCount"	required="no" type="numeric" default="0" hint="" />
		<cfScript>
			if(!arguments.tabCount)
				arguments.tabCount = '*';
			else
				arguments.tabCount = '{#arguments.tabCount#}';

			return reReplaceNoCase(arguments.string, '(^|\r|\n)\t#arguments.tabCount#', '\1', 'all');
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "removeTags"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= "removes all html tags from string"
		description	= ""
	>
		<cfArgument name="string" required="yes" type="string" hint="" />
		<cfScript>
			return reReplaceNoCase(arguments.string, '<([^ \r\n\t<]+)?[^<]+>', '', 'all');
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "prependToEachLine"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= "string will be returned with every new line having the requested added string"
	>
		<cfArgument name="string"			required="yes"	type="string"	hint="" />
		<cfArgument name="prependString"	required="yes"	type="string"	hint="" />
		<cfScript>
			var local = structNew();
			local.string = arguments.prependString&arguments.string;
			return reReplaceNoCase(local.string , '(\r|\n)' , '\1'&arguments.prependString , 'all');
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "midSlim"
		returnType	= "string"
		access		= "public"
		output		= "no"
		hint		= "limit a string to so many charactersto be reduced left and right equally"
		description	= "Example: abctesting123 (maxlength 9) = abc...123"
	>
		<cfArgument name="string"				required="yes"	type="string"					hint="String to be but down in size" />
		<cfArgument name="maxLength"			required="no"	type="numeric"	default="35"	hint="Maxlength that string can be before being cut, If no value provided, then cuts at 35 chrs" />
		<cfArgument name="cutOffString"			required="no"	type="string"	default="..."	hint="" />
		<cfScript>
			if(len(arguments.string) LTE arguments.maxLength)
				return arguments.string;

			local.len = len(arguments.string);
			local.len = (local.len - (local.len - arguments.maxLength)) - len(arguments.cutOffString);

			local.right = local.len / 2;
			local.left = round(local.right);

			if(local.right GT local.left)
				local.left = fix(local.left);
			else if(local.right LT local.left)
				local.right = fix(local.right);

			return left(arguments.string,local.left) & arguments.cutOffString & right(arguments.string,local.right);
		</cfScript>
	</cfFunction>
	<cfFunction
		name		= "slimString"
		access		= "public"
		description	= "Will trim off accessive characters of a string and replace what is trimmed with three periods(...)"
		hint		= "By default, argument 'addHtmlTitle' is true, which wraps returned string in HTML 'abbr' tag that has a title attribute of the full string ... only if string was trimmed"
		output		= "no"
	>
		<cfArgument name="string"				required="yes"	type="string"					hint="String to be but down in size" />
		<cfArgument name="maxLength"			required="no"	type="numeric"	default="35"	hint="Maxlength that string can be before being cut, If no value provided, then cuts at 35 chrs" />
		<cfArgument name="cutOffString"			required="no"	type="string"	default="..."	hint="" />
		<cfArgument name="addHtmlTitle"			required="no"	type="boolean"	default="no"	hint="wraps string with HTML abbr tag with a title attribute of the full string value" /><!---false--->
		<cfArgument name="isPreventWordCutoff"	required="no"	type="boolean"	default="no"	hint="" />
		<cfScript>
			var local = structNew();
			local.newString = "";

			if( len(arguments.String) LTE arguments.maxLength )
				return arguments.string;

			local.newString = left(arguments.string, arguments.maxLength);

			if( arguments.addHtmlTitle )
				local.newString = '<abbr title="' & arguments.string & '" style="border:none">' & local.newString & '</abbr>';

			//?is last word full?
			if(arguments.isPreventWordCutoff)
			{

				local.beforeLastWord	= reFindNoCase(" [^\s]+$" , local.newString, 1, false);
				local.right				= len(local.newString)-(local.beforeLastWord);
				local.lastReturnWord	= right(local.newString, local.right);
				local.right				= len(arguments.string)-(local.beforeLastWord);
				local.lastWord			= right(arguments.string, local.right);
				local.lastWordFind		= reFindNoCase("^[^\s]+\s", local.lastWord, 1, true);
				local.isLastWord		= local.lastWordFind.pos[1] eq 0;
				local.midLongRange		= local.lastWordFind.len[1] - 1;
				local.leftRange			= local.beforeLastWord-1;

				if
				(
					(local.midLongRange GT 0 AND local.leftRange GT 0 AND mid(local.lastWord, 1, local.midLongRange) NEQ local.lastReturnWord)
				OR	(local.isLastWord AND local.leftRange GT 0)
				)
					local.newString = trim(left(local.newString, local.leftRange));
			}

			return trim(local.newString) & arguments.cutOffString;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "slimStringWords"
		returnType	= "string"
		access		= "public"
		output		= "no"
		description	= "takes each word of a string and any character longer then specified amount are cut short and a period added"
		hint		= ""
	>
		<cfArgument name="string"			required="yes"	type="string"					hint="" />
		<cfArgument name="maxWordLength"	required="no"	type="numeric"	default="10"	hint="" />
		<cfArgument name="cutOffString"		required="no"	type="string"	default="."		hint="" />
		<cfScript>
			var local = structNew();

			local.regX = '[^\n\r\t\s]{'&arguments.maxWordLength&'}[^\n\r\t\s]+\s';

			local.findArray = reFindNoCase(local.regX, arguments.string, 1, true);

			while( local.findArray.len[1] )
			{
				local.pos	= local.findArray.pos[1];
				local.len	= local.findArray.len[1];

				if(local.len GT arguments.maxWordLength)
				{
					local.left = '';

					if(local.pos > 1)
						local.left = left(arguments.string, local.pos-1);

					local.mid	= mid(arguments.string, local.pos, local.len-(local.len-arguments.maxWordLength)-1);
					local.right	= right(arguments.string, len(arguments.string)-(local.pos+local.len-2));

					arguments.string = local.left & local.mid & arguments.cutOffString & local.right;
				}

				local.findArray = reFindNoCase(local.regX, arguments.string, 1, true);

			}

			return arguments.string;
		</cfScript>
	</cfFunction>

	<cfFunction
		name		= "qualifiedListToArray"
		returnType	= "array"
		access		= "public"
		output		= "no"
		description	= ""
		hint		= ""
	>
		<cfArgument name="list"				required="yes"	type="string" hint="" />
		<cfArgument name="delimiter"		required="yes"	type="string" hint="" />
		<cfArgument name="textQualifier"	required="yes"	type="string" hint="" />
		<cfScript>
			var local = structNew();

			/* todo : needs cleaning/updating */
				local.listArray			= arrayNew(1);
				local.returnArray		= arrayNew(1);
				local.attachItemMode	= false;
				local.attachingSpot		= 1;
				local.list				= arguments.list;

				if(not structKeyExists(arguments,'delimiter') OR not len(arguments.delimiter))
					arguments.delimiter=chr(44);

				if( left(local.list,1) eq arguments.delimiter )local.list = ' ' & local.list;
				if( right(local.list,1) eq arguments.delimiter )local.list = local.list & ' ';

				while( local.list contains arguments.delimiter&arguments.delimiter )
					local.list = replace( local.list , arguments.delimiter&arguments.delimiter , arguments.delimiter&' '&arguments.delimiter , 'all' );

				local.itemArray = listToArray(local.list, delimiter);
				local.itemCount = arrayLen(local.itemArray);
				for( local.x=1; local.x lte local.itemCount; ++local.x )
					arrayAppend(local.listArray, local.itemArray[local.x]);

				local.itemCount = arrayLen(local.listArray);
				for(local.x=1; local.x lte local.itemCount; ++local.x)
				{
					if(
						local.listArray[local.x] contains arguments.textQualifier
					AND
						!local.attachItemMode
					AND
						left(local.listArray[local.x],1) eq arguments.textQualifier
					AND
						right(local.listArray[local.x],1) neq arguments.textQualifier
					)
					{
						local.returnArray[local.attachingSpot] = replace(local.listArray[local.x], textQualifier, '', 'all') & arguments.delimiter;
						local.attachItemMode = true;
					}else if
					(
						right(replace(local.listArray[local.x],textQualifier&textQualifier,'','all'),1) eq textQualifier
					and
						local.attachItemMode
					)
					{
						if(local.listArray[local.x] EQ arguments.textQualifier)
							local.returnArray[local.attachingSpot] = local.returnArray[local.attachingSpot] & arguments.delimiter;//the value ends with the delimiter followed by the text-qualifier
						else
							local.returnArray[local.attachingSpot] = local.returnArray[local.attachingSpot] & left(local.listArray[local.x],len(local.listArray[local.x])-1);

						local.attachingSpot = local.attachingSpot + 1;
						local.attachItemMode = false;
					}else if( local.attachItemMode )
						local.returnArray[local.attachingSpot] = local.returnArray[local.attachingSpot] & local.listArray[local.x] & arguments.delimiter;
					else{
						local.returnArray[local.attachingSpot] = replace( local.listArray[local.x] , textQualifier , '' , 'all' );
						local.attachingSpot = local.attachingSpot + 1;
					}
				}

				return local.returnArray;
			/* end */
		</cfScript>
	</cfFunction>

</cfComponent>