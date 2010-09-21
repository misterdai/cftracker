<!--- this tag should only run in "end" mode ---><cfif thisTag.executionMode IS "start"><cfexit method="exittemplate" /></cfif>
<cfsilent>
<!---
filename:		tags/forms/UniForm/states-aus.cfm
date created:	12/Nov/08
author:			Glenn Seymon
purpose:		I display an XHTML Strict 1.0 option list of Australian states for use with the cfUniForm custom tags

	// **************************************** LICENSE INFO **************************************** \\

	Copyright 2008, Glenn Seymon, Matt Quackenbush

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
	12/Nov/08		New																				GS

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
	@showAustralia		Optional (boolean)	- indicates whether or not to show the opening empty value "======== Australia ========" option
																			defaults to 'true'

	// STEPS TO USE THIS TAG

		For more info on all of the steps, see the "use example" comments in the UniForm Form.cfm tag.
		This tag is used in Step 3 of the form building process.

			<uform:field label="State / Province" name="state" isRequired="true" type="select">
				<uform:states-aus /> <------- this here is how you're calling this tag!!!
			</uform:field>

 --->

<!--- define the tag attributes --->
	<!--- required attributes --->

	<!--- optional attributes --->
	<cfparam name="attributes.defaultState" type="string" default="" />
	<cfparam name="attributes.fieldName" type="string" default="province" />
	<cfparam name="attributes.struct" type="struct" default="#form#" />
	<cfparam name="attributes.showSelect" type="boolean" default="yes" />
	<cfparam name="attributes.showAustralia" type="boolean" default="yes" />
	<cfparam name="attributes.content" type="string" default="" /><!--- do not supply this attribute; it is used internally --->

<cfscript>
	s = attributes.struct;
	fieldName = attributes.fieldName;
	def = attributes.defaultState;
</cfscript>
</cfsilent>
<cfsavecontent variable="attributes.content">
<cfif attributes.showSelect><option value=""<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "") OR (NOT structKeyExists(s, fieldName) AND def IS "")> selected="selected"</cfif>>Select One</option></cfif>
<cfif attributes.showAustralia><option value="-1AUS">===================== Australia =====================</option></cfif>
<option value="ACT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ACT") OR (NOT structKeyExists(s, fieldName) AND def IS "ACT")> selected="selected"</cfif>>Australian Capital Territory</option>
<option value="NSW"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NSW") OR (NOT structKeyExists(s, fieldName) AND def IS "NSW")> selected="selected"</cfif>>New South Wales</option>
<option value="NT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NT") OR (NOT structKeyExists(s, fieldName) AND def IS "NT")> selected="selected"</cfif>>Northern Territory</option>
<option value="QLD"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "QLD") OR (NOT structKeyExists(s, fieldName) AND def IS "QLD")> selected="selected"</cfif>>Queensland</option>
<option value="SA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SA") OR (NOT structKeyExists(s, fieldName) AND def IS "SA")> selected="selected"</cfif>>South Australia</option>
<option value="TAS"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TAS") OR (NOT structKeyExists(s, fieldName) AND def IS "TAS")> selected="selected"</cfif>>Tasmania</option>
<option value="VIC"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "VIC") OR (NOT structKeyExists(s, fieldName) AND def IS "VIC")> selected="selected"</cfif>>Victoria</option>
<option value="WA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "WA") OR (NOT structKeyExists(s, fieldName) AND def IS "WA")> selected="selected"</cfif>>Western Australia</option>
</cfsavecontent>

<cfassociate basetag="cf_field" datacollection="options" />
