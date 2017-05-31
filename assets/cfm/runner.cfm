<cfscript>
	variables.directory=(structKeyExists(url,'directory'))?url.directory:'';
	url.directory=variables.directory;
	if( Len(Trim(variables.directory)) && DirectoryExists(ExpandPath(variables.directory)) ){
		application.testbox.runRemote(directory=variables.directory,reporter='assets.reporters.HTMLReporter');
	} else {
		throw(
			type="Tests.Missing.Directory",
			message="The directory #variables.directory# can not be read or does not exist."
		);
	}
</cfscript>