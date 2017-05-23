<cfscript>
	variables.directory=(structKeyExists(url,'directory'))?ArrayToList(ListToArray(url.directory,'/',false),'.'):'';
	if( Len(Trim(variables.directory)) && variables.rootMapping!='undefined' ){
		testbox=new testbox.system.TestBox();
		testbox.runRemote(directory=variables.testMapping);
	}
</cfscript>