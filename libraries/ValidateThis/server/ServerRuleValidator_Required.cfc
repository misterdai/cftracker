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
<cfcomponent output="false" name="ServerRuleValidator_Required" extends="AbstractServerRuleValidator" hint="I am responsible for performing the Required validation.">

	<cffunction name="validate" returntype="any" access="public" output="false" hint="I perform the validation returning info in the validation object.">
		<cfargument name="valObject" type="any" required="yes" hint="The validation object created by the business object being validated." />

		<cfset var Parameters = arguments.valObject.getParameters() />
		<cfset var theCondition = arguments.valObject.getCondition() />
		<cfset var ConditionDesc = "" />
		<cfset var theValue = arguments.valObject.getObjectValue() />
		
		<cfif NOT IsObject(theValue) AND Len(theValue) EQ 0>
			<cfif StructKeyExists(theCondition,"Desc")>
				<cfset ConditionDesc = " " & theCondition.Desc />
			<cfelseif StructKeyExists(Parameters,"DependentPropertyDesc")>
				<cfif StructKeyExists(Parameters,"DependentPropertyValue")>
					<cfset ConditionDesc = " based on what you entered for the " & Parameters.DependentPropertyDesc />
				<cfelse>
					<cfset ConditionDesc = " if you specify a value for the " & Parameters.DependentPropertyDesc />
				</cfif>
			</cfif>
			<cfset fail(arguments.valObject,createDefaultFailureMessage("#arguments.valObject.getPropertyDesc()# is required#ConditionDesc#.")) />
		</cfif>
	</cffunction>
	
</cfcomponent>
	

