<!---
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" hint="I am a responsible for reading and processing an XML file.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new XMLFileReader">

		<cfset variables.propertyDescs = {} />
		<cfset variables.clientFieldDescs = {} />
		<cfset variables.conditions = {} />
		<cfset variables.contexts = {} />
		<cfset variables.formContexts = {} />
		<cfset variables.validations = {contexts = {___Default = ArrayNew(1)}} />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="loadRules" returnType="void" access="public" output="false" hint="I read the validations XML file and reformat it into a struct">
		<cfargument name="metadataSource" type="any" required="true" />
		
		<cfthrow type="ValidateThis.core.BaseMetadataProcessor.MissingImplementation" detail="The loadRules method must be implemented in a concrete object" />

	</cffunction>
	
	<cffunction name="getValidations" returnType="struct" access="public" output="false" hint="I return the processed metadata in a struct that is expected by the BOValidator">
		<cfargument name="metadataSource" type="any" required="true" hint="the source of the metadata - may be a filename or a metadata struct" />
		<cfset loadRules(arguments.metadataSource) />
		<cfset returnStruct = {propertyDescs=variables.propertyDescs,clientFieldDescs=variables.clientFieldDescs,formContexts=variables.formContexts,validations=variables.validations} />
		<cfreturn returnStruct />
	</cffunction>
	
	<cffunction name="determineLabel" returntype="string" output="false" access="private">
	<cfargument name="label" type="string" required="true" />
	
	<cfset var i = "" />
	<cfset var char = "" />
	<cfset var result = "" />
	
	<cfloop from="1" to="#len(arguments.label)#" index="i">
		<cfset char = mid(arguments.label, i, 1) />
		
		<cfif i eq 1>
			<cfset result = result & ucase(char) />
		<cfelseif asc(lCase(char)) neq asc(char)>
			<cfset result = result & " " & ucase(char) />
		<cfelse>
			<cfset result = result & char />
		</cfif>
	</cfloop>

	<cfreturn result />	
	</cffunction>

	<cffunction name="processConditions" returnType="void" access="private" output="false" hint="I process condition metadata">
		<cfargument name="conditions" type="any" required="true" />
		<cfloop array="#arguments.conditions#" index="theCondition">
			<cfset variables.conditions[theCondition.name] = theCondition />
		</cfloop>
	</cffunction>

	<cffunction name="processContexts" returnType="void" access="private" output="false" hint="I process context metadata">
		<cfargument name="contexts" type="any" required="true" />
		<cfloop array="#arguments.contexts#" index="theContext">
			<cfset variables.contexts[theContext.name] = theContext />
			<cfif structKeyExists(theContext,"formName")>
				<cfset variables.formContexts[theContext.name] = theContext.formName />
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="processPropertyDescs" returnType="any" access="private" output="false" hint="I process property descriptions">
		<cfargument name="properties" type="any" required="true" />
		
		<cfset var theProperty = 0 />
		<cfset var theName = 0 />
		<cfset var theDesc = 0 />
		<cfloop array="#arguments.properties#" index="theProperty">
			<cfset theName = theProperty.name />
			<cfif StructKeyExists(theProperty,"desc")>
				<cfset theDesc = theProperty.desc />
			<cfelse>
				<cfset theDesc = determineLabel(theName) />
			</cfif>
			<cfif theDesc NEQ theName>
				<cfset variables.propertyDescs[theName] = theDesc />
				<cfif StructKeyExists(theProperty,"clientfieldname")>
					<cfset variables.clientFieldDescs[theProperty.clientfieldname] = theDesc />
				<cfelse>
					<cfset variables.clientFieldDescs[theName] = theDesc />
				</cfif>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="processPropertyRules" returnType="any" access="private" output="false" hint="I process property rules">
		<cfargument name="properties" type="any" required="true" />
		<cfloop array="#arguments.properties#" index="theProperty">
			<cfif structKeyExists(theProperty,"rules")>
				<cfloop array="#theProperty.rules#" index="theRule">
					<cfset theVal = {propertyName = theProperty.name, valType = theRule.type, parameters = structNew()} />
					<cfif StructKeyExists(theProperty,"desc")>
						<cfset theVal.PropertyDesc = theProperty.desc />
					<cfelse>
						<cfset theVal.PropertyDesc = determineLabel(theVal.PropertyName) />
					</cfif>
					<cfif StructKeyExists(theProperty,"clientfieldname")>
						<cfset theVal.ClientFieldName = theProperty.clientfieldname />
					<cfelse>
						<cfset theVal.ClientFieldName = theVal.PropertyName />
					</cfif>
					<cfif structKeyExists(theRule,"params")>
						<cfloop array="#theRule.params#" index="theParam">
							<cfset structAppend(theVal.parameters,theParam) />
							<cfloop list="compareProperty,dependentProperty" index="propertyType">
								<cfif structKeyExists(theParam,propertyType & "Name")>
									<cfif structKeyExists(variables.propertyDescs,theParam[propertyType & "Name"])>
										<cfset theVal.parameters[propertyType & "Desc"] = variables.propertyDescs[theParam[propertyType & "Name"]] />
									<cfelse>
										<cfset theVal.parameters[propertyType & "Desc"] = determineLabel(theParam[propertyType & "Name"]) />
									</cfif>
								</cfif>
							</cfloop>
						</cfloop>
					</cfif>
					<cfif structKeyExists(theRule,"failureMessage")>
						<cfset theVal.failureMessage = theRule.failureMessage />
					</cfif>
					<cfif structKeyExists(theRule,"condition") AND structKeyExists(variables.conditions,theRule.condition)>
						<cfset theVal.condition = variables.conditions[theRule.condition] />
					<cfelse>
						<cfset theVal.condition = {} />
					</cfif>
					<cfif structKeyExists(theRule,"contexts") AND NOT listFindNoCase(theRule.contexts,"*")>
						<cfloop list="#theRule.contexts#" index="theContext">
							<cfif NOT structKeyExists(variables.validations.contexts,theContext)>
								<cfset variables.validations.contexts[theContext] = ArrayNew(1) />
							</cfif>
							<cfset arrayAppend(variables.validations.contexts[theContext],theVal) />
						</cfloop>
					<cfelse>
						<cfset arrayAppend(variables.validations.contexts["___Default"],theVal) />
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
		<!--- Add all default rules back into each context --->
		<cfloop collection="#variables.validations.contexts#" item="theContext">
			<cfif theContext NEQ "___Default">
				<cfloop array="#variables.validations.contexts.___Default#" index="theVal">
					<cfif StructKeyExists(variables.contexts,theContext)>
						<cfset theVal = duplicate(theVal) />
					</cfif>
					<cfset ArrayAppend(variables.validations.contexts[theContext],theVal) />
				</cfloop>
			</cfif>
		</cfloop>
	</cffunction>

</cfcomponent>
	

