<!--- this tag should only run in "end" mode ---><cfif thisTag.executionMode IS "start"><cfexit method="exittemplate" /></cfif>
<cfsilent>
<!--- 
filename:		tags/forms/UniForm/optgroup.cfm
date created:	09/08/08
author:			Bob Silverberg (http://www.silverwareconsulting.com/)
purpose:		I display an XHTML Strict 1.0 optgroup tag using the Uni-Form markup
				
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
	09/08/08		New																	Bob Silverberg
	
 --->

<!--- // use example
	
	// REQUIRED ATTRIBUTES
	@label					Required (string)		- text to display as the heading for the option group
	
	// OPTIONAL ATTRIBUTES
	@isDisabled				Optional (boolean)		- indicates whether or not the option group is enabled (supplying a value of 'true' will set disabled="disabled" on the field)
																				defaults to 'false'
	
	// STEPS TO USE THIS TAG
		
		For more info on all of the steps, see the "use example" comments in the UniForm Form.cfm tag.
		This tag is used in Step 3 of the form building process.
		
			<uform:field label="A Select Box" name="selectbox" type="select">
				<uform:optgroup label="My Group"> <------- this here is how you're calling this tag!!!
					<uform:option display="Option A" value="1" />
					<uform:option display="Option B" value="2" />
					<uform:option display="Option C" value="3" isSelected="true" />
					<uform:option display="Option D" value="4" />
					<uform:option display="Option E" value="5" />
				</uform:optgroup>
			</uform:field>
		
 --->

<!--- define the tag attributes --->
	<!--- required attributes --->
	<cfparam name="attributes.label" type="string" />
	
	<!--- optional attributes --->
	<cfparam name="attributes.isDisabled" type="boolean" default="no" />

<cfscript>
	// if tag has content nested inside
	if ( len(trim(thisTag.generatedContent)) ) {
		/*
		*	add content as a tag attribute so its available to fieldset tag, 
		*		and reset generatedContent so nothing is rendered
		*/
		thisTag.generatedContent = "";
	}
	// does tag have any options associated with it?
	if ( structKeyExists(thisTag, "options") ) {
		// pass them on in the attributes
		attributes.options = thisTag.options;
	}
</cfscript>

<cfassociate basetag="cf_field" datacollection="optiongroups" />
</cfsilent>
