<!--- this tag should only run in "end" mode ---><cfif thisTag.executionMode IS "start"><cfexit method="exittemplate" /></cfif>
<cfsilent>
<!--- 
filename:		tags/forms/UniForm/states-us-territories.cfm
date created:	2/18/10
author:			Matt Quackenbush (http://www.quackfuzed.com/)
purpose:		I display an XHTML Strict 1.0 options list for U.S. territories based upon the Uni-Form markup
				
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2010, Matt Quackenbush
	
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
	2/18/10		New																					MQ
	
 --->

<!--- // use example
	
	// REQUIRED ATTRIBUTES
	none
	
	// OPTIONAL ATTRIBUTES
	@defaultState			Optional (string)		- the two-letter value of the default state (e.g. 'TX', 'CA', 'FL')
	@fieldName				Optional (string)	 	- the name of the field in the form scope that contains the value
																			defaults to 'state'
	@struct					Optional (struct)		- the structure to check values against
																			defaults to #form#
	@showSelect				Optional (boolean)	- indicates whether or not to show the opening empty value "Select One" option
																			defaults to 'true'
	@showTerritories		Optional (boolean)	- indicates whether or not to show the opening empty value "======== U.S. Territories ========" option
																			defaults to 'true'
	
	// STEPS TO USE THIS TAG
		
		For more info on all of the steps, see the "use example" comments in the UniForm Form.cfm tag.
		This tag is used in Step 3 of the form building process.
	
			<uform:field label="State / Province" name="state" isRequired="true" type="select">
				<uform:states-us-territories /> <------- this here is how you're calling this tag!!!
			</uform:field>
	
 --->

<!--- define the tag attributes --->
	<!--- required attributes --->
	
	<!--- optional attributes --->
	<cfparam name="attributes.defaultState" type="string" default="" />
	<cfparam name="attributes.fieldName" type="string" default="state" />
	<cfparam name="attributes.struct" type="struct" default="#form#" />
	<cfparam name="attributes.showSelect" type="boolean" default="yes" />
	<cfparam name="attributes.showTerritories" type="boolean" default="yes" />
	<cfparam name="attributes.content" type="string" default="" /><!--- do not supply this attribute; it is used internally --->

<cfscript>
	s = attributes.struct;
	fieldName = attributes.fieldName;
	def = attributes.defaultState;
</cfscript>
</cfsilent>
<cfsavecontent variable="attributes.content">
<cfif attributes.showSelect><option value=""<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "") OR (NOT structKeyExists(s, fieldName) AND def IS "")> selected="selected"</cfif>>Select One</option></cfif>
<cfif attributes.showTerritories><option value="-1USTerr">===================== U.S. Territories =====================</option></cfif>
<option value="AS"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AS") OR (NOT structKeyExists(s, fieldName) AND def IS "AS")> selected="selected"</cfif>>American Samoa</option>
<option value="GU"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GU") OR (NOT structKeyExists(s, fieldName) AND def IS "GU")> selected="selected"</cfif>>Guam</option>
<option value="MP"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MP") OR (NOT structKeyExists(s, fieldName) AND def IS "MP")> selected="selected"</cfif>>Northern Mariana Islands</option>
<option value="PR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PR") OR (NOT structKeyExists(s, fieldName) AND def IS "PR")> selected="selected"</cfif>>Puerto Rico</option>
<option value="UM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "UM") OR (NOT structKeyExists(s, fieldName) AND def IS "UM")> selected="selected"</cfif>>United States Minor Outlying Islands</option>
<option value="VI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "VI") OR (NOT structKeyExists(s, fieldName) AND def IS "VI")> selected="selected"</cfif>>Virgin Islands, U.S.</option>
</cfsavecontent>

<cfassociate basetag="cf_field" datacollection="options" />
