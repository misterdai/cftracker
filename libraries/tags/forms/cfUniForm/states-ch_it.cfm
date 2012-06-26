<!--- this tag should only run in "end" mode ---><cfif thisTag.executionMode IS "start"><cfexit method="exittemplate" /></cfif>
<cfsilent>
<!---
filename:		tags/forms/UniForm/states-ch_de.cfm
date created:	05/13/09
author:			M.Sameli (http://www.backslash.ch/)
purpose:		I display an XHTML Strict 1.0 option list of Swiss Provinces in italian for use with the cfUniForm custom tags

	// **************************************** LICENSE INFO **************************************** \\

	Copyright 2009, Mischa Sameli

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
	05/13/09		New																				MS

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
				<uform:states-ch_it /> <------- this here is how you're calling this tag!!!
			</uform:field>

 --->

<!--- define the tag attributes --->
	<!--- required attributes --->

	<!--- optional attributes --->
	<cfparam name="attributes.defaultState" type="string" default="" />
	<cfparam name="attributes.fieldName" type="string" default="province" />
	<cfparam name="attributes.struct" type="struct" default="#form#" />
	<cfparam name="attributes.showSelect" type="boolean" default="yes" />
	<cfparam name="attributes.showSwiss" type="boolean" default="yes" />
	<cfparam name="attributes.content" type="string" default="" /><!--- do not supply this attribute; it is used internally --->

<cfscript>
	s = attributes.struct;
	fieldName = attributes.fieldName;
	def = attributes.defaultState;
</cfscript>

</cfsilent>
<cfsavecontent variable="attributes.content">
<cfoutput>
<cfif attributes.showSelect><option value=""<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "") OR (NOT structKeyExists(s, fieldName) AND def IS "")> selected="selected"</cfif>>Seleziona un Cantone</option></cfif>
<cfif attributes.showSwiss><option value="-1CH">===================== Svizzera =====================</option></cfif>
<option value="AG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AG") OR (NOT structKeyExists(s, fieldName) AND def IS "AG")> selected="selected"</cfif>>Argovia</option>
<option value="AI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AI") OR (NOT structKeyExists(s, fieldName) AND def IS "AI")> selected="selected"</cfif>>Appenzello Interno</option>
<option value="AR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AR") OR (NOT structKeyExists(s, fieldName) AND def IS "AR")> selected="selected"</cfif>>Appenzello Esterno</option>
<option value="BE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BE") OR (NOT structKeyExists(s, fieldName) AND def IS "BE")> selected="selected"</cfif>>Berna</option>
<option value="BL"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BL") OR (NOT structKeyExists(s, fieldName) AND def IS "BL")> selected="selected"</cfif>>Basilea-Campagna</option>
<option value="BS"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BS") OR (NOT structKeyExists(s, fieldName) AND def IS "BS")> selected="selected"</cfif>>Basilea-Citt&agrave;</option>
<option value="FR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "FR") OR (NOT structKeyExists(s, fieldName) AND def IS "FR")> selected="selected"</cfif>>Friburgo</option>
<option value="GE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GE") OR (NOT structKeyExists(s, fieldName) AND def IS "GE")> selected="selected"</cfif>>Ginevra</option>
<option value="GL"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GL") OR (NOT structKeyExists(s, fieldName) AND def IS "GL")> selected="selected"</cfif>>Glarona</option>
<option value="GR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GR") OR (NOT structKeyExists(s, fieldName) AND def IS "GR")> selected="selected"</cfif>>Grigioni</option>
<option value="JU"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "JU") OR (NOT structKeyExists(s, fieldName) AND def IS "JU")> selected="selected"</cfif>>Giura</option>
<option value="LU"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "LU") OR (NOT structKeyExists(s, fieldName) AND def IS "LU")> selected="selected"</cfif>>Lucerna</option>
<option value="NE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NE") OR (NOT structKeyExists(s, fieldName) AND def IS "NE")> selected="selected"</cfif>>Neuch&acirc;tel</option>
<option value="NW"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NW") OR (NOT structKeyExists(s, fieldName) AND def IS "NW")> selected="selected"</cfif>>Nidwaldo</option>
<option value="OW"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "OW") OR (NOT structKeyExists(s, fieldName) AND def IS "OW")> selected="selected"</cfif>>Obwaldo</option>
<option value="SG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SG") OR (NOT structKeyExists(s, fieldName) AND def IS "SG")> selected="selected"</cfif>>San Gallo</option>
<option value="SH"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SH") OR (NOT structKeyExists(s, fieldName) AND def IS "SH")> selected="selected"</cfif>>Sciaffusa</option>
<option value="SO"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SO") OR (NOT structKeyExists(s, fieldName) AND def IS "SO")> selected="selected"</cfif>>Soletta</option>
<option value="SZ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SZ") OR (NOT structKeyExists(s, fieldName) AND def IS "SZ")> selected="selected"</cfif>>Svitto</option>
<option value="TG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TG") OR (NOT structKeyExists(s, fieldName) AND def IS "TG")> selected="selected"</cfif>>Turgovia</option>
<option value="TI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TI") OR (NOT structKeyExists(s, fieldName) AND def IS "TI")> selected="selected"</cfif>>Ticino</option>
<option value="UR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "UR") OR (NOT structKeyExists(s, fieldName) AND def IS "UR")> selected="selected"</cfif>>Uri</option>
<option value="VD"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "VD") OR (NOT structKeyExists(s, fieldName) AND def IS "VD")> selected="selected"</cfif>>Vaud</option>
<option value="VS"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "VS") OR (NOT structKeyExists(s, fieldName) AND def IS "VS")> selected="selected"</cfif>>Vallese</option>
<option value="ZG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ZG") OR (NOT structKeyExists(s, fieldName) AND def IS "ZG")> selected="selected"</cfif>>Zugo</option>
<option value="ZH"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ZH") OR (NOT structKeyExists(s, fieldName) AND def IS "ZH")> selected="selected"</cfif>>Zurigo</option>
</cfoutput>
</cfsavecontent>

<cfassociate basetag="cf_field" datacollection="options" />
