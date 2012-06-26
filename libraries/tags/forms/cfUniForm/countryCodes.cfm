<cfsilent>
<!--- 
filename:			tags/forms/UniForm/CountryCodes.cfm
date created:	10/22/07
author:			Matt Quackenbush (http://www.quackfuzed.com)
purpose:			I display an XHTML Strict 1.0 option list of ISO-3166 country codes (sorted in alphabetical order by name)
							for use with the Uni-Form custom tags
				
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
	10/22/07		New																				MQ
	
 --->

<!--- // use example
	
	// REQUIRED ATTRIBUTES
	@defaultCountry		Required (string)	- the two-letter value of the default country (e.g. 'IE', 'US', 'UK')
	
	// OPTIONAL ATTRIBUTES
	@fieldName				Optional (string) 	- the name of the field in the form scope that contains the value
																		defaults to 'country'
	@struct					Optional (struct)	- the structure to check values against
																		defaults to #form#
	@showSelect			Optional (boolean)	- indicates whether or not to show the opening empty value "Select One" option
																			defaults to 'true'
	
	// STEPS TO USE THIS TAG
		
		For more info on all of the steps, see the "use example" comments in the UniForm Form.cfm tag.
		This tag is used in Step 3 of the form building process.
	
			<uform:field label="Country" name="country" isRequired="true" type="select">
				<uform:countryCodes /> <------- this here is how you're calling this tag!!!
			</uform:field>
	
 --->

<!--- define the tag attributes --->
	<!--- required attributes --->
	<cfparam name="attributes.defaultCountry" type="string" />
	
	<!--- optional attributes --->
	<cfparam name="attributes.fieldName" type="string" default="country" />
	<cfparam name="attributes.struct" type="struct" default="#form#" />
	<cfparam name="attributes.showSelect" type="boolean" default="yes" />
	<cfparam name="attributes.content" type="string" default="" /><!--- do not supply this attribute; it is used internally --->

<cfscript>
	s = attributes.struct;
	fieldName = attributes.fieldName;
	def = attributes.defaultCountry;
</cfscript>
</cfsilent>
<cfsavecontent variable="attributes.content">
<cfif attributes.showSelect><option value=""<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "") OR (NOT structKeyExists(s, fieldName) AND def IS "")> selected="selected"</cfif>>Select One</option></cfif>
<option value="AF"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AF") OR (NOT structKeyExists(s, fieldName) AND def IS "AF")> selected="selected"</cfif>>AFGHANISTAN</option>
<option value="AX"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AX") OR (NOT structKeyExists(s, fieldName) AND def IS "AX")> selected="selected"</cfif>>ÅLAND ISLANDS</option>
<option value="AL"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AL") OR (NOT structKeyExists(s, fieldName) AND def IS "AL")> selected="selected"</cfif>>ALBANIA</option>
<option value="DZ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "DZ") OR (NOT structKeyExists(s, fieldName) AND def IS "DZ")> selected="selected"</cfif>>ALGERIA</option>
<option value="AS"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AS") OR (NOT structKeyExists(s, fieldName) AND def IS "AS")> selected="selected"</cfif>>AMERICAN SAMOA</option>
<option value="AD"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AD") OR (NOT structKeyExists(s, fieldName) AND def IS "AD")> selected="selected"</cfif>>ANDORRA</option>
<option value="AO"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AO") OR (NOT structKeyExists(s, fieldName) AND def IS "AO")> selected="selected"</cfif>>ANGOLA</option>
<option value="AI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AI") OR (NOT structKeyExists(s, fieldName) AND def IS "AI")> selected="selected"</cfif>>ANGUILLA</option>
<option value="AQ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AQ") OR (NOT structKeyExists(s, fieldName) AND def IS "AQ")> selected="selected"</cfif>>ANTARCTICA</option>
<option value="AG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AG") OR (NOT structKeyExists(s, fieldName) AND def IS "AG")> selected="selected"</cfif>>ANTIGUA AND BARBUDA</option>
<option value="AR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AR") OR (NOT structKeyExists(s, fieldName) AND def IS "AR")> selected="selected"</cfif>>ARGENTINA</option>
<option value="AM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AM") OR (NOT structKeyExists(s, fieldName) AND def IS "AM")> selected="selected"</cfif>>ARMENIA</option>
<option value="AW"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AW") OR (NOT structKeyExists(s, fieldName) AND def IS "AW")> selected="selected"</cfif>>ARUBA</option>
<option value="AU"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AU") OR (NOT structKeyExists(s, fieldName) AND def IS "AU")> selected="selected"</cfif>>AUSTRALIA</option>
<option value="AT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AT") OR (NOT structKeyExists(s, fieldName) AND def IS "AT")> selected="selected"</cfif>>AUSTRIA</option>
<option value="AZ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AZ") OR (NOT structKeyExists(s, fieldName) AND def IS "AZ")> selected="selected"</cfif>>AZERBAIJAN</option>
<option value="BS"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BS") OR (NOT structKeyExists(s, fieldName) AND def IS "BS")> selected="selected"</cfif>>BAHAMAS</option>
<option value="BH"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BH") OR (NOT structKeyExists(s, fieldName) AND def IS "BH")> selected="selected"</cfif>>BAHRAIN</option>
<option value="BD"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BD") OR (NOT structKeyExists(s, fieldName) AND def IS "BD")> selected="selected"</cfif>>BANGLADESH</option>
<option value="BB"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BB") OR (NOT structKeyExists(s, fieldName) AND def IS "BB")> selected="selected"</cfif>>BARBADOS</option>
<option value="BY"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BY") OR (NOT structKeyExists(s, fieldName) AND def IS "BY")> selected="selected"</cfif>>BELARUS</option>
<option value="BE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BE") OR (NOT structKeyExists(s, fieldName) AND def IS "BE")> selected="selected"</cfif>>BELGIUM</option>
<option value="BZ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BZ") OR (NOT structKeyExists(s, fieldName) AND def IS "BZ")> selected="selected"</cfif>>BELIZE</option>
<option value="BJ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BJ") OR (NOT structKeyExists(s, fieldName) AND def IS "BJ")> selected="selected"</cfif>>BENIN</option>
<option value="BM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BM") OR (NOT structKeyExists(s, fieldName) AND def IS "BM")> selected="selected"</cfif>>BERMUDA</option>
<option value="BT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BT") OR (NOT structKeyExists(s, fieldName) AND def IS "BT")> selected="selected"</cfif>>BHUTAN</option>
<option value="BO"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BO") OR (NOT structKeyExists(s, fieldName) AND def IS "BO")> selected="selected"</cfif>>BOLIVIA</option>
<option value="BA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BA") OR (NOT structKeyExists(s, fieldName) AND def IS "BA")> selected="selected"</cfif>>BOSNIA AND HERZEGOVINA</option>
<option value="BW"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BW") OR (NOT structKeyExists(s, fieldName) AND def IS "BW")> selected="selected"</cfif>>BOTSWANA</option>
<option value="BV"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BV") OR (NOT structKeyExists(s, fieldName) AND def IS "BV")> selected="selected"</cfif>>BOUVET ISLAND</option>
<option value="BR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BR") OR (NOT structKeyExists(s, fieldName) AND def IS "BR")> selected="selected"</cfif>>BRAZIL</option>
<option value="IO"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "IO") OR (NOT structKeyExists(s, fieldName) AND def IS "IO")> selected="selected"</cfif>>BRITISH INDIAN OCEAN TERRITORY</option>
<option value="BN"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BN") OR (NOT structKeyExists(s, fieldName) AND def IS "BN")> selected="selected"</cfif>>BRUNEI DARUSSALAM</option>
<option value="BG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BG") OR (NOT structKeyExists(s, fieldName) AND def IS "BG")> selected="selected"</cfif>>BULGARIA</option>
<option value="BF"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BF") OR (NOT structKeyExists(s, fieldName) AND def IS "BF")> selected="selected"</cfif>>BURKINA FASO</option>
<option value="BI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "BI") OR (NOT structKeyExists(s, fieldName) AND def IS "BI")> selected="selected"</cfif>>BURUNDI</option>
<option value="KH"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "KH") OR (NOT structKeyExists(s, fieldName) AND def IS "KH")> selected="selected"</cfif>>CAMBODIA</option>
<option value="CM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CM") OR (NOT structKeyExists(s, fieldName) AND def IS "CM")> selected="selected"</cfif>>CAMEROON</option>
<option value="CA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CA") OR (NOT structKeyExists(s, fieldName) AND def IS "CA")> selected="selected"</cfif>>CANADA</option>
<option value="CV"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CV") OR (NOT structKeyExists(s, fieldName) AND def IS "CV")> selected="selected"</cfif>>CAPE VERDE</option>
<option value="KY"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "KY") OR (NOT structKeyExists(s, fieldName) AND def IS "KY")> selected="selected"</cfif>>CAYMAN ISLANDS</option>
<option value="CF"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CF") OR (NOT structKeyExists(s, fieldName) AND def IS "CF")> selected="selected"</cfif>>CENTRAL AFRICAN REPUBLIC</option>
<option value="TD"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TD") OR (NOT structKeyExists(s, fieldName) AND def IS "TD")> selected="selected"</cfif>>CHAD</option>
<option value="CL"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CL") OR (NOT structKeyExists(s, fieldName) AND def IS "CL")> selected="selected"</cfif>>CHILE</option>
<option value="CN"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CN") OR (NOT structKeyExists(s, fieldName) AND def IS "CN")> selected="selected"</cfif>>CHINA</option>
<option value="CX"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CX") OR (NOT structKeyExists(s, fieldName) AND def IS "CX")> selected="selected"</cfif>>CHRISTMAS ISLAND</option>
<option value="CC"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CC") OR (NOT structKeyExists(s, fieldName) AND def IS "CC")> selected="selected"</cfif>>COCOS (KEELING) ISLANDS</option>
<option value="CO"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CO") OR (NOT structKeyExists(s, fieldName) AND def IS "CO")> selected="selected"</cfif>>COLOMBIA</option>
<option value="KM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "KM") OR (NOT structKeyExists(s, fieldName) AND def IS "KM")> selected="selected"</cfif>>COMOROS</option>
<option value="CG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CG") OR (NOT structKeyExists(s, fieldName) AND def IS "CG")> selected="selected"</cfif>>CONGO</option>
<option value="CD"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CD") OR (NOT structKeyExists(s, fieldName) AND def IS "CD")> selected="selected"</cfif>>CONGO, THE DEMOCRATIC REPUBLIC OF THE</option>
<option value="CK"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CK") OR (NOT structKeyExists(s, fieldName) AND def IS "CK")> selected="selected"</cfif>>COOK ISLANDS</option>
<option value="CR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CR") OR (NOT structKeyExists(s, fieldName) AND def IS "CR")> selected="selected"</cfif>>COSTA RICA</option>
<option value="CI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CI") OR (NOT structKeyExists(s, fieldName) AND def IS "CI")> selected="selected"</cfif>>CÔTE D'IVOIRE</option>
<option value="HR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "HR") OR (NOT structKeyExists(s, fieldName) AND def IS "HR")> selected="selected"</cfif>>CROATIA</option>
<option value="CU"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CU") OR (NOT structKeyExists(s, fieldName) AND def IS "CU")> selected="selected"</cfif>>CUBA</option>
<option value="CY"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CY") OR (NOT structKeyExists(s, fieldName) AND def IS "CY")> selected="selected"</cfif>>CYPRUS</option>
<option value="CZ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CZ") OR (NOT structKeyExists(s, fieldName) AND def IS "CZ")> selected="selected"</cfif>>CZECH REPUBLIC</option>
<option value="DK"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "DK") OR (NOT structKeyExists(s, fieldName) AND def IS "DK")> selected="selected"</cfif>>DENMARK</option>
<option value="DJ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "DJ") OR (NOT structKeyExists(s, fieldName) AND def IS "DJ")> selected="selected"</cfif>>DJIBOUTI</option>
<option value="DM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "DM") OR (NOT structKeyExists(s, fieldName) AND def IS "DM")> selected="selected"</cfif>>DOMINICA</option>
<option value="DO"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "DO") OR (NOT structKeyExists(s, fieldName) AND def IS "DO")> selected="selected"</cfif>>DOMINICAN REPUBLIC</option>
<option value="EC"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "EC") OR (NOT structKeyExists(s, fieldName) AND def IS "EC")> selected="selected"</cfif>>ECUADOR</option>
<option value="EG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "EG") OR (NOT structKeyExists(s, fieldName) AND def IS "EG")> selected="selected"</cfif>>EGYPT</option>
<option value="SV"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SV") OR (NOT structKeyExists(s, fieldName) AND def IS "SV")> selected="selected"</cfif>>EL SALVADOR</option>
<option value="GQ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GQ") OR (NOT structKeyExists(s, fieldName) AND def IS "GQ")> selected="selected"</cfif>>EQUATORIAL GUINEA</option>
<option value="ER"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ER") OR (NOT structKeyExists(s, fieldName) AND def IS "ER")> selected="selected"</cfif>>ERITREA</option>
<option value="EE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "EE") OR (NOT structKeyExists(s, fieldName) AND def IS "EE")> selected="selected"</cfif>>ESTONIA</option>
<option value="ET"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ET") OR (NOT structKeyExists(s, fieldName) AND def IS "ET")> selected="selected"</cfif>>ETHIOPIA</option>
<option value="FK"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "FK") OR (NOT structKeyExists(s, fieldName) AND def IS "FK")> selected="selected"</cfif>>FALKLAND ISLANDS (MALVINAS)</option>
<option value="FO"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "FO") OR (NOT structKeyExists(s, fieldName) AND def IS "FO")> selected="selected"</cfif>>FAROE ISLANDS</option>
<option value="FJ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "FJ") OR (NOT structKeyExists(s, fieldName) AND def IS "FJ")> selected="selected"</cfif>>FIJI</option>
<option value="FI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "FI") OR (NOT structKeyExists(s, fieldName) AND def IS "FI")> selected="selected"</cfif>>FINLAND</option>
<option value="FR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "FR") OR (NOT structKeyExists(s, fieldName) AND def IS "FR")> selected="selected"</cfif>>FRANCE</option>
<option value="GF"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GF") OR (NOT structKeyExists(s, fieldName) AND def IS "GF")> selected="selected"</cfif>>FRENCH GUIANA</option>
<option value="PF"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PF") OR (NOT structKeyExists(s, fieldName) AND def IS "PF")> selected="selected"</cfif>>FRENCH POLYNESIA</option>
<option value="TF"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TF") OR (NOT structKeyExists(s, fieldName) AND def IS "TF")> selected="selected"</cfif>>FRENCH SOUTHERN TERRITORIES</option>
<option value="GA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GA") OR (NOT structKeyExists(s, fieldName) AND def IS "GA")> selected="selected"</cfif>>GABON</option>
<option value="GM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GM") OR (NOT structKeyExists(s, fieldName) AND def IS "GM")> selected="selected"</cfif>>GAMBIA</option>
<option value="GE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GE") OR (NOT structKeyExists(s, fieldName) AND def IS "GE")> selected="selected"</cfif>>GEORGIA</option>
<option value="DE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "DE") OR (NOT structKeyExists(s, fieldName) AND def IS "DE")> selected="selected"</cfif>>GERMANY</option>
<option value="GH"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GH") OR (NOT structKeyExists(s, fieldName) AND def IS "GH")> selected="selected"</cfif>>GHANA</option>
<option value="GI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GI") OR (NOT structKeyExists(s, fieldName) AND def IS "GI")> selected="selected"</cfif>>GIBRALTAR</option>
<option value="GR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GR") OR (NOT structKeyExists(s, fieldName) AND def IS "GR")> selected="selected"</cfif>>GREECE</option>
<option value="GL"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GL") OR (NOT structKeyExists(s, fieldName) AND def IS "GL")> selected="selected"</cfif>>GREENLAND</option>
<option value="GD"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GD") OR (NOT structKeyExists(s, fieldName) AND def IS "GD")> selected="selected"</cfif>>GRENADA</option>
<option value="GP"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GP") OR (NOT structKeyExists(s, fieldName) AND def IS "GP")> selected="selected"</cfif>>GUADELOUPE</option>
<option value="GU"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GU") OR (NOT structKeyExists(s, fieldName) AND def IS "GU")> selected="selected"</cfif>>GUAM</option>
<option value="GT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GT") OR (NOT structKeyExists(s, fieldName) AND def IS "GT")> selected="selected"</cfif>>GUATEMALA</option>
<option value="GG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GG") OR (NOT structKeyExists(s, fieldName) AND def IS "GG")> selected="selected"</cfif>>GUERNSEY</option>
<option value="GN"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GN") OR (NOT structKeyExists(s, fieldName) AND def IS "GN")> selected="selected"</cfif>>GUINEA</option>
<option value="GW"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GW") OR (NOT structKeyExists(s, fieldName) AND def IS "GW")> selected="selected"</cfif>>GUINEA-BISSAU</option>
<option value="GY"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GY") OR (NOT structKeyExists(s, fieldName) AND def IS "GY")> selected="selected"</cfif>>GUYANA</option>
<option value="HT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "HT") OR (NOT structKeyExists(s, fieldName) AND def IS "HT")> selected="selected"</cfif>>HAITI</option>
<option value="HM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "HM") OR (NOT structKeyExists(s, fieldName) AND def IS "HM")> selected="selected"</cfif>>HEARD ISLAND AND MCDONALD ISLANDS</option>
<option value="VA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "VA") OR (NOT structKeyExists(s, fieldName) AND def IS "VA")> selected="selected"</cfif>>HOLY SEE (VATICAN CITY STATE)</option>
<option value="HN"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "HN") OR (NOT structKeyExists(s, fieldName) AND def IS "HN")> selected="selected"</cfif>>HONDURAS</option>
<option value="HK"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "HK") OR (NOT structKeyExists(s, fieldName) AND def IS "HK")> selected="selected"</cfif>>HONG KONG</option>
<option value="HU"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "HU") OR (NOT structKeyExists(s, fieldName) AND def IS "HU")> selected="selected"</cfif>>HUNGARY</option>
<option value="IS"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "IS") OR (NOT structKeyExists(s, fieldName) AND def IS "IS")> selected="selected"</cfif>>ICELAND</option>
<option value="IN"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "IN") OR (NOT structKeyExists(s, fieldName) AND def IS "IN")> selected="selected"</cfif>>INDIA</option>
<option value="ID"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ID") OR (NOT structKeyExists(s, fieldName) AND def IS "ID")> selected="selected"</cfif>>INDONESIA</option>
<option value="IR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "IR") OR (NOT structKeyExists(s, fieldName) AND def IS "IR")> selected="selected"</cfif>>IRAN, ISLAMIC REPUBLIC OF</option>
<option value="IQ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "IQ") OR (NOT structKeyExists(s, fieldName) AND def IS "IQ")> selected="selected"</cfif>>IRAQ</option>
<option value="IE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "IE") OR (NOT structKeyExists(s, fieldName) AND def IS "IE")> selected="selected"</cfif>>IRELAND</option>
<option value="IM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "IM") OR (NOT structKeyExists(s, fieldName) AND def IS "IM")> selected="selected"</cfif>>ISLE OF MAN</option>
<option value="IL"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "IL") OR (NOT structKeyExists(s, fieldName) AND def IS "IL")> selected="selected"</cfif>>ISRAEL</option>
<option value="IT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "IT") OR (NOT structKeyExists(s, fieldName) AND def IS "IT")> selected="selected"</cfif>>ITALY</option>
<option value="JM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "JM") OR (NOT structKeyExists(s, fieldName) AND def IS "JM")> selected="selected"</cfif>>JAMAICA</option>
<option value="JP"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "JP") OR (NOT structKeyExists(s, fieldName) AND def IS "JP")> selected="selected"</cfif>>JAPAN</option>
<option value="JE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "JE") OR (NOT structKeyExists(s, fieldName) AND def IS "JE")> selected="selected"</cfif>>JERSEY</option>
<option value="JO"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "JO") OR (NOT structKeyExists(s, fieldName) AND def IS "JO")> selected="selected"</cfif>>JORDAN</option>
<option value="KZ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "KZ") OR (NOT structKeyExists(s, fieldName) AND def IS "KZ")> selected="selected"</cfif>>KAZAKHSTAN</option>
<option value="KE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "KE") OR (NOT structKeyExists(s, fieldName) AND def IS "KE")> selected="selected"</cfif>>KENYA</option>
<option value="KI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "KI") OR (NOT structKeyExists(s, fieldName) AND def IS "KI")> selected="selected"</cfif>>KIRIBATI</option>
<option value="KP"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "KP") OR (NOT structKeyExists(s, fieldName) AND def IS "KP")> selected="selected"</cfif>>KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF</option>
<option value="KR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "KR") OR (NOT structKeyExists(s, fieldName) AND def IS "KR")> selected="selected"</cfif>>KOREA, REPUBLIC OF</option>
<option value="KW"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "KW") OR (NOT structKeyExists(s, fieldName) AND def IS "KW")> selected="selected"</cfif>>KUWAIT</option>
<option value="KG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "KG") OR (NOT structKeyExists(s, fieldName) AND def IS "KG")> selected="selected"</cfif>>KYRGYZSTAN</option>
<option value="LA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "LA") OR (NOT structKeyExists(s, fieldName) AND def IS "LA")> selected="selected"</cfif>>LAO PEOPLE'S DEMOCRATIC REPUBLIC</option>
<option value="LV"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "LV") OR (NOT structKeyExists(s, fieldName) AND def IS "LV")> selected="selected"</cfif>>LATVIA</option>
<option value="LB"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "LB") OR (NOT structKeyExists(s, fieldName) AND def IS "LB")> selected="selected"</cfif>>LEBANON</option>
<option value="LS"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "LS") OR (NOT structKeyExists(s, fieldName) AND def IS "LS")> selected="selected"</cfif>>LESOTHO</option>
<option value="LR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "LR") OR (NOT structKeyExists(s, fieldName) AND def IS "LR")> selected="selected"</cfif>>LIBERIA</option>
<option value="LY"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "LY") OR (NOT structKeyExists(s, fieldName) AND def IS "LY")> selected="selected"</cfif>>LIBYAN ARAB JAMAHIRIYA</option>
<option value="LI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "LI") OR (NOT structKeyExists(s, fieldName) AND def IS "LI")> selected="selected"</cfif>>LIECHTENSTEIN</option>
<option value="LT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "LT") OR (NOT structKeyExists(s, fieldName) AND def IS "LT")> selected="selected"</cfif>>LITHUANIA</option>
<option value="LU"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "LU") OR (NOT structKeyExists(s, fieldName) AND def IS "LU")> selected="selected"</cfif>>LUXEMBOURG</option>
<option value="MO"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MO") OR (NOT structKeyExists(s, fieldName) AND def IS "MO")> selected="selected"</cfif>>MACAO</option>
<option value="MK"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MK") OR (NOT structKeyExists(s, fieldName) AND def IS "MK")> selected="selected"</cfif>>MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF</option>
<option value="MG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MG") OR (NOT structKeyExists(s, fieldName) AND def IS "MG")> selected="selected"</cfif>>MADAGASCAR</option>
<option value="MW"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MW") OR (NOT structKeyExists(s, fieldName) AND def IS "MW")> selected="selected"</cfif>>MALAWI</option>
<option value="MY"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MY") OR (NOT structKeyExists(s, fieldName) AND def IS "MY")> selected="selected"</cfif>>MALAYSIA</option>
<option value="MV"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MV") OR (NOT structKeyExists(s, fieldName) AND def IS "MV")> selected="selected"</cfif>>MALDIVES</option>
<option value="ML"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ML") OR (NOT structKeyExists(s, fieldName) AND def IS "ML")> selected="selected"</cfif>>MALI</option>
<option value="MT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MT") OR (NOT structKeyExists(s, fieldName) AND def IS "MT")> selected="selected"</cfif>>MALTA</option>
<option value="MH"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MH") OR (NOT structKeyExists(s, fieldName) AND def IS "MH")> selected="selected"</cfif>>MARSHALL ISLANDS</option>
<option value="MQ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MQ") OR (NOT structKeyExists(s, fieldName) AND def IS "MQ")> selected="selected"</cfif>>MARTINIQUE</option>
<option value="MR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MR") OR (NOT structKeyExists(s, fieldName) AND def IS "MR")> selected="selected"</cfif>>MAURITANIA</option>
<option value="MU"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MU") OR (NOT structKeyExists(s, fieldName) AND def IS "MU")> selected="selected"</cfif>>MAURITIUS</option>
<option value="YT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "YT") OR (NOT structKeyExists(s, fieldName) AND def IS "YT")> selected="selected"</cfif>>MAYOTTE</option>
<option value="MX"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MX") OR (NOT structKeyExists(s, fieldName) AND def IS "MX")> selected="selected"</cfif>>MEXICO</option>
<option value="FM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "FM") OR (NOT structKeyExists(s, fieldName) AND def IS "FM")> selected="selected"</cfif>>MICRONESIA, FEDERATED STATES OF</option>
<option value="MD"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MD") OR (NOT structKeyExists(s, fieldName) AND def IS "MD")> selected="selected"</cfif>>MOLDOVA, REPUBLIC OF</option>
<option value="MC"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MC") OR (NOT structKeyExists(s, fieldName) AND def IS "MC")> selected="selected"</cfif>>MONACO</option>
<option value="MN"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MN") OR (NOT structKeyExists(s, fieldName) AND def IS "MN")> selected="selected"</cfif>>MONGOLIA</option>
<option value="ME"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ME") OR (NOT structKeyExists(s, fieldName) AND def IS "ME")> selected="selected"</cfif>>MONTENEGRO</option>
<option value="MS"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MS") OR (NOT structKeyExists(s, fieldName) AND def IS "MS")> selected="selected"</cfif>>MONTSERRAT</option>
<option value="MA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MA") OR (NOT structKeyExists(s, fieldName) AND def IS "MA")> selected="selected"</cfif>>MOROCCO</option>
<option value="MZ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MZ") OR (NOT structKeyExists(s, fieldName) AND def IS "MZ")> selected="selected"</cfif>>MOZAMBIQUE</option>
<option value="MM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MM") OR (NOT structKeyExists(s, fieldName) AND def IS "MM")> selected="selected"</cfif>>MYANMAR</option>
<option value="NA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NA") OR (NOT structKeyExists(s, fieldName) AND def IS "NA")> selected="selected"</cfif>>NAMIBIA</option>
<option value="NR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NR") OR (NOT structKeyExists(s, fieldName) AND def IS "NR")> selected="selected"</cfif>>NAURU</option>
<option value="NP"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NP") OR (NOT structKeyExists(s, fieldName) AND def IS "NP")> selected="selected"</cfif>>NEPAL</option>
<option value="NL"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NL") OR (NOT structKeyExists(s, fieldName) AND def IS "NL")> selected="selected"</cfif>>NETHERLANDS</option>
<option value="AN"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AN") OR (NOT structKeyExists(s, fieldName) AND def IS "AN")> selected="selected"</cfif>>NETHERLANDS ANTILLES</option>
<option value="NC"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NC") OR (NOT structKeyExists(s, fieldName) AND def IS "NC")> selected="selected"</cfif>>NEW CALEDONIA</option>
<option value="NZ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NZ") OR (NOT structKeyExists(s, fieldName) AND def IS "NZ")> selected="selected"</cfif>>NEW ZEALAND</option>
<option value="NI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NI") OR (NOT structKeyExists(s, fieldName) AND def IS "NI")> selected="selected"</cfif>>NICARAGUA</option>
<option value="NE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NE") OR (NOT structKeyExists(s, fieldName) AND def IS "NE")> selected="selected"</cfif>>NIGER</option>
<option value="NG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NG") OR (NOT structKeyExists(s, fieldName) AND def IS "NG")> selected="selected"</cfif>>NIGERIA</option>
<option value="NU"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NU") OR (NOT structKeyExists(s, fieldName) AND def IS "NU")> selected="selected"</cfif>>NIUE</option>
<option value="NF"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NF") OR (NOT structKeyExists(s, fieldName) AND def IS "NF")> selected="selected"</cfif>>NORFOLK ISLAND</option>
<option value="MP"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "MP") OR (NOT structKeyExists(s, fieldName) AND def IS "MP")> selected="selected"</cfif>>NORTHERN MARIANA ISLANDS</option>
<option value="NO"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "NO") OR (NOT structKeyExists(s, fieldName) AND def IS "NO")> selected="selected"</cfif>>NORWAY</option>
<option value="OM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "OM") OR (NOT structKeyExists(s, fieldName) AND def IS "OM")> selected="selected"</cfif>>OMAN</option>
<option value="PK"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PK") OR (NOT structKeyExists(s, fieldName) AND def IS "PK")> selected="selected"</cfif>>PAKISTAN</option>
<option value="PW"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PW") OR (NOT structKeyExists(s, fieldName) AND def IS "PW")> selected="selected"</cfif>>PALAU</option>
<option value="PS"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PS") OR (NOT structKeyExists(s, fieldName) AND def IS "PS")> selected="selected"</cfif>>PALESTINIAN TERRITORY, OCCUPIED</option>
<option value="PA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PA") OR (NOT structKeyExists(s, fieldName) AND def IS "PA")> selected="selected"</cfif>>PANAMA</option>
<option value="PG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PG") OR (NOT structKeyExists(s, fieldName) AND def IS "PG")> selected="selected"</cfif>>PAPUA NEW GUINEA</option>
<option value="PY"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PY") OR (NOT structKeyExists(s, fieldName) AND def IS "PY")> selected="selected"</cfif>>PARAGUAY</option>
<option value="PE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PE") OR (NOT structKeyExists(s, fieldName) AND def IS "PE")> selected="selected"</cfif>>PERU</option>
<option value="PH"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PH") OR (NOT structKeyExists(s, fieldName) AND def IS "PH")> selected="selected"</cfif>>PHILIPPINES</option>
<option value="PN"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PN") OR (NOT structKeyExists(s, fieldName) AND def IS "PN")> selected="selected"</cfif>>PITCAIRN</option>
<option value="PL"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PL") OR (NOT structKeyExists(s, fieldName) AND def IS "PL")> selected="selected"</cfif>>POLAND</option>
<option value="PT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PT") OR (NOT structKeyExists(s, fieldName) AND def IS "PT")> selected="selected"</cfif>>PORTUGAL</option>
<option value="PR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PR") OR (NOT structKeyExists(s, fieldName) AND def IS "PR")> selected="selected"</cfif>>PUERTO RICO</option>
<option value="QA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "QA") OR (NOT structKeyExists(s, fieldName) AND def IS "QA")> selected="selected"</cfif>>QATAR</option>
<option value="RE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "RE") OR (NOT structKeyExists(s, fieldName) AND def IS "RE")> selected="selected"</cfif>>RÉUNION</option>
<option value="RO"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "RO") OR (NOT structKeyExists(s, fieldName) AND def IS "RO")> selected="selected"</cfif>>ROMANIA</option>
<option value="RU"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "RU") OR (NOT structKeyExists(s, fieldName) AND def IS "RU")> selected="selected"</cfif>>RUSSIAN FEDERATION</option>
<option value="RW"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "RW") OR (NOT structKeyExists(s, fieldName) AND def IS "RW")> selected="selected"</cfif>>RWANDA</option>
<option value="SH"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SH") OR (NOT structKeyExists(s, fieldName) AND def IS "SH")> selected="selected"</cfif>>SAINT HELENA</option>
<option value="KN"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "KN") OR (NOT structKeyExists(s, fieldName) AND def IS "KN")> selected="selected"</cfif>>SAINT KITTS AND NEVIS</option>
<option value="LC"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "LC") OR (NOT structKeyExists(s, fieldName) AND def IS "LC")> selected="selected"</cfif>>SAINT LUCIA</option>
<option value="PM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "PM") OR (NOT structKeyExists(s, fieldName) AND def IS "PM")> selected="selected"</cfif>>SAINT PIERRE AND MIQUELON</option>
<option value="VC"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "VC") OR (NOT structKeyExists(s, fieldName) AND def IS "VC")> selected="selected"</cfif>>SAINT VINCENT AND THE GRENADINES</option>
<option value="WS"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "WS") OR (NOT structKeyExists(s, fieldName) AND def IS "WS")> selected="selected"</cfif>>SAMOA</option>
<option value="SM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SM") OR (NOT structKeyExists(s, fieldName) AND def IS "SM")> selected="selected"</cfif>>SAN MARINO</option>
<option value="ST"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ST") OR (NOT structKeyExists(s, fieldName) AND def IS "ST")> selected="selected"</cfif>>SAO TOME AND PRINCIPE</option>
<option value="SA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SA") OR (NOT structKeyExists(s, fieldName) AND def IS "SA")> selected="selected"</cfif>>SAUDI ARABIA</option>
<option value="SN"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SN") OR (NOT structKeyExists(s, fieldName) AND def IS "SN")> selected="selected"</cfif>>SENEGAL</option>
<option value="RS"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "RS") OR (NOT structKeyExists(s, fieldName) AND def IS "RS")> selected="selected"</cfif>>SERBIA</option>
<option value="SC"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SC") OR (NOT structKeyExists(s, fieldName) AND def IS "SC")> selected="selected"</cfif>>SEYCHELLES</option>
<option value="SL"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SL") OR (NOT structKeyExists(s, fieldName) AND def IS "SL")> selected="selected"</cfif>>SIERRA LEONE</option>
<option value="SG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SG") OR (NOT structKeyExists(s, fieldName) AND def IS "SG")> selected="selected"</cfif>>SINGAPORE</option>
<option value="SK"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SK") OR (NOT structKeyExists(s, fieldName) AND def IS "SK")> selected="selected"</cfif>>SLOVAKIA</option>
<option value="SI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SI") OR (NOT structKeyExists(s, fieldName) AND def IS "SI")> selected="selected"</cfif>>SLOVENIA</option>
<option value="SB"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SB") OR (NOT structKeyExists(s, fieldName) AND def IS "SB")> selected="selected"</cfif>>SOLOMON ISLANDS</option>
<option value="SO"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SO") OR (NOT structKeyExists(s, fieldName) AND def IS "SO")> selected="selected"</cfif>>SOMALIA</option>
<option value="ZA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ZA") OR (NOT structKeyExists(s, fieldName) AND def IS "ZA")> selected="selected"</cfif>>SOUTH AFRICA</option>
<option value="GS"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GS") OR (NOT structKeyExists(s, fieldName) AND def IS "GS")> selected="selected"</cfif>>SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS</option>
<option value="ES"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ES") OR (NOT structKeyExists(s, fieldName) AND def IS "ES")> selected="selected"</cfif>>SPAIN</option>
<option value="LK"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "LK") OR (NOT structKeyExists(s, fieldName) AND def IS "LK")> selected="selected"</cfif>>SRI LANKA</option>
<option value="SD"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SD") OR (NOT structKeyExists(s, fieldName) AND def IS "SD")> selected="selected"</cfif>>SUDAN</option>
<option value="SR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SR") OR (NOT structKeyExists(s, fieldName) AND def IS "SR")> selected="selected"</cfif>>SURINAME</option>
<option value="SJ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SJ") OR (NOT structKeyExists(s, fieldName) AND def IS "SJ")> selected="selected"</cfif>>SVALBARD AND JAN MAYEN</option>
<option value="SZ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SZ") OR (NOT structKeyExists(s, fieldName) AND def IS "SZ")> selected="selected"</cfif>>SWAZILAND</option>
<option value="SE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SE") OR (NOT structKeyExists(s, fieldName) AND def IS "SE")> selected="selected"</cfif>>SWEDEN</option>
<option value="CH"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "CH") OR (NOT structKeyExists(s, fieldName) AND def IS "CH")> selected="selected"</cfif>>SWITZERLAND</option>
<option value="SY"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "SY") OR (NOT structKeyExists(s, fieldName) AND def IS "SY")> selected="selected"</cfif>>SYRIAN ARAB REPUBLIC</option>
<option value="TW"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TW") OR (NOT structKeyExists(s, fieldName) AND def IS "TW")> selected="selected"</cfif>>TAIWAN, PROVINCE OF CHINA</option>
<option value="TJ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TJ") OR (NOT structKeyExists(s, fieldName) AND def IS "TJ")> selected="selected"</cfif>>TAJIKISTAN</option>
<option value="TZ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TZ") OR (NOT structKeyExists(s, fieldName) AND def IS "TZ")> selected="selected"</cfif>>TANZANIA, UNITED REPUBLIC OF</option>
<option value="TH"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TH") OR (NOT structKeyExists(s, fieldName) AND def IS "TH")> selected="selected"</cfif>>THAILAND</option>
<option value="TL"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TL") OR (NOT structKeyExists(s, fieldName) AND def IS "TL")> selected="selected"</cfif>>TIMOR-LESTE</option>
<option value="TG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TG") OR (NOT structKeyExists(s, fieldName) AND def IS "TG")> selected="selected"</cfif>>TOGO</option>
<option value="TK"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TK") OR (NOT structKeyExists(s, fieldName) AND def IS "TK")> selected="selected"</cfif>>TOKELAU</option>
<option value="TO"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TO") OR (NOT structKeyExists(s, fieldName) AND def IS "TO")> selected="selected"</cfif>>TONGA</option>
<option value="TT"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TT") OR (NOT structKeyExists(s, fieldName) AND def IS "TT")> selected="selected"</cfif>>TRINIDAD AND TOBAGO</option>
<option value="TN"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TN") OR (NOT structKeyExists(s, fieldName) AND def IS "TN")> selected="selected"</cfif>>TUNISIA</option>
<option value="TR"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TR") OR (NOT structKeyExists(s, fieldName) AND def IS "TR")> selected="selected"</cfif>>TURKEY</option>
<option value="TM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TM") OR (NOT structKeyExists(s, fieldName) AND def IS "TM")> selected="selected"</cfif>>TURKMENISTAN</option>
<option value="TC"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TC") OR (NOT structKeyExists(s, fieldName) AND def IS "TC")> selected="selected"</cfif>>TURKS AND CAICOS ISLANDS</option>
<option value="TV"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "TV") OR (NOT structKeyExists(s, fieldName) AND def IS "TV")> selected="selected"</cfif>>TUVALU</option>
<option value="UG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "UG") OR (NOT structKeyExists(s, fieldName) AND def IS "UG")> selected="selected"</cfif>>UGANDA</option>
<option value="UA"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "UA") OR (NOT structKeyExists(s, fieldName) AND def IS "UA")> selected="selected"</cfif>>UKRAINE</option>
<option value="AE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "AE") OR (NOT structKeyExists(s, fieldName) AND def IS "AE")> selected="selected"</cfif>>UNITED ARAB EMIRATES</option>
<option value="GB"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "GB") OR (NOT structKeyExists(s, fieldName) AND def IS "GB")> selected="selected"</cfif>>UNITED KINGDOM</option>
<option value="US"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "US") OR (NOT structKeyExists(s, fieldName) AND def IS "US")> selected="selected"</cfif>>UNITED STATES</option>
<option value="UM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "UM") OR (NOT structKeyExists(s, fieldName) AND def IS "UM")> selected="selected"</cfif>>UNITED STATES MINOR OUTLYING ISLANDS</option>
<option value="UY"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "UY") OR (NOT structKeyExists(s, fieldName) AND def IS "UY")> selected="selected"</cfif>>URUGUAY</option>
<option value="UZ"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "UZ") OR (NOT structKeyExists(s, fieldName) AND def IS "UZ")> selected="selected"</cfif>>UZBEKISTAN</option>
<option value="VU"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "VU") OR (NOT structKeyExists(s, fieldName) AND def IS "VU")> selected="selected"</cfif>>VANUATU</option>
<option value="VE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "VE") OR (NOT structKeyExists(s, fieldName) AND def IS "VE")> selected="selected"</cfif>>VENEZUELA</option>
<option value="VN"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "VN") OR (NOT structKeyExists(s, fieldName) AND def IS "VN")> selected="selected"</cfif>>VIET NAM</option>
<option value="VG"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "VG") OR (NOT structKeyExists(s, fieldName) AND def IS "VG")> selected="selected"</cfif>>VIRGIN ISLANDS, BRITISH</option>
<option value="VI"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "VI") OR (NOT structKeyExists(s, fieldName) AND def IS "VI")> selected="selected"</cfif>>VIRGIN ISLANDS, U.S.</option>
<option value="WF"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "WF") OR (NOT structKeyExists(s, fieldName) AND def IS "WF")> selected="selected"</cfif>>WALLIS AND FUTUNA</option>
<option value="EH"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "EH") OR (NOT structKeyExists(s, fieldName) AND def IS "EH")> selected="selected"</cfif>>WESTERN SAHARA</option>
<option value="YE"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "YE") OR (NOT structKeyExists(s, fieldName) AND def IS "YE")> selected="selected"</cfif>>YEMEN</option>
<option value="ZM"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ZM") OR (NOT structKeyExists(s, fieldName) AND def IS "ZM")> selected="selected"</cfif>>ZAMBIA</option>
<option value="ZW"<cfif (structKeyExists(s, fieldName) AND s[fieldName] IS "ZW") OR (NOT structKeyExists(s, fieldName) AND def IS "ZW")> selected="selected"</cfif>>ZIMBABWE</option>
</cfsavecontent>

<cfassociate basetag="cf_field" datacollection="options" />
<cfexit method="exittag" />
