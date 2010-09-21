<!--- run only in end mode ---><cfif thisTag.executionMode IS "start"><cfexit method="exittemplate" /></cfif>
<cfsilent>
<!--- 
filename:			tags/forms/fieldset.cfm
date created:	12/14/07
author:			Matt Quackenbush (http://www.quackfuzed.com/)
purpose:			I insert an XHTML Strict 1.0 fieldset tag based upon the Uni-Form markup
				
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
	12/14/07		New																				MQ
	
	6/1/08			Added support for jQuery's DatePicker and TimeEntry plugins				Dan Wilson
	
	6/18/08			Added support for type="custom"													MQ
	
	7/8/08			Fixed type=checkbox isChecked bug												MQ
	
	7/15/08			Added support for ignoring error message displays								MQ
						(See /tags/forms/cfUniForm/form.cfm for more details.)
	
	9/8/08			Added support for optgroup tag.										Bob Silverberg
	
	9/8/08			Deprecated the 'addClass' attribute and added 									MQ
						support for 'containerClass' and 'inputClass'
						(see field.cfm tag for more details)
	
	9/9/08			Made 'legend' an optional attribute												MQ
	
	9/22/08			Added support for jQuery's PrettyComments plugin					Bob Silverberg
						 (textarea resizing)
	
	9/22/08			Bug fix: 'inputClass' on textarea									Bob Silverberg
	
	11/12/08		Added support for labels passed in via the form tag, 				Bob Silverberg
						in support of integration with ValidateThis!.
						http://validatethis.riaforge.org/
						http://www.silverwareconsulting.com/index.cfm/ValidateThis
	
	2/19/09			v3.0 updates to support new Uni-Form markup.  Removed support 					MQ
						for previously deprecated items (see field.cfm tag comments
						for details).
	
	4/24/09			Added 'id' as an optional attribute												MQ
	
	6/29/09 		Added support for multiple selects (see field.cfm tag comments			Byron Raines
						for details).
	
	2/21/10			Added support for CAPTCHA field											Matt Graf
	
	2/22/10			Removed support for previously deprecated items									MQ
						(see field.cfm tag comments for details).
	
	2/23/10			Added support for type="rating"													MQ
	
	6/26/10			Updated for use with the new Uni-Form 1.4 theme-based CSS.						MQ
						- changed markup for radio, checkbox, and checkboxgroup
							to use <ul>
						- added new checkboxLabel class for type=checkbox
	
 --->

<!--- // use example
	
	// REQUIRED ATTRIBUTES
	(none)
	
	// OPTIONAL ATTRIBUTES
	@legend					Optional (string)	- Text to display in the rendered <legend></legend> tag
	@class						Optional (string) 	- Class name for the fieldset
																		defaults to 'inlineLabels'
	
	// STEPS TO USE THIS TAG
		
		For more info on all of the steps, see the "use example" comments in the UniForm Form.cfm tag.
		This tag is used in Step 3 of the form building process.
	
			<uform:fieldset legend="Required Fields" class="inlineLabels"> <------- this here is how you're calling this tag!!!
				<uform:field label="Email Address" name="emailAddress" isRequired="true" type="text" value="" hint="Note: Your email is your username.  Use a valid email address."  />
			</uform:fieldset>
	
 --->

<!--- define the tag attributes --->
	<!--- required attributes --->
	
	<!--- optional attributes --->
	<cfparam name="attributes.legend" type="string" default="" />
	<cfparam name="attributes.class" type="string" default="inlineLabels" />
	<cfparam name="attributes.id" type="string" default="cfU-#createUUID()#" />
	<cfparam name="attributes.content" type="string" default="" /><!--- do not supply this attribute; it is used internally --->
	
<cfscript>
	// get the errors from the top-level "form" tag
	errors = getBaseTagData('cf_form').attributes.errors;
	placement = getBaseTagData('cf_form').attributes.errorMessagePlacement;
	requiredFields = getBaseTagData('cf_form').attributes.requiredFields;
	fieldLabels = getBaseTagData('cf_form').attributes.fieldLabels;
	// if tag has content nested inside
	if ( len(trim(thisTag.generatedContent)) ) {
		/*
		*	add content as a tag attribute so its available to form tag, 
		*		and reset generatedContent so nothing is rendered
		*/
		attributes.content = trim(thisTag.generatedContent);
		thisTag.generatedContent = "";
	}
	/*
	*	init an empty struct for any masks that may be supplied
	*/
	attributes.masks = structNew();
	attributes.dateSetups = structNew();
	attributes.timeSetups = structNew();
	attributes.ratingSetups = structNew();
	// init hasUpload to false... need this to fix IE bug
	attributes.hasUpload = false;
</cfscript>
</cfsilent>
<cfsetting enablecfoutputonly="yes" />
<cfsavecontent variable="_fullContent">
<cfoutput>
<fieldset class="#attributes.class#" id="#attributes.id#"></cfoutput>
	<cfif len(attributes.legend) GT 0>
		<cfoutput><legend>#attributes.legend#</legend></cfoutput>
	</cfif>
	<cfoutput>#attributes.content#</cfoutput>
	
<!--- BEGIN: fields loop --->
<cfparam name="thisTag.fields" default="#arrayNew(1)#" />
<cfloop from="1" to="#arrayLen(thisTag.fields)#" index="f">
	<cfset thisField = thisTag.fields[f] />
	<!--- Check for a label passed into the form via the fieldLabels attribute (BS: 11/2008) --->
	<cfif (thisField.label EQ thisField.name) 
			AND 
				(structKeyExists(fieldLabels, thisField.name))>
		<cfset thisField.label = fieldLabels[thisField.name] />
	</cfif>
	<!--- if this field has a mask, add it to the struct to pass along to cf_form --->
	<cfif len(trim(thisField.mask)) GT 0>
		<cfset structInsert(attributes.masks, thisField.id, thisField.mask) />
	</cfif>
	<!--- if this field has a pluginSetup, add it to the appropriate struct to pass along to cf_form --->
	<cfif (isSimpleValue(thisField.pluginSetup) AND len(trim(thisField.pluginSetup)) GT 0) OR (isStruct(thisField.pluginSetup) AND structCount(thisField.pluginSetup) GT 0)>
		<cfscript>
			switch ( thisField.type ) {
				case "date" : {
					structInsert(attributes.dateSetups, thisField.id, thisField.pluginSetup);
					break;
				}
				case "time" : {
					structInsert(attributes.timeSetups, thisField.id, thisField.pluginSetup);
					break;
				}
			}
		</cfscript>
	</cfif>
	
	<cfif (NOT fieldHasErrors(thisField.name, errors)) OR (fieldHasErrors(thisField.name, errors) AND (listFindNoCase("none,top", placement) GT 0))>
		<cfoutput><div class="ctrlHolder<cfif structKeyExists(thisField, 'containerClass') AND len(thisField.containerClass) GT 0> #thisField.containerClass#</cfif><cfif thisField.type IS 'checkbox'> noLabel</cfif>"></cfoutput>
	<cfelseif (fieldHasErrors(thisField.name, errors)) AND (listFindNoCase("inline,both", placement) GT 0)>
		<cfif isStruct(errors)>
			<cfoutput><div class="ctrlHolder error<cfif structKeyExists(thisField, 'containerClass') AND len(thisField.containerClass) GT 0> #thisField.containerClass#</cfif><cfif thisField.type IS 'checkbox'> noLabel</cfif>"><p id="error-#thisField.name#" class="errorField">#errors[thisField.name]#</p></cfoutput>
		<cfelse>
			<cfscript>
				_usedIdx = "";
				_property = "property";
				if ( arrayLen(errors) GT 0 AND structKeyExists(errors[1], "field") ) {
					_property = "field";
				}
			</cfscript>
			<cfloop from="1" to="#arrayLen(errors)#" index="e">
				<cfif (listFind(_usedIdx, e) EQ 0) AND (compareNoCase(errors[e][_property],thisField.name) EQ 0)>
					<cfoutput><div class="ctrlHolder error"><p id="error-#thisField.name#" class="errorField">#errors[e].message#</cfoutput>
					<cfloop from="#e+1#" to="#arrayLen(errors)#" index="e2">
						<cfif (listFind(_usedIdx, e2) EQ 0) AND (compareNoCase(errors[e2][_property],errors[e][_property]) EQ 0)>
							<cfset _usedIdx = listAppend(_usedIdx, e2) />
							<cfoutput><br />#errors[e2].message#</cfoutput>
						</cfif>
					</cfloop>
					<cfoutput></p></cfoutput>
				</cfif>
			</cfloop>
		</cfif>
	<cfelse>
	</cfif>
	
	<cfif (listFindNoCase("checkboxgroup,checkbox,radio,custom,rating", thisField.type) EQ 0)>
		<cfoutput><label for="#thisField.id#"><cfif (structKeyExists(requiredFields, thisField.name)) OR (thisField.isRequired)><em>*</em></cfif> #thisField.label#</label></cfoutput>
	</cfif>
		<!--- BEGIN: fieldType check --->
		<cfif listFindNoCase("text,password", thisField.type)>
			<cfoutput><input name="#thisField.name#" id="#thisField.id#" value="#thisField.value#" size="#thisField.fieldSize#"<cfif thisField.maxFieldLength GT 0> maxlength="#thisField.maxFieldLength#"</cfif> type="#thisField.type#" class="textInput<cfif structKeyExists(thisField, 'inputClass') AND len(thisField.inputClass) GT 0> #thisField.inputClass#</cfif><cfif (structKeyExists(requiredFields, thisField.name)) OR (thisField.isRequired)> required</cfif><cfif fieldHasErrors(thisField.name, errors)> error</cfif>"<cfif thisField.isDisabled> disabled="disabled"</cfif> /></cfoutput>
		<cfelseif listFindNoCase("date,time", thisField.type)>
			<cfscript>
				_pickerType = uCase(left(thisField.type, 1)) & lCase(right(thisField.type, len(thisField.type)-1));
				_addClassRule = " has" & _pickerType & "Picker"; // add the has{Date|Time}Picker class to all, so that the CSS sizing is correct
				/* 
				*	Only add the add{Date|Time}Picker class if there are no field-specific pluginSetup instructions, 
				*	otherwise the plugin will ignore the setup rules for this particular field and behave in the default manner.
				*/
				if ( (isSimpleValue(thisField.pluginSetup) AND len(trim(thisField.pluginSetup)) EQ 0) OR (isStruct(thisField.pluginSetup) AND structCount(thisField.pluginSetup) EQ 0) ) {
					_addClassRule = _addClassRule & " add" & _pickerType & "Picker";
				}
			</cfscript>
			<cfoutput><input name="#thisField.name#" id="#thisField.id#" value="#thisField.value#" size="#thisField.fieldSize#"<cfif thisField.maxFieldLength GT 0> maxlength="#thisField.maxFieldLength#"</cfif> type="text" class="textInput#_addClassRule#<cfif (structKeyExists(requiredFields, thisField.name)) OR (thisField.isRequired)> required</cfif><cfif fieldHasErrors(thisField.name, errors)> error</cfif>"<cfif thisField.isDisabled> disabled="disabled"</cfif> /></cfoutput>
		<cfelseif thisField.type IS "textarea">
			<cfoutput><textarea name="#thisField.name#" id="#thisField.id#" rows="25" cols="25" class="<cfif structKeyExists(thisField, 'validation') AND len(thisField.validation) GT 0>#thisField.validation#</cfif><cfif (structKeyExists(requiredFields, thisField.name)) OR (thisField.isRequired)> required</cfif><cfif structKeyExists(thisField, 'inputClass') AND len(thisField.inputClass) GT 0> #thisField.inputClass#</cfif><cfif structKeyExists(thisField, 'textareaResizable') AND thisField.textareaResizable> resizableTextarea</cfif><cfif fieldHasErrors(thisField.name, errors)> error</cfif>"<cfif thisField.isDisabled> disabled="disabled"</cfif>>#thisField.value#</textarea></cfoutput>
		<cfelseif thisField.type IS "file">
			<cfset attributes.hasUpload = true />
			<cfoutput><input name="#thisField.name#" id="#thisField.id#" size="#thisField.fieldSize#" type="file" class="fileUpload<cfif structKeyExists(thisField, 'inputClass') AND len(thisField.inputClass) GT 0> #thisField.inputClass#</cfif><cfif fieldHasErrors(thisField.name, errors)> error</cfif>"<cfif thisField.isDisabled> disabled="disabled"</cfif> /></cfoutput>
		<cfelseif thisField.type IS "select">
			<cfoutput><select name="#thisField.name#" id="#thisField.id#" class="selectInput<cfif (structKeyExists(requiredFields, thisField.name)) OR (thisField.isRequired)> required</cfif><cfif structKeyExists(thisField, 'inputClass') AND len(thisField.inputClass) GT 0> #thisField.inputClass#</cfif><cfif fieldHasErrors(thisField.name, errors)> error</cfif>"<cfif thisField.isDisabled> disabled="disabled"</cfif><cfif thisField.selectSize GT 0> multiple="multiple" size="#thisField.selectSize#"</cfif>></cfoutput>
				<cfif structKeyExists(thisField, "options")>
					<cfloop from="1" to="#arrayLen(thisField.options)#" index="o">
						<cfif NOT structKeyExists(thisField.options[o], "content")>
							<cfoutput><option value="#thisField.options[o].value#"<cfif thisField.options[o].isSelected> selected="selected"</cfif>>#thisField.options[o].display#</option></cfoutput>
						<cfelse>
							<cfoutput>#thisField.options[o].content#</cfoutput>
						</cfif>
					</cfloop>
				<cfelseif structKeyExists(thisField, "optiongroups")>
					<cfloop from="1" to="#arrayLen(thisField.optiongroups)#" index="og">
						<cfif NOT structKeyExists(thisField.optiongroups[og], "content")>
							<cfoutput><optgroup label="#thisField.optiongroups[og].label#"<cfif thisField.isDisabled> disabled="disabled"</cfif>></cfoutput>
							<cfif structKeyExists(thisField.optiongroups[og], "options")>
								<cfloop from="1" to="#arrayLen(thisField.optiongroups[og].options)#" index="o">
									<cfif NOT structKeyExists(thisField.optiongroups[og].options[o], "content")>
										<cfoutput><option value="#thisField.optiongroups[og].options[o].value#"<cfif thisField.optiongroups[og].options[o].isSelected> selected="selected"</cfif>>#thisField.optiongroups[og].options[o].display#</option></cfoutput>
									<cfelse>
										<cfoutput>#thisField.optiongroups[og].options[o].content#</cfoutput>
									</cfif>
								</cfloop>
							<cfelse>
								<cfoutput>#thisField.optiongroups[og].content#</cfoutput>
							</cfif>
							<cfoutput></optgroup></cfoutput>
						<cfelse>
							<cfoutput>#thisField.optiongroups[og].content#</cfoutput>
						</cfif>
					</cfloop>
				<cfelse>
					<cfoutput>#thisField.content#</cfoutput>
				</cfif>
			<cfoutput></select></cfoutput>
		<cfelseif thisField.type IS "radio">
			<cfoutput><p class="label"><cfif (structKeyExists(requiredFields, thisField.name)) OR (thisField.isRequired)><em>*</em></cfif> #thisField.label#</p><ul class="blockLabels"></cfoutput>
			<cfloop from="1" to="#arrayLen(thisField.radios)#" index="r"><cfoutput><li><label for="#thisField.id#-#r#" class="inlineLabel"><input name="#thisField.name#" id="#thisField.id#-#r#" value="#thisField.radios[r].value#"<cfif thisField.radios[r].isChecked> checked="checked"</cfif> type="radio" class="<cfif structKeyExists(thisField, 'inputClass') AND len(thisField.inputClass) GT 0> #thisField.inputClass#</cfif><cfif (r EQ 1) AND (structKeyExists(requiredFields, thisField.name)) OR (thisField.isRequired)> required</cfif>" />&nbsp;#thisField.radios[r].label#</label></li></cfoutput>
				</cfloop><cfoutput></ul></cfoutput>
		<cfelseif thisField.type IS "checkboxgroup">
			<cfoutput><p class="label"><cfif (structKeyExists(requiredFields, thisField.name)) OR (thisField.isRequired)><em>*</em></cfif> #thisField.label#</p><ul class="blockLabels"></cfoutput>
			<cfloop from="1" to="#arrayLen(thisField.checkboxes)#" index="c">
				<cfif len(thisField.checkboxes[c].id) EQ 0>
					<cfoutput><li><label for="#thisField.id#-#c#" class="inlineLabel"><input name="#thisField.name#" id="#thisField.id#-#c#" value="#thisField.checkboxes[c].value#"<cfif thisField.checkboxes[c].isChecked> checked="checked"</cfif> type="checkbox" class="checkbox<cfif structKeyExists(thisField, 'inputClass') AND len(thisField.inputClass) GT 0> #thisField.inputClass#</cfif><cfif (c EQ 1) AND (structKeyExists(requiredFields, thisField.name)) OR (thisField.isRequired)> required</cfif>"<cfif thisField.isDisabled> disabled="disabled"</cfif> />&nbsp;#thisField.checkboxes[c].label#</label></li></cfoutput>
				<cfelse>
					<cfoutput><li><label for="#thisField.checkboxes[c].id#" class="inlineLabel"><input name="#thisField.checkboxes[c].name#" id="#thisField.checkboxes[c].id#" value="#thisField.checkboxes[c].value#"<cfif thisField.checkboxes[c].isChecked> checked="checked"</cfif> type="checkbox" class="checkbox<cfif structKeyExists(thisField, 'inputClass') AND len(thisField.inputClass) GT 0> #thisField.inputClass#</cfif><cfif (c EQ 1) AND (structKeyExists(requiredFields, thisField.name)) OR (thisField.isRequired)> required</cfif>"<cfif thisField.isDisabled> disabled="disabled"</cfif> />&nbsp;#thisField.checkboxes[c].label#</label></li></cfoutput>
				</cfif>
			</cfloop><cfoutput></ul></cfoutput>
		<cfelseif thisField.type IS "checkbox">
			<cfoutput><ul>
				<li><label for="#thisField.id#" class="checkboxLabel"><input name="#thisField.name#" id="#thisField.id#" value="#thisField.value#" type="checkbox" class="<cfif structKeyExists(thisField, 'inputClass') AND len(thisField.inputClass) GT 0> #thisField.inputClass#</cfif><cfif (structKeyExists(requiredFields, thisField.name)) OR (thisField.isRequired)> required</cfif>"<cfif structKeyExists(thisField, "isChecked") AND thisField.isChecked> checked="checked"</cfif><cfif thisField.isDisabled> disabled="disabled"</cfif> /><cfif (structKeyExists(requiredFields, thisField.name)) OR (thisField.isRequired)><em>*</em></cfif>&nbsp;#thisField.label#</label></li>
			</ul></cfoutput>
		
		<cfelseif thisField.type IS "rating">
			<cfscript>
				_starSetup = "";
				if ( thisField.starSplit GT 0 ) {
					_starSetup = _starSetup & "split:" & thisField.starSplit;
				}
				
				if ( thisField.showStarTips ) {
					if ( len(_starSetup) GT 0 ) {
						_starSetup = _starSetup & ",";
					}
					_starSetup = _starSetup & "focus:function(value,link){var tip = $('##" & thisField.name & "-startip'); tip[0].data = tip[0].data || tip.html(); tip.html(link.title || 'value: '+value);}";
					_starSetup = _starSetup & ",blur:function(value,link){var tip = $('##" & thisField.name & "-startip'); $('##" & thisField.name & "-startip').html(tip[0].data || '');}";
				}
				
				if ( len(_starSetup) GT 0 ) {
					structInsert(attributes.ratingSetups,thisField.name,"{" & _starSetup & "}");
				}
				
				// starValues is either a list or an array
				if ( isSimpleValue(thisField.starValues) ) {
					if ( listLen(thisField.starValues) EQ 0 ) {
						s2 = 0;
						starValues = "";
						for ( s2=1; s2 <= thisField.starCount; s2=s2+1 ) {
							starValues = listAppend(starValues,s2);
						}
					}
					starValues = listToArray(starValues);
				} else {
					starValues = thisField.starValues;
				}
				
				if ( isSimpleValue(thisField.starTitles) AND listLen(thisField.starTitles) EQ 0 ) {
					// nothing was provided; copy the starValues array
					starTitles = starValues;
				} else if ( isSimpleValue(thisField.starTitles) ) {
					// a list was provided; convert to array
					starTitles = listToArray(thisField.starTitles);
				} else {
					// it's already an array
					starTitles = thisField.starTitles;
				}
			</cfscript>
			<cfoutput><p class="label"><cfif (structKeyExists(requiredFields, thisField.name)) OR (thisField.isRequired)><em>*</em></cfif> #thisField.label#</p><div class="multiField"></cfoutput>
			<cfloop from="1" to="#thisField.starCount#" index="s">
				<cfoutput><input name="#thisField.name#" id="#thisField.id#-#s#" value="#starValues[s]#" title="#starTitles[s]#" type="radio" class="<cfif NOT structKeyExists(attributes.ratingSetups,thisField.name)> star</cfif><cfif structKeyExists(thisField, 'inputClass') AND len(thisField.inputClass) GT 0> #thisField.inputClass#</cfif><cfif (s EQ 1) AND (structKeyExists(requiredFields, thisField.name)) OR (thisField.isRequired)> required</cfif>"<cfif thisField.value IS starValues[s]> checked="checked"</cfif><cfif thisField.isDisabled> disabled="disabled"</cfif> /></cfoutput>
			</cfloop>
			<cfif thisField.showStarTips>
				<cfoutput><span id="#thisField.name#-startip" class="startip"></span></cfoutput>
			</cfif>
			<cfoutput></div></cfoutput>
		
		<!--- type="captcha" courtesy of Matt Graf (http://www.think-lab.net/) --->
		<cfelseif thisField.type IS "CAPTCHA">
			<!--- 2/20/10 MQ - need someone to test this on Railo, but according to the Railo docs, should work --->
			<cfif (findNoCase('coldfusion',server.ColdFusion.productname) GT 0 AND listFirst(server.ColdFusion.ProductVersion) GTE 8) OR (findNoCase('railo',server.ColdFusion.productname) GT 0)>
				<cfoutput><input name="#thisField.name#" id="#thisField.id#" value="#thisField.value#" size="#thisField.fieldSize#"<cfif thisField.maxFieldLength GT 0> maxlength="#thisField.maxFieldLength#"</cfif> type="text" class="textInput<cfif structKeyExists(thisField, 'inputClass') AND len(thisField.inputClass) GT 0> #thisField.inputClass#</cfif><cfif (structKeyExists(requiredFields, thisField.name)) OR (thisField.isRequired)> required</cfif>"<cfif thisField.isDisabled> disabled="disabled"</cfif> /><br /><br /><div class="captchaImage"></cfoutput>
					<cfmodule template="captcha_cfimage.cfm" attributecollection="#thisField#" />
				<cfoutput></div></cfoutput>
			<cfelse>
				<cffunction name="createRandomNumber" access="private" output="false" returntype="string">
					<cfscript>
						var numberString = '123456789';
						var length = randrange(1,2);
						var numbers = "";
						var i = 0;
						
						for ( i=1; i LTE length; i=i+1 ) {
							numbers = numbers & mid(numberString, randrange(1,len(numberString)),1);
						}
						return numbers;
					</cfscript>
				</cffunction>
				<cfscript>
					attributes.mathProblem = structNew();
					attributes.mathProblem.strReturn = "";
					attributes.mathProblem.strNumbers = "123456789";
					attributes.mathProblem.strOperators = "*,+,-";
					attributes.mathProblem.numbers = arrayNew(1);
					attributes.mathProblem.numbers[1] = createRandomNumber();
					attributes.mathProblem.numbers[2] = createRandomNumber();
					attributes.mathProblem.operator = listgetat(attributes.mathProblem.strOperators,randrange(1,3));
					attributes.mathProblem.answer = evaluate("#attributes.mathProblem.numbers[1]# #attributes.mathProblem.operator# #attributes.mathProblem.numbers[2]#");
					attributes.mathProblem.captchaHash = hash(attributes.mathProblem.answer);
				</cfscript>
				<cfoutput>
				#attributes.mathProblem.numbers[1]# #attributes.mathProblem.operator# #attributes.mathProblem.numbers[2]#
				<input name="#thisField.name#" id="#thisField.id#" value="#thisField.value#" size="#thisField.fieldSize#"<cfif thisField.maxFieldLength GT 0> maxlength="#thisField.maxFieldLength#"</cfif> type="text" class="textInput<cfif structKeyExists(thisField, 'inputClass') AND len(thisField.inputClass) GT 0> #thisField.inputClass#</cfif><cfif (structKeyExists(requiredFields, thisField.name)) OR (thisField.isRequired)> required</cfif>"<cfif thisField.isDisabled> disabled="disabled"</cfif> />
				<input type="hidden" id="#thisField.id#hash" name="#thisField.name#hash" value="#attributes.mathProblem.captchaHash#" />
				</cfoutput>
			</cfif>
		
		<cfelseif thisField.type IS "custom">
			<cfoutput>#thisField.content#</cfoutput>
		</cfif>
		<!--- END: fieldType check --->
			<cfif len(thisField.hint) GT 0><cfoutput><p class="formHint">#thisField.hint#</p></cfoutput></cfif>
		<cfoutput>
		</div>
		</cfoutput>
</cfloop>
<!--- END: fields loop --->
<cfoutput></fieldset>
</cfoutput>
</cfsavecontent>

<cffunction name="fieldHasErrors" hint="Returns a boolean indication of whether or not the provided field contains errors" returntype="boolean" output="false" access="private">
	<cfargument name="field" hint="The field name" required="yes" type="string" />
	<cfargument name="errors" hint="The errors struct or array" required="yes" type="any" />
	
	<cfscript>
		var rtn = false;
		var e = 0;
		var _property = "property";
		
		if ( isStruct(errors) ) {
			if ( structKeyExists(errors, field) ) {
				rtn = true;
			}
		} else {
			if ( arrayLen(errors) GT 0 AND structKeyExists(errors[1], "field") ) {
				_property = "field";
			}
			
			for ( e=1; e LTE arrayLen(errors); e=e+1 ) {
				if ( compareNoCase(errors[e][_property], field) EQ 0 ) {
					rtn = true;
					break;
				}
			}
		}
		
		return rtn;
	</cfscript>
</cffunction>

<cfset attributes.fullContent = _fullContent />
<cfsetting enablecfoutputonly="no" />
<cfassociate basetag="cf_form" datacollection="fieldsets" />
