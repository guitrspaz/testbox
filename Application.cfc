/**
* Copyright Since 2005 Ortus Solutions, Corp
* www.ortussolutions.com
**************************************************************************************
*/
component{
	this.name = "TestBox ColdFusion Testing " & hash( getCurrentTemplatePath() );
	// any other application.cfc stuff goes below:
	this.sessionManagement = true;

	// any mappings go here, we create one that points to the root called test.
	this.mappings[ "/testbox" ]='/Library/WebServer/Frameworks/testbox';
	//this.mappings[ "/courseplus" ]='/Library/WebServer/CoursePlus/src/tests/';

	// any orm definitions go here.

	// request start
	public boolean function onRequestStart( String targetPage ){
		cachePut('testingCacheInit',Now(),CreateTimeSpan(0,0,5,0),CreateTimeSpan(0,0,5,0));
		return true;
	}
}