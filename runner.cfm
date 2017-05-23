<cfscript>
	variables.directory=(structKeyExists(url,'directory'))?ReplaceNoCase(Trim(url.directory),application.testMapping,'','ONE'):'';
	if( Len(Trim(variables.directory)) && DirectoryExists(variables.directory) ){
		variables.qBundles=directoryList(
			variables.directory,
			true,
			'query'
		);
		WriteDump(var=qBundles,label='suites');
		testbox=new testbox.system.TestBox();
		testbox.runRemote(directory=variables.directory);
	} else {
		throw(
			type="Tests.Missing.Directory",
			message="The directory #variables.directory# can not be read or does not exist."
		);
	}
</cfscript>