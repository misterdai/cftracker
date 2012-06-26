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
<cfcomponent output="false" name="ClientRuleScripter_Required" extends="AbstractClientRuleScripter" hint="I am responsible for generating JS code for the required validation.">

	<cffunction name="generateSpecificValidationScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="formName" type="Any" required="yes" />

		<cfreturn "objForm#arguments.formName#.#arguments.validation.clientFieldName#.required = true;" />

		<!--- Old stuff from jQuery
		
		<cfset var theCondition = "" />
		<cfset var ConditionDesc = "" />
		<cfset var theMessage = "" />
		<cfset var theScript = "" />

		<!--- Deal with various conditions --->
		<cfif StructKeyExists(arguments.validation.Condition,"ClientTest")>
			<cfset theCondition = "function(element) { return #arguments.validation.Condition.ClientTest# }" />
		<cfelseif StructKeyExists(arguments.validation.Parameters,"DependentPropertyName")>
			<cfif StructKeyExists(arguments.validation.Parameters,"DependentPropertyValue")>
				<cfset theCondition = "function(element) { return $(""[name='#arguments.validation.Parameters.DependentPropertyName#']"").getValue() == #arguments.validation.Parameters.DependentPropertyValue#; }" />
			<cfelse>
				<cfset theCondition = "function(element) { return $(""[name='#arguments.validation.Parameters.DependentPropertyName#']"").getValue().length > 0; }" />
			</cfif>
		</cfif>
		<cfif Len(theCondition)>
			<cfif StructKeyExists(arguments.validation,"failureMessage")>
				<cfset theMessage = arguments.validation.failureMessage />
			<cfelseif StructKeyExists(arguments.validation.Parameters,"DependentPropertyDesc")>
				<cfif StructKeyExists(arguments.validation.Parameters,"DependentPropertyValue")>
					<cfset ConditionDesc = " based on what you entered for the " & arguments.validation.Parameters.DependentPropertyDesc />
				<cfelse>
					<cfset ConditionDesc = " if you specify a value for the " & arguments.validation.Parameters.DependentPropertyDesc />
				</cfif>
				<cfset theMessage = "The #arguments.validation.PropertyDesc# is required#ConditionDesc#." />
			</cfif>
			<cfset theScript = generateAddMethod(arguments.validation,theCondition,theMessage) />
		<cfelse>
			<cfset theScript = generateAddRule(arguments.validation) />
		</cfif>

		<cfreturn theScript />
		--->
		
	</cffunction>

</cfcomponent>


