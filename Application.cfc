/**
* @name: Application
* @hint: I am the testbox server application controller
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Tuesday, 06/27/2017 08:18:42 AM
* @modified: Tuesday, 06/27/2017 08:18:49 AM
*/
component{
	this.name = "TestBox ColdFusion Testing " & hash( getCurrentTemplatePath() );
	// any other application.cfc stuff goes below:
	this.sessionManagement = true;

	// request start
	public Boolean function onRequestStart( String targetPage ){
		//init at least one cache region
		cachePut('testingCacheInit',Now(),CreateTimeSpan(0,0,5,0),CreateTimeSpan(0,0,5,0));

		//constants
		application['assistant']=new src.tests.browser.assets.udf.assistant();
		application['reporterName']='HTMLReporter';
		application['reportersDirectory']='src.tests.resources.reporters';
		application['parentDir']=ExpandPath('../');
		application['serverPath']=ReplaceNoCase(cgi.PATH_TRANSLATED,cgi.SCRIPT_NAME,'','ONE');
		application['templatePath']=getCurrentTemplatePath();
		application['fullPath']=getDirectoryFromPath(getCurrentTemplatePath());
		application['base']=(FindNoCase(application.serverPath,application.fullPath))?ReplaceNoCase(application.fullPath,application.serverPath,'','ONE'):'/';
		application['useFull']=(FindNoCase(application.serverPath,application.fullPath))?true:false;
		application['testboxRoot']=application.base;

		try{
			application['testbox']=new testbox.system.TestBox();
		} catch( Any e ){
			throw(
				type='Configuration.TestBox.Missing',
				message='TestBox is not installed on this server and is required to run this browser.',
				detail='Please first install TestBox ( https://testbox.ortusbooks.com/content/installing_testbox/ ) and then try again.'
			);
		}

		try{
			application['mockbox']=new testbox.system.MockBox();
		} catch( Any e ){
			throw(
				type='Configuration.MockBox.Missing',
				message='MockBox is not installed on this server and is required to run this browser.',
				detail='Please first install TestBox ( https://testbox.ortusbooks.com/content/mockbox/installing_mockbox.html ) and then try again.'
			);
		}

		//reads configuration into application
		var config=application.assistant.configureBrowser(GetDirectoryFromPath( GetCurrentTemplatePath() ));//path to server
		application['configuration']=config;
		StructEach(config,function(key,value){
			application[key]=value;
		});
		var parts=ArrayToList(ArrayFilter(ListToArray(application.testRoot,'/'),function(pathPart){
			return (ArrayFindNoCase(ListToArray(application.base,'/'),pathPart));
		}),'/');
		application['testParent']='/'&parts;
		application['reporter']=( Find('.',application.reporterName) )?application.reporterName:application.reportersDirectory&'.'&application.reporterName;
		return true;
	}
}