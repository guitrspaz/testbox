<cfscript>
	testbox = new testbox.system.TestBox();
	testbox.addDirectory(url.directory);
	testbox.runRemote();
</cfscript>