<cfscript>
	variables.directory=(structKeyExists(url,'directory'))?ArrayToList(ListToArray(url.directory,'/',false),'.'):'';
	variables.rootMapping=( structKeyExists(application,'testRoot') && Len(Trim(application.testRoot)) )?Trim(application.testRoot):'undefined';
	if( Len(Trim(variables.directory)) && variables.rootMapping!='undefined' ){
		variables.testMapping=ArrayToList(ListToArray(variables.rootMapping,'/',false),'.')&'.'&variables.directory;
		testbox=new testbox.system.TestBox();
		testbox.runRemote(directory=variables.directory);
	}
</cfscript>