<!--- this tag should only run in "end" mode ---><cfif thisTag.executionMode IS "start"><cfexit method="exittemplate" /></cfif>
<cfsilent>
<!--- 
filename:		tags/forms/field.cfm
date created:	12/14/07
author:			Matt Quackenbush (http://www.quackfuzed.com/)
purpose:		I display an XHTML 1.0 Strict form field (text, password, select, checkbox, radio) based upon the Uni-Form markup
				
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
	
	6/1/08			Added support for jQuery's Masked-Input plugin.									MQ
					Added support for jQuery's form validation plugin.
					Added support for additional class(es) to be set on the field's holder div.
	
	7/11/08			Added support for isChecked on checkboxes.										MQ
	
	9/8/08			Deprecated the 'addClass' attribute and added 									MQ
						support for 'containerClass' and 'inputClass'
	
	9/22/08			Deprecated the 'textareaRows' and 'textareaCols' attributes						MQ
	
	9/22/08			Added support for jQuery's PrettyComments plugin 					Bob Silverberg
						 (textarea resizing)
	
	9/30/08			Added 'pluginSetup' attribute, used for passing field-specific 					MQ
						setup instructions to jQuery plugins.
	
	11/12/08		Behavior change for the 'label' attribute.  It is now optional, 	Bob Silverberg
						and defaults to the value of the 'name' attribute.
	
	2/19/09			Removed support for previously deprecated attributes:							MQ
							textareaRows
							textareaCols
							addClass
					
	2/19/09			Removed support for the isInline attribute, because of changes					MQ
						in the Uni-Form CSS.
					
	2/19/09			Deprecated the validation attribute. Use @inputClass instead.					MQ
	
	6/29/09			Added selectSize attribute to support 'muliple' attributes for			Byron Raines
						select tag

	7/9/09			Added id attribute. Defaults to value of 'name' attribute.				Byron Raines

	2/21/10			Added support for type="CAPTCHA", which includes the following			  Matt Graf
						new (optional) attributes:
							captchaDifficulty
							captchaWidth
							captchaHeight
							captchaMinChars
							captchaMaxChars
							captchaFonts

	2/22/10			Added support for type="rating", which includes the following					MQ
						new (optional) attributes:
							starCount
							starValues
							starTitles
							showStarTips
							starSplit
					
	2/22/10			Removed the previously deprecated validation attribute.							MQ
					
	2/23/10			Altered the data type and behavior of the 'pluginSetup' attribute.				MQ
						For details, view the commments in the use example section.
	
 --->

<!--- // use example
	
	// REQUIRED ATTRIBUTES
	@type					Required (string)		- The type of form field to display.  Acceptable values are:
																text
																password
																checkboxgroup
																checkbox
																radio
																textarea
																select
																custom
																date
																time
																rating
																captcha
	@name					Required unless type="custom" (string)		- The name of the field.  Used in the id="" and name="" attribute.
	
	// OPTIONAL ATTRIBUTES
	@label					Optional (string)		- The text to display as a label for the field.  Used in the <label></label> tag.
															Defaults to the value of the name attribute.
	@value					Optional (string)		- The value of the field.  Defaults to an empty string.
	@hint					Optional (string) 		- help text to display for the field
	@errorMessage			Optional (string) 		- the error message to display (used after failed validation)
	@isRequred				Optional (boolean)	- indicates whether or not the field is required
																				defaults to 'false'
	@isDisabled				Optional (boolean)	- indicates whether or not the field is enabled (supplying a value of 'true' will set disabled="disabled" on the field)
																				defaults to 'false'
	@isChecked				Optional (boolean)	- indicates whether or not the checkbox is checked; ignored unless type="checkbox"
																				defaults to 'false'
	@fieldSize				Optional (numeric)	- used in the size="" attribute of <input /> tags
																				defaults to 35
	@maxFieldLength			Optional (numeric)	- used in the maxlength="" attribute of <input /> tags
																				defaults to 50
	@textareaResizable		Optional (boolean)	- indicates whether or not the text area should be resizable
																		defaults to 'true'
													NOTE: This attribute is completely ignore unless type="textarea" AND 
															the 'loadTextareaResizable' attribute is provided to the form (and set to true).
	@containerClass			Optional (string) 			- additional class attributes for the the holder div of the field.
	@inputClass				Optional (string) 			- additional class attributes for the input tag of the field.
	@mask					Optional (string)			- The mask to which the field must conform.  Used in conjunction with 
																jQuery's Masked Input plugin.
	@pluginSetup			Optional (any)				- Field-specific setup instructions to pass to a jQuery plugin. Must
																be either a struct or a valid setup string.
																
																Ex. 1:
																type="date" pluginSetup="{ yearRange: '2000:2010' }"
																
																The line above would have the year drop down rendered by 
																the datepicker plugin display the years 2000-2010.  It 
																would only affect this particular field, allowing you to 
																pass different values to different date fields in your form.
																
																Ex. 2:
																dateConfig = structNew();
																dateConfig['yearRange'] = "'2000:2010'";
																type="date" pluginSetup="#dateConfig#"
																
																The lines above are functionally identical to Ex. 1 above.
																
																NOTE: If 'pluginSetup' is a struct, it will be automatically 
																converted to a setup string, keeping values intact.  If it
																is provided as a string, it will be passed to the plugin as-is.
																It is imperative that you place quotes where appropriate, and
																have no quotes where inappropriate.
	
	@starCount				Optional(numeric)			- The number of stars to display for type="rating". For use with
																jQuery's Star Rating plugin.
																Defaults to 5.
															NOTE: This attribute is ignored unless type="rating".
	@starValues				Optional(any)				- Comma-delimited list OR array of values for the rating stars. For use with
																jQuery's Star Rating plugin.
																Defaults to '1 through #starCount#'.
															NOTE: This attribute is ignored unless type="rating".
	@starTitles				Optional(any)				- Comma-delimited list OR array of titles for the rating stars.  These values
																will be added to the field's title attribute.  For use with
																jQuery's Star Rating plugin.
																Defaults to #attributes.starValues#.
															NOTE: This attribute is ignored unless type="rating".
	@showStarTips			Optional(boolean)			- Indicates whether or not to show the "starTitles" when hovering over
																the rating stars.  For use with jQuery's Star Rating plugin.
																Defaults to false.
															NOTE: This attribute is ignored unless type="rating".
	@starSplit				Optional(numeric)			- The number of star splits for type="rating". For use with
																jQuery's Star Rating plugin. This attribute is used when
																you want to provide "1/2 stars" or "1/4 stars" ratings.
																For example, if you want to provide a 5-star rating, but
																split in 1/2 stars (e.g. 3-1/2 stars), you would set 
																starSplit="2".
																Defaults to 0.
															NOTE: This attribute is ignored unless type="rating".
																
	@captchaDifficulty		Optional (string)			- The level of difficulty for the generated CAPTCHA image.
																Defaults to "medium".
															NOTE: This attribute is ignored unless type="captcha".
	@captchaWidth			Optional (numeric)			- The width for the generated CAPTCHA image.
																Defaults to 225.
															NOTE: This attribute is ignored unless type="captcha".
	@captchaHeight			Optional (numeric)			- The height for the generated CAPTCHA image.
																Defaults to 75.
															NOTE: This attribute is ignored unless type="captcha".
	@captchaMinChars		Optional (numeric)			- The minimum number of characters for the generated CAPTCHA image.
																Defaults to 3.
															NOTE: This attribute is ignored unless type="captcha".
	@captchaMaxChars		Optional (numeric)			- The maximum number of characters for the generated CAPTCHA image.
																Defaults to 6.
															NOTE: This attribute is ignored unless type="captcha".
	@captchaFonts			Optional (string)			- Comma-delimited list of fonts for the generated CAPTCHA image.
																Defaults to "Arial,Verdana,Courier New".
															NOTE: This attribute is ignored unless type="captcha".
	
	@selectSize				Optional (numeric)	- if GT 0, adds multiple="multiple" to select tag for multiple selects.  Defaults to '0'.
	@id						Optional (string)	- used in "id=" attribute.  Defaults to "name=" attribute.
	
	
	// STEPS TO USE THIS TAG
		
		For more info on all of the steps, see the "use example" comments in the UniForm Form.cfm tag.
		This tag is used in Step 3 of the form building process.
		
		type="text"
			
			<uform:field label="Email Address" name="emailAddress" isRequired="true" type="text" value="" hint="Note: Your email is your username.  Use a valid email address."  />
			
		type="password"
			
			<uform:field label="Choose Password" name="password" isRequired="true" type="password" value=""  />
			
		type="radio"
			
			<uform:field label="Gender" name="gender" type="radio"> <------- this here is how you're calling this tag!!!
				<uform:radio label="Male" value="1" />
				<uform:radio label="Female" value="2" />
			</uform:field>
		
		type="checkboxgroup"
			
			<uform:field label="Display Options" name="displayOptions" type="checkboxgroup"> <------- this here is how you're calling this tag!!!
				<uform:checkbox label="Display my email address" value="email" />
				<uform:checkbox label="Display my picture" value="pic" />
			</uform:field>
			
		type="checkbox"
			
			<uform:field label="Send me your news and information (a.k.a. junk)" name="newsletter" value="1" type="checkbox"  />
			
		type="textarea"
			
			<uform:field label="About You" name="aboutYou" type="textarea" value="" hint="Tell us something about yourself in 300 words or less."  />
			
		type="select"
			
			<uform:field label="A Select Box" name="selectbox" type="select"> <------- this here is how you're calling this tag!!!
				<option value="1">Option A</option>
				<option value="2">Option B</option>
				<option value="3">Option C</option>
				<option value="4">Option D</option>
				<option value="5">Option E</option>
			</uform:field>
			
		type="file"
			
			<uform:field label="Upload Picture" name="upload" type="file" hint="Your image will be resized to 80x80 pixels."  />
		
		type="custom"
			
			<uform:field type="custom">
				// anything you want to display here.
			</uform:field>
	
		type="date"
			
			// Note that we've added inputClass="date" in this example. This is picked up by the validation plugin and forces a date to be entered.
			<uform:field label="Date of Birth" name="contactDOB" isRequired="true" type="date" inputClass="date" />
		
		type="time"
			
			<uform:field label="Appointment Time" name="appointmentTime" isRequired="false" type="time" />
			
		type="rating"
			
			/*
			*	NOTE: To indicate the "checked" star, supply the appropriate value using the 'value' attribute.
			*		For instance, using the example below, if you want to display "3 Stars", add value="3" to 
			*		the attributes.
			*/
			<uform:field name="rateIt" label="How do we rate?" type="rating" value="3" starCount="5" starValues="1,2,3,4,5" starTitles="You Suck!,Somewhat Disappointing,As Expected,Slightly Impressed,You Totally Rock!" showStarTitles="true" />
			
		type="captcha"
			
			/*
			*	You can configure the captcha by providing any or all of the following attributes and changing the default values:
			*
			*	captchaDifficulty	 (default="medium")
			*	captchaWidth		 (default="170")
			*	captchaHeight		 (default="50")
			*	captchaMinChars		 (default="3")
			*	captchaMaxChars		 (default="6")
			*	captchaFonts		 (default="Arial,Verdana,Courier New")
			*
			*/
			<uform:field name="solveIt" label="Please enter the letters/numbers you see" type="captcha" />
			
 --->


<!--- define the tag attributes --->
	<!--- required attributes --->
	<cfparam name="attributes.type" type="string" />
	
	<!--- optional attributes --->
	<cfparam name="attributes.name" type="string" default="" />
	<cfparam name="attributes.id" type="string" default="#attributes.name#" />
	<cfparam name="attributes.label" type="string" default="#attributes.name#" />
	<cfparam name="attributes.value" type="string" default="" />
	<cfparam name="attributes.hint" type="string" default="" />
	<cfparam name="attributes.isRequired" type="boolean" default="no" />
	<cfparam name="attributes.isDisabled" type="boolean" default="no" />
	<cfparam name="attributes.isChecked" type="boolean" default="no" />
	<cfparam name="attributes.selectSize" type="numeric" default="0" />
	<cfparam name="attributes.fieldSize" type="numeric" default="35" />
	<cfparam name="attributes.maxFieldLength" type="numeric" default="50" />
	<cfparam name="attributes.textareaResizable" type="boolean" default="yes" />
	<cfparam name="attributes.containerClass" type="string" default="" />
	<cfparam name="attributes.inputClass" type="string" default="" />
	<cfparam name="attributes.mask" type="string" default="" />
	<cfparam name="attributes.pluginSetup" type="any" default="" />
	<cfparam name="attributes.starCount" type="numeric" default="5" />
	<cfparam name="attributes.starValues" type="any" default="" />
	<cfparam name="attributes.starTitles" type="any" default="" />
	<cfparam name="attributes.showStarTips" type="boolean" default="no" />
	<cfparam name="attributes.starSplit" type="numeric" default="0" />
	<cfparam name="attributes.captchaDifficulty" type="string" default="medium" />
	<cfparam name="attributes.captchaWidth" type="numeric" default="225" />
	<cfparam name="attributes.captchaHeight" type="numeric" default="75" />
	<cfparam name="attributes.captchaMinChars" type="numeric" default="3" />
	<cfparam name="attributes.captchaMaxChars" type="numeric" default="6" />
	<cfparam name="attributes.captchaFonts" type="string" default="Arial,Verdana,Courier New" />
	<cfparam name="attributes.content" type="string" default="" /><!--- do not supply this attribute; it is used internally --->

<!--- make sure that we have a label and a name if the type is not "custom" --->
<cfif (attributes.type IS NOT "custom") AND (len(trim(attributes.name)) EQ 0)>
	<cfthrow type="tags.forms.cfUniForm.field.incomplete" detail="You *must* supply the 'name' argument with type='#attributes.type#'" />
</cfif>

<!--- only an array or a string is permitted for 'starValues' and 'starTitles' if the type is "rating" --->
<cfif attributes.type IS "rating">
	<cfif NOT isSimpleValue(attributes.starValues) AND NOT isArray(attributes.starValues)>
		<cfthrow type="tags.forms.cfUniForm.field.invalidStarValues" detail="You *must* supply either a comma-delimited list or an array with the 'starValues' argument" />
	<cfelseif NOT isSimpleValue(attributes.starTitles) AND NOT isArray(attributes.starTitles)>
		<cfthrow type="tags.forms.cfUniForm.field.invalidStarTitles" detail="You *must* supply either a comma-delimited list or an array with the 'starTitles' argument" />
	</cfif>
</cfif>

<cfscript>
	// if tag has content nested inside
	if ( len(trim(thisTag.generatedContent)) ) {
		/*
		*	add content as a tag attribute so its available to fieldset tag, 
		*		and reset generatedContent so nothing is rendered
		*/
		attributes.content = trim(thisTag.generatedContent);
		thisTag.generatedContent = "";
	}
	// does tag have any optiongroups associated with it?
	if ( structKeyExists(thisTag, "optiongroups") ) {
		// pass them on in the attributes
		attributes.optiongroups = thisTag.optiongroups;
	}
	// does tag have any options associated with it?
	if ( structKeyExists(thisTag, "options") ) {
		// pass them on in the attributes
		attributes.options = thisTag.options;
	}
	// does tag have any radios associated with it?
	if ( structKeyExists(thisTag, "radios") ) {
		// pass them on in the attributes
		attributes.radios = thisTag.radios;
	}
	// does tag have any checkboxes associated with it?
	if ( structKeyExists(thisTag, "checkboxes") ) {
		// pass them on in the attributes
		attributes.checkboxes = thisTag.checkboxes;
	}
</cfscript>

<cfassociate basetag="cf_fieldset" datacollection="fields" />
</cfsilent>
