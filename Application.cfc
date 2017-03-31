/**
* Copyright Since 2005 Ortus Solutions, Corp
* www.ortussolutions.com
**************************************************************************************
*/
component{
	this.name = "TestBox ColdFusion Testing " & hash( getCurrentTemplatePath() );
	// any other application.cfc stuff goes below:
	this.sessionManagement = true;

	// request start
	public Boolean function onRequestStart( String targetPage ){
		cachePut('testingCacheInit',Now(),CreateTimeSpan(0,0,5,0),CreateTimeSpan(0,0,5,0));
		var assistant=new assets.udf.assistant();
		var config=assistant.configureBrowser();
		StructEach(config,function(key,value){
			application[key]=value;
		});
		return true;
	}
}