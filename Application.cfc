component output="false" hint="I define the application settings and event handlers."
	{
	//Application Based Settings
		this.baseDirectory = getDirectoryFromPath( getCurrentTemplatePath() );
		this.customTagPaths = '';
		
		this.mappings["/CFExpose"] = (this.baseDirectory & "CFExpose/");
		
		this.customTagPaths = listAppend(this.customTagPaths, this.mappings["/CFExpose"]);
		
	}
