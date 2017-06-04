<cfscript>
	variables.directory=(structKeyExists(url,'directory'))?url.directory:'';
	url.directory=variables.directory;
	if( Len(Trim(variables.directory)) && DirectoryExists(ExpandPath(variables.directory)) ){
		variables.runParams={};
		variables.runParams['directory']=variables.directory;
		variables.runParams['reporter']='assets.reporters.HTMLReporter';
		if( structKeyExists(url,'bundles') && Len(Trim(url.bundles)) ){
			variables.runParams['testBundles']=Trim(url.bundles);
		}
		//#application['base']#assets/cfm/runner.cfm?directory=#variables.attrs['directoryRunnerPath']#
		application.testbox.runRemote(argumentCollection=variables.runParams);
	} else {
		throw(
			type="Tests.Missing.Directory",
			message="The directory #variables.directory# can not be read or does not exist."
		);
	}
</cfscript>