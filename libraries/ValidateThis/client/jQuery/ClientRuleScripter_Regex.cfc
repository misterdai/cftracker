<!---
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" name="ClientRuleScripter_Regex" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the regex validation.">

	<cffunction name="generateRuleScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="formName" type="Any" required="yes" />
		<cfargument name="defaultFailureMessagePrefix" type="Any" required="yes" />
		<cfargument name="customMessage" type="Any" required="no" default="" />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var theRegex = "" />

		<cfif StructKeyExists(arguments.validation.Parameters,"ServerRegex")>
			<cfset theRegex = arguments.validation.Parameters.ServerRegex />
		<cfelseif StructKeyExists(arguments.validation.Parameters,"Regex")>
			<cfset theRegex = arguments.validation.Parameters.Regex />
		</cfif>

		<cfif len(arguments.customMessage) EQ 0>
			<cfset arguments.customMessage = "#arguments.defaultFailureMessagePrefix##arguments.validation.PropertyDesc# does not match the specified pattern." />
		</cfif>

		<cfreturn generateAddMethod(arguments.validation,arguments.formName,"/#theRegex#/",arguments.customMessage,arguments.locale) />

	</cffunction>

</cfcomponent>


