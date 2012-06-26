<!---
	
	Copyright 2009, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" name="ValidateThis" hint="I accept a BO and use the framework to validate it.">

	<cffunction name="init" returnType="any" access="public" output="false" hint="I build a new ValidateThis">
		<cfargument name="ValidateThisConfig" type="any" required="false" default="#StructNew()#" />

		<cfset variables.ValidateThisConfig = arguments.ValidateThisConfig />
		<!--- Set default values for keys in ValidateThisConfig --->
		<cfparam name="variables.ValidateThisConfig.TranslatorPath" default="ValidateThis.core.BaseTranslator" />
		<cfparam name="variables.ValidateThisConfig.LocaleLoaderPath" default="ValidateThis.core.BaseLocaleLoader" />
		<cfparam name="variables.ValidateThisConfig.BOValidatorPath" default="ValidateThis.core.BOValidator" />
		<cfparam name="variables.ValidateThisConfig.ResultPath" default="ValidateThis.util.Result" />
		<cfparam name="variables.ValidateThisConfig.DefaultJSLib" default="jQuery" />
		<cfparam name="variables.ValidateThisConfig.JSRoot" default="js/" />
		<cfparam name="variables.ValidateThisConfig.defaultFormName" default="frmMain" />
		<cfparam name="variables.ValidateThisConfig.definitionPath" default="/model/" />
		<cfparam name="variables.ValidateThisConfig.localeMap" default="#StructNew()#" />
		<cfparam name="variables.ValidateThisConfig.defaultLocale" default="en_US" />
		<cfparam name="variables.ValidateThisConfig.abstractGetterMethod" default="getValue" />
		<cfparam name="variables.ValidateThisConfig.ExtraRuleValidatorComponentPaths" default="" />
		<cfparam name="variables.ValidateThisConfig.ExtraClientScriptWriterComponentPaths" default="" />
		<cfparam name="variables.ValidateThisConfig.extraFileReaderComponentPaths" default="" />
		<cfparam name="variables.ValidateThisConfig.externalFileTypes" default="xml,json" />
		<cfparam name="variables.ValidateThisConfig.injectResultIntoBO" default="false" />
		<cfparam name="variables.ValidateThisConfig.JSIncludes" default="true" />
		<cfparam name="variables.ValidateThisConfig.defaultFailureMessagePrefix" default="The " />
		<cfparam name="variables.ValidateThisConfig.BOComponentPaths" default="" />
		<cfparam name="variables.ValidateThisConfig.annotationAttributeName" default="vtRules" />
		<cfparam name="variables.ValidateThisConfig.extraAnnotationTypeReaderComponentPaths" default="" />
		
		<cfset variables.ValidationFactory = CreateObject("component","core.ValidationFactory").init(variables.ValidateThisConfig) />
		<cfset variables.CommonScriptGenerator = getBean("CommonScriptGenerator") />
		<cfset variables.TransientFactory = getBean("TransientFactory") />
		
		<cfset variables.ValidationFactory.createBOVsFromCFCs() />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="getValidator" access="public" output="false" returntype="any">
		<cfargument name="objectType" type="any" required="false" default="" />
		<cfargument name="definitionPath" type="any" required="false" default="" />
		<cfargument name="theObject" type="any" required="false" default="" />

		<cfset var theObjectType = determineObjectType(argumentCollection=arguments) />
		<cfif len(arguments.definitionPath) EQ 0 AND isObject(arguments.theObject)>
			<cfset arguments.definitionPath = getDirectoryFromPath(getMetadata(arguments.theObject).path) />
		</cfif>
		<cfreturn variables.ValidationFactory.getValidator(theObjectType,arguments.definitionPath,arguments.theObject) />
		
	</cffunction>
	
	<cffunction name="validate" access="public" output="false" returntype="any">
		<cfargument name="theObject" type="any" required="true" />
		<cfargument name="objectType" type="any" required="false" default="" />
		<cfargument name="Context" type="any" required="false" default="" />
		<cfargument name="Result" type="any" required="false" default="" />

		<cfset var BOValidator = getValidator(argumentCollection=arguments) />
		<!--- Inject testCondition if needed --->
		<!--- Notes for Java/Groovy objects:
			If you're using Groovy, 
			you will need to write your own testCondition method into your BOs. You may consider doing this 
			by adding the method to a base BO class. I am not certain this can even be done in Java, as I do 
			not believe Java supports runtime evaluation. --->
		<cfif not isObject(arguments.theObject) and isStruct(arguments.theObject)>
			<cfset arguments.theObject = variables.TransientFactory.newStructWrapper(arguments.theObject) />
		</cfif>
		<cfif getBean("ObjectChecker").isCFC(arguments.theObject) AND NOT StructKeyExists(arguments.theObject,"testCondition")>
			<cfset arguments.theObject["testCondition"] = this["testCondition"] />
		</cfif>
		<cfset arguments.Result = BOValidator.validate(arguments.theObject,arguments.Context,arguments.Result) />
		
		<cfreturn arguments.Result />

	</cffunction>
	
	<cffunction name="getInitializationScript" returntype="any" access="public" output="false" hint="I generate JS statements required to setup client-side validations for VT.">
		<cfargument name="JSLib" type="any" required="false" default="#variables.ValidateThisConfig.defaultJSLib#" />
		<cfargument name="JSIncludes" type="Any" required="no" default="#variables.ValidateThisConfig.JSIncludes#" />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfreturn variables.CommonScriptGenerator.getInitializationScript(argumentCollection=arguments) />

	</cffunction>

	<cffunction name="onMissingMethod" access="public" output="false" returntype="Any" hint="This is used to help communicate with the BOValidator, which is accessed via the ValidationFactory when needed">
		<cfargument name="missingMethodName" type="any" required="true" />
		<cfargument name="missingMethodArguments" type="any" required="true" />

		<cfset var returnValue = "" />
		<cfset var BOValidator = getValidator(argumentCollection=arguments.missingMethodArguments) />
		<cfinvoke component="#BOValidator#" method="#arguments.missingMethodName#" argumentcollection="#arguments.missingMethodArguments#" returnvariable="returnValue" />
		<cfif NOT IsDefined("returnValue")>
			<cfset returnValue = "" />
		</cfif>
		
		<cfreturn returnValue />
		
	</cffunction>

	<cffunction name="determineObjectType" returntype="any" access="public" output="false" hint="I try to determine the object type by looking at objectType and theObject arguments.">

		<cfset var theObjectType = "" />
		<cfif StructKeyExists(arguments,"objectType") AND Len(arguments.objectType)>
			<cfreturn arguments.objectType />
		<cfelseif StructKeyExists(arguments,"theObject")>
			<cfif IsObject(arguments.theObject)>
				<cfif StructKeyExists(arguments.theObject,"getobjectType")>
					<cfinvoke component="#arguments.theObject#" method="getobjectType" returnvariable="theObjectType" />
				<cfelse>
					<cfset theObjectType = ListLast(getMetaData(arguments.theObject).Name,".") />
				</cfif>
			<cfelseif isStruct(arguments.theObject) and structKeyExists(arguments.theObject,"objectType")>
				<cfset theObjectType = arguments.theObject.objectType />
			</cfif>
		</cfif>
		<cfif NOT IsDefined("theObjectType") OR NOT Len(theObjectType)>
			<cfthrow type="ValidateThis.ValidateThis.ObjectTypeRequired" detail="You must pass either an object type name (via objectType) or an actual object when calling a method on the ValidateThis facade object." />
		</cfif>
		<cfreturn theObjectType />
	</cffunction>

	<cffunction name="newResult" returntype="any" access="public" output="false" hint="I create a Result object.">

		<cfreturn variables.ValidationFactory.newResult() />
		
	</cffunction>

	<cffunction name="testCondition" access="Public" returntype="boolean" output="false" hint="I dynamically evaluate a condition and return true or false.">
		<cfargument name="Condition" type="any" required="true" />
		
		<cfreturn Evaluate(arguments.Condition)>

	</cffunction>

	<cffunction name="getBean" access="public" output="false" returntype="any" hint="I am used to allow the facade to ask the factory for beans">
		<cfargument name="BeanName" type="Any" required="false" />
		
		<cfreturn variables.ValidationFactory.getBean(arguments.BeanName) />
	
	</cffunction>
	
	<cffunction name="getVersion" access="public" output="false" returntype="any">

		<cfreturn getBean("Version").getVersion() />
		
	</cffunction>
	
</cfcomponent>
	

