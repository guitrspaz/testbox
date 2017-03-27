/**
* @name: Assistant
* @hint: This contains udf functions for testbox interface
* @author: Chris Schroeder (schroeder@jhu.edu)
* @copyright: Johns Hopkins University
* @created: Monday, 03/27/2017 08:12:54 AM
* @modified: Monday, 03/27/2017 08:12:54 AM
*/

component
	displayname="Assistant"
	output="false"
	accessors="true"
{
	public component function init(){
		return this;
	}

	public String function buildBreadCrumbs(
		required Array urlParts,
		required Array mappingParts
	){
		var errorStruct={
			start:Now(),
			mappingParts:arguments.mappingParts,
			urlParts:arguments.urlParts,
			urlString:'',
			logType:'warning',
			encodedPath:'/',
			result:'',
			totals:{
				mapParts:ArrayLen(arguments.mappingParts),
				urlParts:ArrayLen(arguments.urlParts)
			}
		};
		try{
			errorStruct.result&='<ol class="breadcrumb pull-left">';
			if( errorStruct.totals.mapParts ){
				ArrayEach(arguments.mappingParts,function(mp,mpidx){
					var isUnreachable=(mpidx==errorStruct.totals.mapParts)?true:false;
					errorStruct.urlString=ListAppend(Trim(errorStruct.urlString),Trim(mp),'/');
					if( isUnreachable ){
						errorStruct.result&='<li class="unreachable">'&mp&'</li>';
					} else {
						errorStruct.result&='<li><a href="'&errorStruct.urlString&'">'&mp&'</a></li>';
					}
				});
			}
			if( errorStruct.totals.urlParts ){
				errorStruct.urlString&='?path=';
				ArrayEach(arguments.urlParts,function(up,upidx){
					var isActive=false;
					if( upidx==errorStruct.totals.urlParts ){
						isActive=true;
					}
					var itemURLPath=URLEncodedFormat(ListAppend(Trim(errorStruct.encodedPath),up,'/'));
					if( isActive ){
						errorStruct.result&='<li class="active">'&up&'</li>';
					} else {
						errorStruct.result&='<li><a href="'&errorStruct.urlString&itemURLPath&'">'&up&'</a></li>';
					}
				});
			}
			errorStruct.result&='</ol>';
			errorStruct.logType='information';
		} catch(Any e){
			errorStruct.cfcatch=e;
			errorStruct.logType='error';
		}
		if( errorStruct.logType!='information' ){
			WriteLog('assets.udf.Assistant.buildBreadCrumbs() > '&SerializeJSON(errorStruct),errorStruct.logType,'yes','TestBox');
		}
		return errorStruct.result;
	}
}