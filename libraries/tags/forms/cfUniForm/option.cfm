<!--- this tag should only run in "end" mode ---><cfif thisTag.executionMode IS "start"><cfexit method="exittemplate" /></cfif>
<cfsilent>
<!--- 
filename:		tags/forms/UniForm/option.cfm
date created:	12/15/07
author:			Matt Quackenbush (http://www.quackfuzed.com/)
purpose:		I display an XHTML Strict 1.0 option tag using the Uni-Form markup
				
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
	12/15/07		New																				MQ
	
	9/8/08			Added support for optgroup tag.										Bob Silverberg
	
 --->

<!--- // use example
	
	// REQUIRED ATTRIBUTES
	@display					Required (string)		- text to display in the <option></option> tag
	@value					Required (string)		- the value for the option tag
	
	// OPTIONAL ATTRIBUTES
	@isSelected				Optional (boolean)	- indicates whether or not the option should be selected
																			defaults to 'false'
	
	// STEPS TO USE THIS TAG
		
		For more info on all of the steps, see the "use example" comments in the UniForm Form.cfm tag.
		This tag is used in Step 3 of the form building process.
		
		Standard Use:
		
			<uform:field label="A Select Box" name="selectbox" type="select">
				<uform:option display="Option A" value="1" /> <------- this here is how you're calling this tag!!!
				<uform:option display="Option B" value="2" /> <------- this here is how you're calling this tag!!! (again!)
				<uform:option display="Option C" value="3" isSelected="true" /> <------- this here is how you're calling this tag!!! (again!)
				<uform:option display="Option D" value="4" /> <------- this here is how you're calling this tag!!! (again!)
				<uform:option display="Option E" value="5" /> <------- this here is how you're calling this tag!!! (again!)
			</uform:field>
		
		With OptGroup Use:
		
			<uform:field label="A Select Box" name="selectbox" type="select">
				<uform:optgroup label="My Group">
					<uform:option display="Option A" value="1" /> <------- this here is how you're calling this tag!!!
					<uform:option display="Option B" value="2" /> <------- this here is how you're calling this tag!!! (again!)
					<uform:option display="Option C" value="3" isSelected="true" /> <------- this here is how you're calling this tag!!! (again!)
					<uform:option display="Option D" value="4" /> <------- this here is how you're calling this tag!!! (again!)
					<uform:option display="Option E" value="5" /> <------- this here is how you're calling this tag!!! (again!)
				</uform:optgroup>
			</uform:field>
		
 --->

<!--- define the tag attributes --->
	<!--- required attributes --->
	<cfparam name="attributes.display" type="string" />
	<cfparam name="attributes.value" type="string" />
	
	<!--- optional attributes --->
	<cfparam name="attributes.isSelected" type="boolean" default="no" />

<cfscript>
	// if tag has content nested inside
	if ( len(trim(thisTag.generatedContent)) ) {
		/*
		*	add content as a tag attribute so its available to fieldset tag, 
		*		and reset generatedContent so nothing is rendered
		*/
		thisTag.generatedContent = "";
	}
</cfscript>

<cfif listFindNoCase(getBaseTagList(), "cf_optgroup") EQ 0>
	<cfassociate basetag="cf_field" datacollection="options" />
<cfelse>
	<cfassociate basetag="cf_optgroup" datacollection="options" />
</cfif>
</cfsilent>
