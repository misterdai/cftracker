<!--- this tag should only run in "end" mode ---><cfif thisTag.executionMode IS "start"><cfexit method="exittemplate" /></cfif>
<cfsilent>
<!--- 
filename:		tags/forms/captcha_cfimage.cfm
date created:	07/20/2009
author:			Matt Graf (http://www.think-lab.net/)
purpose:		I create a CAPTCHA image with cf 8 cfimage tag
				
	// **************************************** LICENSE INFO **************************************** \\
	
	
	// ****************************************** REVISIONS ****************************************** \\
	
	DATE		DESCRIPTION OF CHANGES MADE												CHANGES MADE BY
	===================================================================================================
	07/20/2009		New																				MG
	
	02/21/2010		Changed attribute names to eliminate conflicts with other						MQ
						cfUniForm attribute names.
	
	02/22/2010		Fixed bug with difficulty, width, and height attributes.						MQ
						(they were hard-coded in the cfimage tag)
	
	02/22/2010		Added captchaFontSize and captchaDestination attributes.						MQ
	
 --->

<!--- // use example
	
	// REQUIRED ATTRIBUTES	
	@name					Required (string)		- The name of the field the word hash will be added to the end.  Used in the id="" and name="" attribute.
	
	// OPTIONAL ATTRIBUTES
	@id						Optional (string)		- The ID of the captcha field.
														Defaults to #attributes.name#.
													
	@captchaDifficulty		Optional (string)		- Level of complexity of the CAPTCHA text. Specify one of the following levels of text distortion:
													  (low, medium or high)

	@captchaWidth			Optional (integer)		- Width in pixels of the image. For resize, you also can specify the width as a percentage 
													  (an integer followed by the % symbol). When you resize an image, if you specify a value for the height, 
													  you can let ColdFusion calculate the aspect ratio by specifying "" as the width.
													  If specified, the value must be an integer.

	@captchaHeight			Optional (integer) 		- Height in pixels of the image.  For the resize attribute, you also can specify the height as a percentage 
													  (an integer followed by the percent (%) symbol). When you resize an image, if you specify a value for the width, 
													  you can let ColdFusion calculate the aspect ratio by specifying "" as the height.
													  If specified, the value must be an integer.

	@captchaMinChars		Optional (integer) 		- This is the minimum number of characters to be displayed in the CAPTCHA image the lowest is 1
	@captchaMaxChars		Optional (integer)		- This is the maximum number of characters to be displayed in the CAPTCHA image the highest is 8
	@captchaFonts			Optional (string)		- One or more valid fonts to use for the CAPTCHA text. Separate multiple fonts with commas. 
													  ColdFusion supports only the system fonts that the JDK can recognize. For example, TTF fonts in the Windows 
													  directory are supported on Windows.
	@captchaFontSize		Optional (integer)		- The font size for the CAPTCHA image.
	
	Note: For the CAPTCHA image to display, the width value must be greater than: 
			fontSize times the number of characters specified in text times 1.08. 
			In this example, the minimum width is 162.

	//Usage
	<cfmodule template="captcha_cf8.cfm" difficulty="medium" width="170" height="50" minChars="3" maxChars="6" fonts="arial" name="captcha" />
		
 --->


<!--- define the tag attributes --->
	<!--- required attributes --->
	<cfparam name="attributes.name" type="string" default="capctcha" /><!--- the word hash will be added to the end of the name --->
	
	<!--- optional attributes --->
	<cfparam name="attributes.id" default="#attributes.name#" />
	<cfparam name="attributes.captchaDifficulty" type="string" default="medium" />
	<cfparam name="attributes.captchaWidth" type="numeric" default="225" />
	<cfparam name="attributes.captchaHeight" type="numeric" default="75" />
	<cfparam name="attributes.captchaMinChars" type="numeric" default="3" />
	<cfparam name="attributes.captchaMaxChars" type="numeric" default="6" />
	<cfparam name="attributes.captchaFonts" type="string" default="Arial,Verdana,Courier New" />
	<cfparam name="attributes.captchaFontSize" type="numeric" default="24" />
	<cfparam name="attributes.local" type="struct" default="#structNew()#" /><!--- do not supply this attribute; it is used internally --->
	
	<cfif NOT IsNumeric(attributes.captchaMinChars) OR attributes.captchaMinChars GT 7 OR attributes.captchaMinChars LT 0 OR attributes.captchaMaxChars lt attributes.captchaMinChars>
		<cfset attributes.captchaMinChars = 6 />
	</cfif>
	
	<cfif NOT IsNumeric(attributes.captchaMaxChars) OR (attributes.captchaMaxChars GT 8 AND attributes.captchaMaxChars LT 1) OR (attributes.captchaMaxChars lt attributes.captchaMinChars)>
		<cfset attributes.captchaMaxChars = 6 />
	</cfif>
	
	<cfset attributes.local= structNew()>
	<cfset attributes.local.string = 'qwertyuiopas123456dfghjklzxcvbnm7890' />
	<cfset attributes.local.length = randrange(attributes.captchaMinChars,attributes.captchaMaxChars) />
	<cfset attributes.local.chars = "" />
	<cfloop from="1" to="#attributes.local.length#" index="attributes.local.i">
		<cfset attributes.local.chars = attributes.local.chars & mid(attributes.local.string, randrange(1,len(attributes.local.string)),1) />		
	</cfloop>
	<cfset attributes.local.captchaHash = hash(attributes.local.chars)>
	
</cfsilent>
<cfoutput><cfimage action="captcha" difficulty="#attributes.captchaDifficulty#" fonts="#attributes.captchaFonts#" fontSize="#attributes.captchaFontSize#" width="#attributes.captchaWidth#" height="#attributes.captchaHeight#" text="#attributes.local.chars#" /><input type="hidden" id="#attributes.id#hash" name="#attributes.name#hash" value="#attributes.local.captchaHash#" /></cfoutput>
