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
<cfcomponent output="false" extends="BaseFileReader" hint="I am a responsible for reading and processing an XML file.">

	<cffunction name="loadRules" returnType="void" access="public" output="false" hint="I read the validations XML file and reformat it into a struct">
		<cfargument name="metadataSource" type="any" required="true" hint="the path to the file to read" />

		<cfset var theXML = XMLParse(arguments.metadataSource) />
		<cfset var theProperties = convertXmlCollectionToArrayOfStructs(XMLSearch(theXML,"//property")) />

		<cfset processConditions(convertXmlCollectionToArrayOfStructs(XMLSearch(theXML,"//condition"))) />
		<cfset processContexts(convertXmlCollectionToArrayOfStructs(XMLSearch(theXML,"//context"))) />
		<cfset processPropertyDescs(theProperties) />
		<cfset processPropertyRules(theProperties) />

		<!---
		<cfloop array="#xmlProperties#" index="theProperty">
			<cfset theName = theProperty.XmlAttributes.name />
			<cfif StructKeyExists(theProperty.XmlAttributes,"desc")>
				<cfset theDesc = theProperty.XmlAttributes.desc />
			<cfelse>
				<cfset theDesc = determineLabel(theName) />
			</cfif>
			<cfif theDesc NEQ theName>
				<cfset ReturnStruct.PropertyDescs[theName] = theDesc />
				<cfif StructKeyExists(theProperty.XmlAttributes,"clientfieldname")>
					<cfset ReturnStruct.ClientFieldDescs[theProperty.XmlAttributes.clientfieldname] = theDesc />
				<cfelse>
					<cfset ReturnStruct.ClientFieldDescs[theName] = theDesc />
				</cfif>
			</cfif>
		</cfloop>
		<cfloop array="#xmlProperties#" index="theProperty">
			<cfset theRules = XMLSearch(theProperty,"rule") />
			<cfloop array="#theRules#" index="theRule">
				<cfset theVal = {} />
				<cfset theVal.PropertyName = theProperty.XmlAttributes.name />
				<cfif StructKeyExists(theProperty.XmlAttributes,"desc")>
					<cfset theVal.PropertyDesc = theProperty.XmlAttributes.desc />
				<cfelse>
					<cfset theVal.PropertyDesc = determineLabel(theVal.PropertyName) />
				</cfif>
				<cfif StructKeyExists(theProperty.XmlAttributes,"clientfieldname")>
					<cfset theVal.ClientFieldName = theProperty.XmlAttributes.clientfieldname />
				<cfelse>
					<cfset theVal.ClientFieldName = theVal.PropertyName />
				</cfif>
				<cfset theVal.ValType = theRule.XmlAttributes.type />
				<cfset theVal.Parameters = StructNew() />
				<cfset theParams = XMLSearch(theRule,"param") />
				<cfloop array="#theParams#" index="theParam">
					<cfset StructAppend(theVal.Parameters,theParam.XmlAttributes) />
					<cfloop list="CompareProperty,DependentProperty" index="PropertyType">
						<cfif StructKeyExists(theParam.XmlAttributes,PropertyType & "Name")>
							<cfif StructKeyExists(ReturnStruct.PropertyDescs,theParam.XmlAttributes[PropertyType & "Name"])>
								<cfset theVal.Parameters[PropertyType & "Desc"] = ReturnStruct.PropertyDescs[theParam.XmlAttributes[PropertyType & "Name"]] />
							<cfelse>
								<cfset theVal.Parameters[PropertyType & "Desc"] = determineLabel(theParam.XmlAttributes[PropertyType & "Name"]) />
							</cfif>
						</cfif>
					</cfloop>
				</cfloop>
				<cfif StructKeyExists(theRule.XmlAttributes,"failureMessage")>
					<cfset theVal.FailureMessage = theRule.XmlAttributes.failureMessage />
				</cfif>
				<cfif StructKeyExists(theRule.XmlAttributes,"condition") AND StructKeyExists(theConditions,theRule.XmlAttributes.condition)>
					<cfset theVal.Condition = theConditions[theRule.XmlAttributes.condition] />
				<cfelse>
					<cfset theVal.Condition = {} />
				</cfif>
				<cfif StructKeyExists(theRule.XmlAttributes,"contexts") AND NOT ListFindNoCase(theRule.XmlAttributes.contexts,"*")>
					<cfloop list="#theRule.XmlAttributes.contexts#" index="theContext">
						<cfif NOT StructKeyExists(ReturnStruct.Validations.Contexts,theContext)>
							<cfset ReturnStruct.Validations.Contexts[theContext] = ArrayNew(1) />
						</cfif>
						<cfset ArrayAppend(ReturnStruct.Validations.Contexts[theContext],theVal) />
					</cfloop>
				<cfelse>
					<cfset ArrayAppend(ReturnStruct.Validations.Contexts["___Default"],theVal) />
				</cfif>
			</cfloop>
		</cfloop>
		<!--- Add all default rules back into each context --->
		<cfloop collection="#ReturnStruct.Validations.Contexts#" item="theContext">
			<cfif theContext NEQ "___Default">
				<cfloop array="#ReturnStruct.Validations.Contexts.___Default#" index="theVal">
					<cfif StructKeyExists(theContexts,theContext)>
						<cfset theVal = duplicate(theVal) />
					</cfif>
					<cfset ArrayAppend(ReturnStruct.Validations.Contexts[theContext],theVal) />
				</cfloop>
			</cfif>
		</cfloop>
		
		<cfreturn ReturnStruct />
		--->
	</cffunction>

	<cffunction name="convertXmlCollectionToArrayOfStructs" returnType="any" access="private" output="false" hint="I take data from an XML document and convert it into a standard array of structs">
		<cfargument name="xmlCollection" type="any" required="true" />
		<cfset var newArray = [] />
		<cfset var newStruct = 0 />
		<cfset var element = 0 />
		<cfloop array="#arguments.xmlCollection#" index="element">
			<cfset newStruct = {} />
			<cfset structAppend(newStruct,element.XmlAttributes) />
			<cfif structKeyExists(element,"XMLChildren") and isArray(element.XMLChildren) and arraylen(element.XMLChildren) gt 0>
				<cfset newStruct[element.XMLChildren[1].XmlName & "s"] = convertXmlCollectionToArrayOfStructs(element.XMLChildren) />
			</cfif>
			<cfset arrayAppend(newArray,newStruct) />
		</cfloop>
		<cfreturn newArray />
	</cffunction>

</cfcomponent>
	

