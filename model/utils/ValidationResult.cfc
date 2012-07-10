/* 
Based on ValidateThis Validation Result object, but really lightweight
so that cfTracker is lightweight	
*/
component {
	/* -------------------------- CONSTRUCTOR -------------------------- */
	any function init(){
		variables.errors = [];
		return this;
	}
		
	/* -------------------------- PUBLIC -------------------------- */
	boolean function hasErrors(){
		return ArrayLen( variables.errors ) > 0;
	}

	array function getErrors(){
		return variables.errors;
	}

	void function addError( message ){
		ArrayAppend( variables.errors, arguments.message );
	}
}