<!--- this tag should only run in "start" mode ---><cfif thisTag.executionMode IS NOT "start"><cfexit method="exittag" /></cfif>
<cfsilent>
<!--- 
filename:		tags/forms/renderValidationErrors.cfm
date created:	12/06/07
author:			Matt Quackenbush (http://www.quackfuzed.com/)
purpose:		I display an xhtml list of error messages
				
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2007, Matt Quackenbush
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
	// ****************************************** REVISIONS ****************************************** \\
	
	DATE		DESCRIPTION OF CHANGES MADE												CHANGES MADE BY
	===================================================================================================
	12/06/07		New																				MQ
	
 --->

<!--- // use example
	
	// REQUIRED ATTRIBUTES
	@errors					Required (any)		An array or struct containing the error messages.
													If passing an array, you have two options:
													
													1. Each index of the array is a simple value, containing only the error message.
													2. Each index of the array is a struct containing two keys:
														a. property
														b. message
													
													If choosing the second option, messages will be displayed in the order that 
													they appear in the index, except that multiple messages for the same property 
													will be grouped together.
	
	// OPTIONAL ATTRIBUTES
	@listType				Optional (string)	The type of list to render
													Acceptable values are: 
														ol
														ul
													Defaults to 'ul'.
	@listID					Optional (string)	CSS ID for the list (e.g. <ul id="{this id}"></ul>)
	@itemClass				Optional (string)	CSS class for list items
	@firstItemClass			Optional (string)	CSS class for the first list item
	@lastItemClass			Optional (string)	CSS class for the last list item
	@showProperty			Optional (boolean)	Indicates whether or not the offending property should be shown with the error message.
													Defaults to 'false'.
	
	<cfmodule template="/tags/forms/renderValidationErrors.cfm" errors="#array|struct#" listType="#string#" listID="#string#" itemClass="#string#" firstItemClass="#string#" lastItemClass="#string#" showProperty="#boolean#" />
	
	You may provide an array of simple values (just plain error messages)
	
 --->

<!--- define the tag attributes --->
	<!--- required attributes --->
	<cfparam name="attributes.errors" type="any" />
	
	<!--- optional attributes --->
	<cfparam name="attributes.listType" type="string" default="ul" />
	<cfparam name="attributes.listID" type="string" default="" />
	<cfparam name="attributes.itemClass" type="string" default="" />
	<cfparam name="attributes.firstItemClass" type="string" default="" />
	<cfparam name="attributes.lastItemClass" type="string" default="" />
	<cfparam name="attributes.errorListType" type="string" default="ul" />
	<cfparam name="attributes.showProperty" type="boolean" default="no" />

<!--- errors MUST be either an array or a struct --->
<cfif (NOT isArray(attributes.errors)) AND (NOT isStruct(attributes.errors))>
	<cfthrow message="The RenderValidationErrors tag requires either a struct or an array of errors" 
			errorcode="kuubd.com.tags.forms.renderValidationErrors.invalidAttribute" />
</cfif>

<cfscript>
	listType = lCase(attributes.errorListType);
	if ( NOT listFind("ul,ol", listType) ) { listType = "ul"; }
	_property = "property";
	_usedIdx = "";
</cfscript>
</cfsilent>

<cfoutput>
<#listType#<cfif len(attributes.listID) GT 0> id="#attributes.listID#"</cfif>>
<cfif isArray(attributes.errors)>
	<cfif NOT isStruct(attributes.errors[1])>
		<cfloop from="1" to="#arrayLen(attributes.errors)#" index="e">#chr(9)#<li<cfif len(attributes.firstItemClass) GT 0 AND e EQ 1> class="#attributes.firstItemClass#"<cfelseif len(attributes.lastItemClass) GT 0 AND e EQ arrayLen(attributes.errors)> class="#attributes.lastItemClass#"<cfelseif len(attributes.itemClass) GT 0> class="#attributes.itemClass#"</cfif>>#attributes.errors[e]#</li>#chr(10)#</cfloop>
	<cfelse>
		<cfscript>
			if ( arrayLen(attributes.errors) GT 0 AND structKeyExists(attributes.errors[1], "field") ) {
				_property = "field";
			}
		</cfscript>
		<cfloop from="1" to="#arrayLen(attributes.errors)#" index="e">
			<cfif listFind(_usedIdx, e) EQ 0>
				#chr(9)#<li<cfif len(attributes.firstItemClass) GT 0 AND e EQ 1> class="#attributes.firstItemClass#"<cfelseif len(attributes.lastItemClass) GT 0 AND e EQ arrayLen(attributes.errors)> class="#attributes.lastItemClass#"<cfelseif len(attributes.itemClass) GT 0> class="#attributes.itemClass#"</cfif>>
				<cfif attributes.showProperty><strong>#attributes.errors[e][_property]#</strong><br /></cfif>
				#attributes.errors[e].message#
				<cfloop from="#e+1#" to="#arrayLen(attributes.errors)#" index="e2">
					<cfif (listFind(_usedIdx, e2) EQ 0) AND (compareNoCase(attributes.errors[e2][_property],attributes.errors[e][_property]) EQ 0)>
						<cfset _usedIdx = listAppend(_usedIdx, e2) />
						<br />#attributes.errors[e2].message#
					</cfif>
				</cfloop>
				</li>
			</cfif>
		</cfloop>
	</cfif>
<cfelse>
	<cfset keys = structKeyArray(attributes.errors) />
	<cfloop from="1" to="#arrayLen(keys)#" index="e">#chr(9)#<li<cfif len(attributes.firstItemClass) GT 0 AND e EQ 1> class="#attributes.firstItemClass#"<cfelseif len(attributes.lastItemClass) GT 0 AND e EQ structCount(attributes.errors)> class="#attributes.lastItemClass#"<cfelseif len(attributes.itemClass) GT 0> class="#attributes.itemClass#"</cfif>><cfif attributes.showProperty><strong>#keys[e]#</strong>: </cfif>#attributes.errors[keys[e]]#</li>#chr(10)#</cfloop>
</cfif>
</#listType#>
</cfoutput>
