<cfscript>
	variables.directory=(structKeyExists(url,'directory'))?ArrayToList(ListToArray(url.directory,'/',false),'.'):'';
	if( Len(Trim(variables.directory)) ){
		testbox=new testbox.system.TestBox();
		testbox.runRemote(directory=variables.directory);
	}
</cfscript>