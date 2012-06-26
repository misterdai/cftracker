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

	<cffunction name="generateRuleScript" returntype="any" access="public" output="false" hint="I generate the JS script required to implement a validation.">
		<cfargument name="validation" type="any" required="yes" hint="The validation struct that describes the validation." />
		<cfargument name="formName" type="Any" required="yes" />
		<cfargument name="defaultFailureMessagePrefix" type="Any" required="yes" />
		<cfargument name="customMessage" type="Any" required="no" default="" />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var theCondition = "" />
		<cfset var ConditionDesc = "" />
		<cfset var theScript = "" />
		<cfset var DependentFieldName = "" />
		<cfset var safeFormName = variables.getSafeFormName(arguments.formName) />

		<!--- Deal with various conditions --->
		<cfif StructKeyExists(arguments.validation.Condition,"ClientTest")>
			<cfset theCondition = "function(element) { return #arguments.validation.Condition.ClientTest# }" />
		<cfelse>
			<cfif StructKeyExists(arguments.validation.Parameters,"DependentFieldName")>
				<cfset DependentFieldName = arguments.validation.Parameters.DependentFieldName />
			<cfelseif StructKeyExists(arguments.validation.Parameters,"DependentPropertyName")>
				<cfset DependentFieldName = arguments.validation.Parameters.DependentPropertyName />
			</cfif>
		</cfif>
		<cfif len(DependentFieldName) GT 0>
			<cfif StructKeyExists(arguments.validation.Parameters,"DependentPropertyValue")>
				<cfset theCondition = "function(element) { return $form_#safeFormName#.find("":input[name='#DependentFieldName#']"").getValue() == '#arguments.validation.Parameters.DependentPropertyValue#'; }" />
			<cfelse>
				<cfset theCondition = "function(element) { return $form_#safeFormName#.find("":input[name='#DependentFieldName#']"").getValue().length > 0; }" />
			</cfif>
		</cfif>
		
		<cfif Len(theCondition)>
			<cfif len(arguments.customMessage) EQ 0 AND StructKeyExists(arguments.validation.Parameters,"DependentPropertyDesc")>
				<cfif StructKeyExists(arguments.validation.Parameters,"DependentPropertyValue")>
					<cfset ConditionDesc = " based on what you entered for the " & arguments.validation.Parameters.DependentPropertyDesc />
				<cfelse>
					<cfset ConditionDesc = " if you specify a value for the " & arguments.validation.Parameters.DependentPropertyDesc />
				</cfif>
				<cfset arguments.customMessage = "#arguments.defaultFailureMessagePrefix##arguments.validation.PropertyDesc# is required#ConditionDesc#." />
			</cfif>
			<cfset theScript = generateAddMethod(arguments.validation,arguments.formName,theCondition,arguments.customMessage,arguments.locale) />
		<cfelse>
			<cfset theScript = generateAddRule(argumentCollection=arguments) />
		</cfif>

		<cfreturn theScript />

	</cffunction>

</cfcomponent>


