component {

	/* -------------------------- DEPENDANCIES -------------------------- */
	
	/* -------------------------- CONSTRUCTOR -------------------------- */
	any function init(){
		return this;
	}
		
	/* -------------------------- PUBLIC -------------------------- */
	any function newResult(){
		return new ValidationResult();
	}

}