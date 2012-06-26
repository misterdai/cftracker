<!--- this tag should only run in "end" mode ---><cfif thisTag.executionMode IS "start"><cfexit method="exittemplate" /></cfif>
<cfsilent>
<!--- 
filename:		tags/forms/UniForm/canadaProvinces.cfm
date created:	12/15/07
author:			Matt Quackenbush (http://www.quackfuzed.com/)
purpose:		I display an XHTML Strict 1.0 option list of Canadian Provinces for use with the cfUniForm custom tags
				
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
	
 --->

<!--- // use example
	
	// REQUIRED ATTRIBUTES
	none
	
	// OPTIONAL ATTRIBUTES
	@defaultState			Optional (string)	- the two-letter value of the default province (e.g. 'AB', 'ON', 'MB')
	@fieldName				Optional (string) 	- the name of the field in the form scope that contains the value
																		defaults to 'province'
	@struct					Optional (struct)	- the structure to check values against
																		defaults to #form#
	@showSelect			Optional (boolean)	- indicates whether or not to show the opening empty value "Select One" option
																			defaults to 'true'
	@showCanada		Optional (boolean)	- indicates whether or not to show the opening empty value "======== Canada ========" option
																			defaults to 'true'
	
	// STEPS TO USE THIS TAG
		
		For more info on all of the steps, see the "use example" comments in the UniForm Form.cfm tag.
		This tag is used in Step 3 of the form building process.
	
			<uform:field label="State / Province" name="state" isRequired="true" type="select">
				<uform:states-can /> <------- this here is how you're calling this tag!!!
			</uform:field>
	
 --->

<!--- define the tag attributes --->
	<!--- required attributes --->
	
	<!--- optional attributes --->
	<cfparam name="attributes.defaultState" type="string" default="" />
	<cfparam name="attributes.fieldName" type="string" default="province" />
	<cfparam name="attributes.struct" type="struct" default="#form#" />
	<cfparam name="attributes.showSelect" type="boolean" default="yes" />
	<cfparam name="attributes.showCanada" type="boolean" default="yes" />
	<cfparam name="attributes.content" type="string" default="" /><!--- do not supply this attribute; it is used internally --->

<cfscript>
	s = attributes.struct;
	fieldName = attributes.fieldName;
	def = attributes.defaultState;
</cfscript>
</cfsilent>
<cfsavecontent variable="attributes.content">
<cfif attributes.showSelect><option value=""<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "") OR (NOT structKeyExists(s, fieldName) AND def IS "")> selected="selected"</cfif>>Select One</option></cfif>
<cfif attributes.showCanada><option value="-1CAN">===================== Canada =====================</option></cfif>
<option value="AB"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AB") OR (NOT structKeyExists(s, fieldName) AND def IS "AB")> selected="selected"</cfif>>Alberta</option>
<option value="BC"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BC") OR (NOT structKeyExists(s, fieldName) AND def IS "BC")> selected="selected"</cfif>>British Columbia</option>
<option value="MB"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MB") OR (NOT structKeyExists(s, fieldName) AND def IS "MB")> selected="selected"</cfif>>Manitoba</option>
<option value="NB"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NB") OR (NOT structKeyExists(s, fieldName) AND def IS "NB")> selected="selected"</cfif>>New Brunswick</option>
<option value="NL"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NL") OR (NOT structKeyExists(s, fieldName) AND def IS "NL")> selected="selected"</cfif>>Newfoundland &amp; Labrador</option>
<option value="NT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NT") OR (NOT structKeyExists(s, fieldName) AND def IS "NT")> selected="selected"</cfif>>Northwest Territories</option>
<option value="NS"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NS") OR (NOT structKeyExists(s, fieldName) AND def IS "NS")> selected="selected"</cfif>>Nova Scotia</option>
<option value="NU"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NU") OR (NOT structKeyExists(s, fieldName) AND def IS "NU")> selected="selected"</cfif>>Nunavut</option>
<option value="ON"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ON") OR (NOT structKeyExists(s, fieldName) AND def IS "ON")> selected="selected"</cfif>>Ontario</option>
<option value="PE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PE") OR (NOT structKeyExists(s, fieldName) AND def IS "PE")> selected="selected"</cfif>>Prince Edward Island</option>
<option value="QC"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "QC") OR (NOT structKeyExists(s, fieldName) AND def IS "QC")> selected="selected"</cfif>>Quebec</option>
<option value="SK"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SK") OR (NOT structKeyExists(s, fieldName) AND def IS "SK")> selected="selected"</cfif>>Saskatchewan</option>
<option value="YT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "YT") OR (NOT structKeyExists(s, fieldName) AND def IS "YT")> selected="selected"</cfif>>Yukon Territory</option>
</cfsavecontent>

<cfassociate basetag="cf_field" datacollection="options" />
