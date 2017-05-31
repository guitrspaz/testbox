<cfscript>
	variables.directory=(structKeyExists(url,'directory'))?url.directory:'';
	/*
	WriteDump(var=ExpandPath('/assets/cfm/templates/'))
	WriteDump(var=DirectoryList(ExpandPath('/assets/cfm/templates/'),true,'query','*.cfm'));
	*/
	if( Len(Trim(variables.directory)) && DirectoryExists(ExpandPath(variables.directory)) ){
		testbox=new testbox.system.TestBox( reporter=new assets.reporters.HTMLReporter(assetRoot='/assets') );
		testbox.runRemote(directory=variables.directory,reporter='assets.reporters.HTMLReporter');
	} else {
		throw(
			type="Tests.Missing.Directory",
			message="The directory #variables.directory# can not be read or does not exist."
		);
	}
</cfscript>