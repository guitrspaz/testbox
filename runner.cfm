<cfscript>
	variables.directory=(structKeyExists(url,'directory'))?ArrayToList(ListToArray(url.directory,'/',false),'.'):'';
	if( Len(Trim(variables.directory)) && DirectoryExists(variables.directory) ){
		variables.qBundles=directoryList(
			variables.directory,
			true,
			'query'
		);
		WriteDump(var=qBundles,label='suites');
		testbox=new testbox.system.TestBox();
		testbox.runRemote(directory=variables.directory);
	}
</cfscript>