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
<cfcomponent displayname="Result" output="false" hint="I am a transient result object.">

	<cffunction name="Init" access="Public" returntype="any" output="false" hint="I am the constructor">
		<cfargument name="Translator" type="any" required="yes" />
		<cfset variables.Translator = arguments.Translator />
		<cfset variables.instance = StructNew() />
		<cfset variables.instance.Failures = ArrayNew(1) />
		<cfset variables.instance.IsSuccess = true />
		<cfset variables.instance.SuccessMessage = "" />
		<cfreturn this />
		
	</cffunction>
	
	<cffunction name="onMissingMethod" access="public" output="false" returntype="any" hint="provides for generic getter/setter.">
	
		<cfargument name="MissingMethodName" type="string" required="true" />
		<cfargument name="MissingMethodArguments" type="struct" required="true" />
	
		<cfset var VarName = Right(arguments.MissingMethodName,Len(arguments.MissingMethodName)-3) />
		<cfif Left(arguments.MissingMethodName,3) eq "set" AND StructKeyExists(arguments.MissingMethodArguments,1)>
			<cfset variables.instance[VarName] = arguments.MissingMethodArguments[1] />
		<cfelseif Left(arguments.MissingMethodName,3) eq "get">
			<cfif StructKeyExists(variables.instance,VarName)>
				<cfreturn variables.instance[VarName] />
			<cfelse>
				<cfreturn "" />
			</cfif>
		</cfif>
	
	</cffunction>
	
	<cffunction name="addFailure" access="public" output="false" returntype="void" hint="adds a Failure to the collection of failures in the object.">
		<cfargument name="Failure" type="struct" required="yes" hint="a struct with keys describing the failure. It must contain a Message key" />
		<cfif structKeyExists(arguments.Failure,"Message")>
			<cfset ArrayAppend(variables.instance.Failures,arguments.Failure) />
		<cfelse>
			<cfthrow type="validatethis.util.Result.invalidFailureStruct"
					message="The struct passed into the addFailure() method must contain a 'Message' key." />
		</cfif>
	</cffunction>

	<cffunction name="getFailures" access="public" output="false" returntype="any" hint="returns all failures as an array of structs">
		<cfargument name="locale" type="Any" required="false" default="" hint="the locale to use to translate the failure messages" />
		
		<cfset var failure = 0 />
		
		<cfif Len(arguments.locale)>
			<cfloop array="#variables.instance.Failures#" index="failure">
				<!--- TODO: This is programming to an implementation, not an interface, but is being done for performance reasons :-( --->
				<cfset failure.Message = variables.Translator.translate(failure.Message,arguments.locale) />
			</cfloop>
		</cfif>
		<cfreturn variables.instance.Failures />
	</cffunction>

	<cffunction name="getFailureMessages" access="public" output="false" returntype="array" hint="I return all failure messages as an array of strings.">
		<cfargument name="locale" type="Any" required="false" default="" />
		<cfset var FailureList = [] />
		<cfset var Failure = 0 />
		<cfloop array="#getFailures(arguments.locale)#" index="Failure">
			<cfif Len(Failure.Message)>
				<cfset ArrayAppend(FailureList,Failure.Message) />
			</cfif>
		</cfloop>
		<cfreturn FailureList />
	</cffunction>

	<cffunction name="getFailuresAsString" access="public" output="false" returntype="any" hint="I return the errors as a string separated with a specified delimiter.">
		<!--- Based on code by Craig McDonald --->
		<cfargument name="delim" type="string" required="false" default="<br />" hint="The delimiter to use to separate messages" />
		<cfargument name="locale" type="Any" required="false" default="" />
	
		<cfset var failureList = "" />
		<cfset var failure = 0 />
		<cfset var failureCount = 0 />
		<cfloop array="#getFailures(arguments.locale)#" index="failure">
			<cfif Len(failure.Message)>
				<cfif failureCount GT 0>
					<cfset failureList &= arguments.delim />
				</cfif>
				<cfset failureList &= failure.Message />
				<cfset failureCount ++ />
			</cfif>
		</cfloop>
		<cfreturn failureList />
	</cffunction>
	
	<cffunction name="getFailuresByField" access="public" output="false" returntype="struct" hint="Returns a structure containing an array of failures for each clientFieldName.">
		<cfargument name="limit" type="Any" required="false" default="" hint="The maximum number of failures to return per field" />
		<cfargument name="locale" type="Any" required="false" default="" />
		<cfreturn getFailuresByFieldOrProperty("ClientFieldName",false,arguments.limit,arguments.locale) />
	</cffunction>

	<cffunction name="getFailureMessagesByField" access="public" output="false" returntype="struct" hint="Returns a structure containing a list of failure messages for each clientFieldName.">
		<cfargument name="limit" type="Any" required="false" default="" hint="The maximum number of messages to return per field" />
		<cfargument name="delimiter" type="string" required="false" default="" hint="A delimeter to use to separate messages per field. Blank creates an array instead of a string." />
		<cfargument name="locale" type="Any" required="false" default="" />
		<cfreturn getFailuresByFieldOrProperty("ClientFieldName",true,arguments.limit,arguments.delimiter,arguments.locale) />
	</cffunction>

	<cffunction name="getFailuresByProperty" access="public" output="false" returntype="struct" hint="Returns a structure containing an array of failures for each propertyName.">
		<cfargument name="limit" type="Any" required="false" default="" hint="The maximum number of failures to return per property" />
		<cfargument name="locale" type="Any" required="false" default="" />
		<cfreturn getFailuresByFieldOrProperty("PropertyName",false,arguments.limit,arguments.locale) />
	</cffunction>

	<cffunction name="getFailureMessagesByProperty" access="public" output="false" returntype="struct" hint="Returns a structure containing a list of failure messages for each propertyName.">
		<cfargument name="limit" type="Any" required="false" default="" hint="The maximum number of messages to return per property" />
		<cfargument name="delimiter" type="string" required="false" default="" hint="A delimeter to use to separate messages per property. Blank creates an array instead of a string." />
		<cfargument name="locale" type="Any" required="false" default="" />
		<cfreturn getFailuresByFieldOrProperty("PropertyName",true,arguments.limit,arguments.delimiter,arguments.locale) />
	</cffunction>

	<cffunction name="getFailuresByFieldOrProperty" access="private" output="false" returntype="struct" hint="Returns a structure containing an array of failures for each propertyName.">
		<cfargument name="keyType" type="Any" required="true" hint="Should be either ClientFieldName or PropertyName" />
		<cfargument name="messageOnly" type="boolean" required="true" hint="Should only the failure messages be returned, or the complete failure struct?" />
		<cfargument name="limit" type="Any" required="false" default="" hint="The maximum number of failures to return per field or property" />
		<cfargument name="delimiter" type="string" required="false" default="" hint="A delimeter to use to separate messages per property. Blank creates an array instead of a string." />
		<cfargument name="locale" type="Any" required="false" default="" />
		<cfset var failureList = StructNew() />
		<cfset var failure = 0 />
		<cfset var failureToAdd = 0 />
		<cfset var failureCount = {} />
		<cfset var keyName = 0 />
		<cfset var failures = getFailures(arguments.locale) />
		<cfloop from="1" to="#ArrayLen(Failures)#" index="Failure">
			<cfif StructKeyExists(failures[failure],arguments.keyType)>
				<cfset keyName = failures[failure][arguments.keyType] />
				<cfif NOT StructKeyExists(failureList,keyName)>
					<cfset failureCount[keyName] = 0 />
					<cfif len(arguments.delimiter) EQ 0>
						<cfset failureList[keyName] =  ArrayNew(1) />
					<cfelse>
						<cfset failureList[keyName] =  "" />
					</cfif>
				</cfif>
				<cfif val(arguments.limit) EQ 0 OR failureCount[keyName] LT val(arguments.limit)> 
					<cfif arguments.messageOnly>
						<cfset failureToAdd = failures[failure].Message />
					<cfelse>
						<cfset failureToAdd = failures[failure] />
					</cfif>
					<cfif len(arguments.delimiter) EQ 0>
						<cfset ArrayAppend(failureList[keyName], failureToAdd) />	
					<cfelse>
						<cfif failureCount[keyName] GT 0>
							<cfset failureList[keyName] &= arguments.delimiter />
						</cfif>
						<cfset failureList[keyName] &= failureToAdd />
					</cfif>
					<cfset failureCount[keyName] ++ />
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn FailureList />
	</cffunction>

	<cffunction name="getFailuresForUniForm" access="public" output="false" returntype="any" hint="Returns a structure of failures in a format the cfUniform likes">
		<cfargument name="locale" type="Any" required="false" default="" />
		<cfreturn getFailuresAsStruct(arguments.locale) />
	</cffunction>

	<!--- These methods implement the interface for ModelGlue.util.ValidationErrorCollection --->

	<cffunction name="GetErrors" returntype="struct" access="public" output="false" hint="I get the Error collection as expected from ModelGlue.util.ValidationErrorCollection.">
		<cfargument name="locale" type="Any" required="false" default="" />
		<cfreturn getFailuresAsValidationErrorCollection(arguments.locale) />
	</cffunction>
	
	<cffunction name="getFailuresAsValidationErrorCollection" access="public" output="false" returntype="any" hint="I return failures in a format expected from a ModelGlue.util.ValidationErrorCollection">
		<cfargument name="locale" type="Any" required="false" default="" />
		<cfset var FailureList = StructNew() />
		<cfset var Failure = 0 />
		<cfset var Failures = getFailures(arguments.locale) />
		<cfloop from="1" to="#ArrayLen(Failures)#" index="Failure">
			<cfif NOT StructKeyExists(FailureList,Failures[Failure].ClientFieldName)>
				<cfset FailureList[Failures[Failure].ClientFieldName] =  ArrayNew(1) />
			</cfif>
			<cfset ArrayAppend(FailureList[Failures[Failure].ClientFieldName], Failures[Failure].Message) />	
		</cfloop>
		<cfreturn FailureList />
	</cffunction>

	<cffunction name="HasErrors" returntype="boolean" access="public" output="false" hint="I implement part of the ModelGlue.util.ValidationErrorCollection interface.">
		<cfargument name="PropertyName" type="string" required="false" default="" hint="You can check for errors on a specific property by passing me.">

		<cfset var Errors = GetErrors() />		
		<cfif len(arguments.propertyName)>
			<cfif StructKeyExists(Errors, arguments.propertyName) AND arrayLen(Errors[arguments.propertyName]) gt 0>
				<cfreturn true />
			<cfelse>
				<cfreturn false />
			</cfif>
		<cfelse>
			<cfif structCount(Errors) gt 0>
				<cfreturn true />
			<cfelse>
				<cfreturn false />
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="Merge" returntype="void" access="public" output="false" hint="I merge a ModelGlue.util.ValidationErrorCollection's errors into this result.">
		<cfargument name="ValidationErrorCollection" type="any" required="true" hint="I am the Result to merge.">
		
		<cfset var otherErrors = arguments.ValidationErrorCollection.getErrors() />
		<cfset var errProperty = 0 />
		<cfset var err = 0 />
		<cfset var newFailure = 0 />
		
		<cfloop collection="#otherErrors#" item="errProperty">
			<cfloop array="#otherErrors[errProperty]#" index="err">
				<cfset newFailure = StructNew() />
				<cfset newFailure.PropertyName = errProperty />
				<cfset newFailure.ClientFieldName = errProperty />
				<cfset newFailure.Type = "ModelGlue.util.ValidationErrorCollection" />
				<cfset newFailure.Message = err />
				<cfset addFailure(newFailure) />
			</cfloop>
		</cfloop>

	</cffunction>

	<!--- An example of a custom method that returns failures in a format expected by an existing application --->
	<cffunction name="getFailuresForCAYA" access="public" output="false" returntype="any">
		<cfargument name="locale" type="Any" required="false" default="" />
		<cfset var FailureList = [] />
		<cfset var Failure = 0 />
		<cfloop array="#getFailures(arguments.locale)#" index="Failure">
			<cfif Len(Failure.Message)>
				<cfset ArrayAppend(FailureList,Failure.Message) />
			</cfif>
		</cfloop>
		<cfreturn FailureList />
	</cffunction>

	<cffunction name="getFailuresAsStruct" access="public" output="false" returntype="any" hint="Deprecated. Use getFailuresByProperty() or getFailuresByField().">
		<cfargument name="locale" type="Any" required="false" default="" />
		<cfset var FailureList = StructNew() />
		<cfset var Failure = 0 />
		<cfset var Failures = getFailures(arguments.locale) />
		<cfloop from="1" to="#ArrayLen(Failures)#" index="Failure">
			<cfif StructKeyExists(Failures[Failure],"ClientFieldName")>
				<cfif StructKeyExists(FailureList,Failures[Failure].ClientFieldName)>
					<cfset FailureList[Failures[Failure].ClientFieldName] =  FailureList[Failures[Failure].ClientFieldName] & "<br />" & Failures[Failure].Message />	
				<cfelse>			
					<cfset FailureList[Failures[Failure].ClientFieldName] =  Failures[Failure].Message />	
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn FailureList />
	</cffunction>

	<!--- getters and setters --->
	<cffunction name="getIsSuccess" access="public" output="false" returntype="boolean">
		<cfreturn variables.instance.IsSuccess />
	</cffunction>
	<cffunction name="setIsSuccess" access="public" output="false" returntype="void">
		<cfargument name="IsSuccess" type="boolean" required="yes" />
		<cfset variables.instance.IsSuccess = arguments.IsSuccess />
	</cffunction>

	<cffunction name="getTheObject" access="public" output="false" returntype="any">
		<cfreturn variables.instance.theObject />
	</cffunction>
	<cffunction name="setTheObject" access="public" output="false" returntype="void">
		<cfargument name="theObject" type="any" required="yes" />
		<cfset variables.instance.theObject = arguments.theObject />
	</cffunction>

	<cffunction name="getSuccessMessage" access="public" output="false" returntype="any">
		<cfreturn variables.instance.SuccessMessage />
	</cffunction>
	<cffunction name="setSuccessMessage" access="public" output="false" returntype="void">
		<cfargument name="SuccessMessage" type="any" required="yes" />
		<cfset variables.instance.SuccessMessage = arguments.SuccessMessage />
	</cffunction>

	<cffunction name="getMemento" access="public" output="false" returntype="any">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>
	

