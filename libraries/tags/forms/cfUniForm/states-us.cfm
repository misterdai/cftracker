<!--- this tag should only run in "end" mode ---><cfif thisTag.executionMode IS "start"><cfexit method="exittemplate" /></cfif>
<cfsilent>
<!--- 
filename:		tags/forms/UniForm/states.cfm.cfm
date created:	12/15/07
author:			Matt Quackenbush (http://www.quackfuzed.com/)
purpose:		I display an XHTML Strict 1.0 options list for U.S. states based upon the Uni-Form markup
				
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
	@defaultState			Optional (string)		- the two-letter value of the default state (e.g. 'TX', 'CA', 'FL')
	@fieldName				Optional (string)	 	- the name of the field in the form scope that contains the value
																			defaults to 'state'
	@struct					Optional (struct)		- the structure to check values against
																			defaults to #form#
	@showSelect			Optional (boolean)	- indicates whether or not to show the opening empty value "Select One" option
																			defaults to 'true'
	@showUS				Optional (boolean)	- indicates whether or not to show the opening empty value "======== United States ========" option
																			defaults to 'true'
	
	// STEPS TO USE THIS TAG
		
		For more info on all of the steps, see the "use example" comments in the UniForm Form.cfm tag.
		This tag is used in Step 3 of the form building process.
	
			<uform:field label="State / Province" name="state" isRequired="true" type="select">
				<uform:states-us /> <------- this here is how you're calling this tag!!!
			</uform:field>
	
 --->

<!--- define the tag attributes --->
	<!--- required attributes --->
	
	<!--- optional attributes --->
	<cfparam name="attributes.defaultState" type="string" default="" />
	<cfparam name="attributes.fieldName" type="string" default="state" />
	<cfparam name="attributes.struct" type="struct" default="#form#" />
	<cfparam name="attributes.showSelect" type="boolean" default="yes" />
	<cfparam name="attributes.showUS" type="boolean" default="no" />
	<cfparam name="attributes.content" type="string" default="" /><!--- do not supply this attribute; it is used internally --->

<cfscript>
	s = attributes.struct;
	fieldName = attributes.fieldName;
	def = attributes.defaultState;
</cfscript>
</cfsilent>
<cfsavecontent variable="attributes.content">
<cfif attributes.showSelect><option value=""<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "") OR (NOT structKeyExists(s, fieldName) AND def IS "")> selected="selected"</cfif>>Select One</option></cfif>
<cfif attributes.showUS><option value="-1USA">===================== United States =====================</option></cfif>
<option value="AL"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AL") OR (NOT structKeyExists(s, fieldName) AND def IS "AL")> selected="selected"</cfif>>Alabama</option>
<option value="AK"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AK") OR (NOT structKeyExists(s, fieldName) AND def IS "AK")> selected="selected"</cfif>>Alaska</option>
<option value="AZ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AZ") OR (NOT structKeyExists(s, fieldName) AND def IS "AZ")> selected="selected"</cfif>>Arizona</option>
<option value="AR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AR") OR (NOT structKeyExists(s, fieldName) AND def IS "AR")> selected="selected"</cfif>>Arkansas</option>
<option value="CA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CA") OR (NOT structKeyExists(s, fieldName) AND def IS "CA")> selected="selected"</cfif>>California</option>
<option value="CO"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CO") OR (NOT structKeyExists(s, fieldName) AND def IS "CO")> selected="selected"</cfif>>Colorado</option>
<option value="CT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CT") OR (NOT structKeyExists(s, fieldName) AND def IS "CT")> selected="selected"</cfif>>Connecticut</option>
<option value="DE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "DE") OR (NOT structKeyExists(s, fieldName) AND def IS "DE")> selected="selected"</cfif>>Delaware</option>
<option value="DC"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "DC") OR (NOT structKeyExists(s, fieldName) AND def IS "DC")> selected="selected"</cfif>>District of Columbia</option>
<option value="FL"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "FL") OR (NOT structKeyExists(s, fieldName) AND def IS "FL")> selected="selected"</cfif>>Florida</option>
<option value="GA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GA") OR (NOT structKeyExists(s, fieldName) AND def IS "GA")> selected="selected"</cfif>>Georgia</option>
<option value="HI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "HI") OR (NOT structKeyExists(s, fieldName) AND def IS "HI")> selected="selected"</cfif>>Hawaii</option>
<option value="ID"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ID") OR (NOT structKeyExists(s, fieldName) AND def IS "ID")> selected="selected"</cfif>>Idaho</option>
<option value="IL"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "IL") OR (NOT structKeyExists(s, fieldName) AND def IS "IL")> selected="selected"</cfif>>Illinois</option>
<option value="IN"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "IN") OR (NOT structKeyExists(s, fieldName) AND def IS "IN")> selected="selected"</cfif>>Indiana</option>
<option value="IA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "IA") OR (NOT structKeyExists(s, fieldName) AND def IS "IA")> selected="selected"</cfif>>Iowa</option>
<option value="KS"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "KS") OR (NOT structKeyExists(s, fieldName) AND def IS "KS")> selected="selected"</cfif>>Kansas</option>
<option value="KY"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "KY") OR (NOT structKeyExists(s, fieldName) AND def IS "KY")> selected="selected"</cfif>>Kentucky</option>
<option value="LA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "LA") OR (NOT structKeyExists(s, fieldName) AND def IS "LA")> selected="selected"</cfif>>Louisiana</option>
<option value="ME"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ME") OR (NOT structKeyExists(s, fieldName) AND def IS "ME")> selected="selected"</cfif>>Maine</option>
<option value="MD"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MD") OR (NOT structKeyExists(s, fieldName) AND def IS "MD")> selected="selected"</cfif>>Maryland</option>
<option value="MA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MA") OR (NOT structKeyExists(s, fieldName) AND def IS "MA")> selected="selected"</cfif>>Massachusetts</option>
<option value="MI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MI") OR (NOT structKeyExists(s, fieldName) AND def IS "MI")> selected="selected"</cfif>>Michigan</option>
<option value="MN"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MN") OR (NOT structKeyExists(s, fieldName) AND def IS "MN")> selected="selected"</cfif>>Minnesota</option>
<option value="MS"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MS") OR (NOT structKeyExists(s, fieldName) AND def IS "MS")> selected="selected"</cfif>>Mississippi</option>
<option value="MO"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MO") OR (NOT structKeyExists(s, fieldName) AND def IS "MO")> selected="selected"</cfif>>Missouri</option>
<option value="MT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MT") OR (NOT structKeyExists(s, fieldName) AND def IS "MT")> selected="selected"</cfif>>Montana</option>
<option value="NE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NE") OR (NOT structKeyExists(s, fieldName) AND def IS "NE")> selected="selected"</cfif>>Nebraska</option>
<option value="NV"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NV") OR (NOT structKeyExists(s, fieldName) AND def IS "NV")> selected="selected"</cfif>>Nevada</option>
<option value="NH"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NH") OR (NOT structKeyExists(s, fieldName) AND def IS "NH")> selected="selected"</cfif>>New Hampshire</option>
<option value="NJ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NJ") OR (NOT structKeyExists(s, fieldName) AND def IS "NJ")> selected="selected"</cfif>>New Jersey</option>
<option value="NM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NM") OR (NOT structKeyExists(s, fieldName) AND def IS "NM")> selected="selected"</cfif>>New Mexico</option>
<option value="NY"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NY") OR (NOT structKeyExists(s, fieldName) AND def IS "NY")> selected="selected"</cfif>>New York</option>
<option value="NC"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NC") OR (NOT structKeyExists(s, fieldName) AND def IS "NC")> selected="selected"</cfif>>North Carolina</option>
<option value="ND"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ND") OR (NOT structKeyExists(s, fieldName) AND def IS "ND")> selected="selected"</cfif>>North Dakota</option>
<option value="OH"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "OH") OR (NOT structKeyExists(s, fieldName) AND def IS "OH")> selected="selected"</cfif>>Ohio</option>
<option value="OK"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "OK") OR (NOT structKeyExists(s, fieldName) AND def IS "OK")> selected="selected"</cfif>>Oklahoma</option>
<option value="OR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "OR") OR (NOT structKeyExists(s, fieldName) AND def IS "OR")> selected="selected"</cfif>>Oregon</option>
<option value="PA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PA") OR (NOT structKeyExists(s, fieldName) AND def IS "PA")> selected="selected"</cfif>>Pennsylvania</option>
<option value="RI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "RI") OR (NOT structKeyExists(s, fieldName) AND def IS "RI")> selected="selected"</cfif>>Rhode Island</option>
<option value="SC"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SC") OR (NOT structKeyExists(s, fieldName) AND def IS "SC")> selected="selected"</cfif>>South Carolina</option>
<option value="SD"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SD") OR (NOT structKeyExists(s, fieldName) AND def IS "SD")> selected="selected"</cfif>>South Dakota</option>
<option value="TN"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TN") OR (NOT structKeyExists(s, fieldName) AND def IS "TN")> selected="selected"</cfif>>Tennessee</option>
<option value="TX"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TX") OR (NOT structKeyExists(s, fieldName) AND def IS "TX")> selected="selected"</cfif>>Texas</option>
<option value="UT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "UT") OR (NOT structKeyExists(s, fieldName) AND def IS "UT")> selected="selected"</cfif>>Utah</option>
<option value="VT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "VT") OR (NOT structKeyExists(s, fieldName) AND def IS "VT")> selected="selected"</cfif>>Vermont</option>
<option value="VA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "VA") OR (NOT structKeyExists(s, fieldName) AND def IS "VA")> selected="selected"</cfif>>Virginia</option>
<option value="WA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "WA") OR (NOT structKeyExists(s, fieldName) AND def IS "WA")> selected="selected"</cfif>>Washington</option>
<option value="WV"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "WV") OR (NOT structKeyExists(s, fieldName) AND def IS "WV")> selected="selected"</cfif>>West Virginia</option>
<option value="WI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "WI") OR (NOT structKeyExists(s, fieldName) AND def IS "WI")> selected="selected"</cfif>>Wisconsin</option>
<option value="WY"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "WY") OR (NOT structKeyExists(s, fieldName) AND def IS "WY")> selected="selected"</cfif>>Wyoming</option>
</cfsavecontent>

<cfassociate basetag="cf_field" datacollection="options" />
