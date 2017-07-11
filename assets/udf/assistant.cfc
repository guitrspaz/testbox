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
			urlString:'/',
			logType:'warning',
			encodedPath:'/',
			result:'',
			indexes:{
				map:[],
				url:[]
			},
			totals:{
				mapParts:ArrayLen(arguments.mappingParts),
				urlParts:ArrayLen(arguments.urlParts)
			}
		};
		try{
			errorStruct.result&='<ol class="breadcrumb pull-left">';
			errorStruct.result&='<li class="unreachable"><strong>Contents:</strong></li>';
			if( errorStruct.totals.mapParts ){
				var idx=[];
				var totalMappings=errorStruct.totals.mapParts;
				ArrayEach(arguments.mappingParts,function(mp,mpidx){
					ArrayAppend(idx,mpidx);
					var isReachable=false;
					if( mpidx==totalMappings ){
						isReachable=true;
					}
					if( isReachable ){
						errorStruct.result&='<li><a href="index.cfm">'&mp&'</a></li>';
					} else {
						errorStruct.result&='<li class="unreachable">'&mp&'</li>';
					}
				});
				errorStruct.indexes['map']=idx;
			}
			if( errorStruct.totals.urlParts ){
				errorStruct.urlString&='?path=';
				var pidx=[];
				var totalURLParts=errorStruct.totals.urlParts;
				ArrayEach(arguments.urlParts,function(up,upidx){
					ArrayAppend(pidx,upidx);
					var isActive=false;
					if( upidx==totalURLParts ){
						isActive=true;
					}
					errorStruct.encodedPath=ReplaceNoCase(ListAppend(Trim(errorStruct.encodedPath),up,'/'),'//','/','ALL');
					var itemURLPath=URLEncodedFormat(errorStruct.encodedPath);
					if( isActive ){
						errorStruct.result&='<li class="active">'&up&'</li>';
					} else {
						errorStruct.result&='<li><a href="'&errorStruct.urlString&itemURLPath&'">'&up&'</a></li>';
					}
				});
				errorStruct.indexes['url']=pidx;
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

	public Struct function configureBrowser(string path='/'){
		var fileName='unit-test-config.json';
		var configDirectory=( DirectoryExists(arguments.path) )?arguments.path:ExpandPath(arguments.path);
		var result={};
		try{
			if( ReFindNoCase('\/$|\\$',configDirectory) ){
				configDirectory=Left(configDirectory,Len(configDirectory)-1);
			}
			var fileData=fileRead(configDirectory&'/'&fileName,'utf-8');
			if(isJSON(Trim(fileData))){
				result=DeserializeJSON(Trim(fileData));
			}
		} catch( Any e ){}
		return result;
	}
}
