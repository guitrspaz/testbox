<cfsetting showdebugoutput="false" >
<cfparam name="url.path" default="" type="string" />
<cfparam name="url.cpu" default="false" type="boolean" />
<cfparam name="url.action" default="" type="string" />
<cftry>
	<cfscript>
		variables.assistant=new assets.udf.Assistant();
		variables.attrs={};
		variables.attrs['urlPath']=(isValid('string',url.path) && Len(Trim(url.path)))?URLDecode(Trim(url.path)):'';
		variables.attrs['displayType']='dir';
		variables.attrs['rootMapping']='/src/tests';
		variables.attrs['mappingParts']=[];
		variables.attrs['path']=[];
		variables.attrs['allParts']=[];
		variables.attrs['testRoot']=variables.attrs['rootMapping'];
		variables.attrs['testbox']=new testbox.system.TestBox();
		variables.attrs['action']=(Len(Trim(url.action)))?URLDecode(Trim(url.action)):'list';
		variables.attrs['cpu']=( isValid('boolean',url.cpu) )?url.cpu:false;
		variables.attrs['directoryContents']=QueryNew('name,directory,size,type,dateLastModified,attributes,mode','varchar,varchar,varchar,varchar,varchar,varchar,varchar');
		variables.attrs['directoryCounter']=0;
		variables.attrs['linkPath']='';
		variables.attrs['breadcrumbNav']='';
		variables.attrs['totals']={};
		variables.attrs['totals']['mapParts']=0;
		variables.attrs['totals']['urlParts']=0;

		if( !directoryExists(variables.attrs.testRoot) ){
			variables.attrs['mappingParts']=ArrayFilter(ListToArray(variables.attrs.testRoot,'/'),function(pathItem){
				return ( Len(Trim(pathItem)) );
			});
			variables.attrs['totals']['mapParts']=ArrayLen(variables.attrs['mappingParts']);
			variables.attrs['testRoot']=ExpandPath(variables.attrs.rootMapping);
		}

		if( Len(Trim(variables.attrs['urlPath'])) ){
			variables.attrs['displayType']='all';
			variables.attrs['path']=ArrayFilter(ListToArray(variables.attrs.urlPath,'/'),function(pathItem){
				return (Len(Trim(pathItem)));
			});
			variables.attrs['totals']['urlParts']=ArrayLen(variables.attrs['path']);
		}

		variables.attrs['testRoot']=ListAppend(variables.attrs['testRoot'],ArrayToList(variables.attrs['path'],'/'),'/');
		if(directoryExists(variables.attrs.testRoot)){
			variables.attrs['directoryCounter']=ArrayLen(createObject("java","java.io.File").init(Trim(variables.attrs.testRoot)).list());
			variables.attrs['directoryContents']=directoryList(
				variables.attrs['testRoot'],
				false,
				'query'
			);
		} else {
			throw(
				detail="The defined test root does not exist.",
				message='No root found',
				type='NoDefinedRoot'
			);
		}

		if( ArrayLen(variables.attrs.path) || ArrayLen(variables.attrs.mappingParts) ){
			variables.attrs['breadcrumbNav']=variables.assistant.buildBreadCrumbs(
				urlParts=variables.attrs['path'],
				mappingParts=variables.attrs['mappingParts']
			);
		}

		switch(variables.attrs['action']){
			case 'runTestBox':
				variables.attrs['testbox'].init(
					directory=variables.attrs['testRoot']
				).run();
			break;
		}
		WriteDump(var=variables.attrs);
	</cfscript>

	<cfoutput>
	<!--- Do HTML --->
		<!DOCTYPE html>
		<html>
			<head>
				<meta charset="utf-8">
				<meta name="generator" content="TestBox v#variables.attrs['testbox'].getVersion()#">
				<title>TestBox Test Runner</title>
				<link rel="stylesheet" href="/node_modules/bootstrap/dist/css/bootstrap.min.css" />
				<link rel="stylesheet" href="/assets/css/testbox.css" />
				<!---
				<script type="text/javascript" src="/node_modules/requirejs/require.js"></script>
				<script type="text/javascript" src="/node_modules/normalize/lib/normalize.js"></script>
				--->
				<script type="text/javascript" src="/node_modules/jquery/dist/jquery.min.js"></script>
				<script type="text/javascript" src="/node_modules/bootstrap/dist/js/bootstrap.min.js"></script>
				<script type="text/javascript" src="/assets/js/testbox.js"></script>
			</head>
			<body class="container-fluid">
				<div id="page" class="site">
					<header id="masthead" role="navigation">
						<nav class="navbar navbar-default navbar-static-top" id="site-branding">
							<div class="container-fluid">
								<a href="/" class="navbar-brand"><img src="//www.ortussolutions.com/__media/testbox-185.png" alt="TestBox" id="tb-logo" /></a>
								<ul class="nav navbar-nav">
									<li><p class="navbar-text">v#variables.attrs['testbox'].getVersion()#</p></li>
									<li><a href="index.cfm?action=runTestBox&path=#URLEncodedFormat( url.path )#" target="_blank">Run All</a></li>
								</ul>
							</div>
						</nav>
					</header>
					<div class="site-content-contain">
						<div id="content" class="site-content">
							<div id="primary" class="content-area">
								<h1>TestBox Test Browser: </h1>
								<p>
									Below is a listing of the files and folders starting from your root <code>#variables.attrs['testRoot']#</code>.  You can click on individual tests in order to execute them
									or click on the <strong>Run All</strong> button on your left and it will execute a directory runner from the visible folder.
								</p>
								<form name="runnerForm" id="runnerForm">
									<input type="hidden" name="opt_run" id="opt_run" value="true" />
									<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
										<div class="panel panel-primary">
											<div class="panel-heading clearfix">
												<cfscript>
													WriteOutput(variables.attrs['breadcrumbNav']);
												</cfscript>
												<div class="btn-group pull-right">
													<a role="button" class="btn btn-default tb-toggle-btn" data-toggle="collapse" data-parent="##accordion" href="##contents" aria-expanded="true" aria-controls="contents"><span class="tb-accordion-btn-text">Collapse</span></a>
												</div>
											</div>
											<ul id="contents" class="collapse list-group in" role="tabpanel" aria-labelledby="Contents: #variables.attrs['testRoot']#">
												<cfloop query="variables.attrs.directoryContents">
													<cfif refind( "^\.", variables.attrs.directoryContents.name )>
														<cfcontinue>
													</cfif>
													<cfset variables.attrs['linkPath']=variables.attrs['rootMapping']&'/' />
													<cfif variables.attrs.directoryContents.type eq "Dir">
														<cfset variables.attrs['linkPath']='/' />
													</cfif>
													<cfif ArrayLen(variables.attrs['path'])>
														<cfset variables.attrs['linkPath']&=ArrayToList(variables.attrs['path'],'/') />
													</cfif>
													<cfset variables.attrs['linkPath']&='/'&variables.attrs.directoryContents.name />
													<cfif variables.attrs.directoryContents.type eq "Dir">
														<li class="list-group-item">
															<a class="btn btn-primary tb-dir-btn"
																role="button"
																href="index.cfm?path=#variables.attrs['linkPath']#"
															><span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span></a>
															<a href="index.cfm?path=#URLEncodedFormat(variables.attrs['linkPath'])#">#variables.attrs.directoryContents.name#</a>
														</li>
													<cfelseif listLast( variables.attrs.directoryContents.name, ".") eq "cfm" and variables.attrs.directoryContents.name neq "Application.cfm">
														<li class="list-group-item">
															<a class="btn btn-primary tb-dir-btn tb-file-btn"
																role="button"
																href="#variables.attrs['linkPath']#"
																<cfif !variables.attrs['cpu']>target="_blank"</cfif>
															><span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span></a>
															<a class="tb-file-btn"
																href="#variables.attrs['linkPath']#"
																<cfif !variables.attrs['cpu']>target="_blank"</cfif>
															>#variables.attrs.directoryContents.name#</a>
														</li>
													<cfelseif listLast( variables.attrs.directoryContents.name, ".") eq "cfc" and variables.attrs.directoryContents.name neq "Application.cfc">
														<li class="list-group-item">
															<a class="btn btn-primary tb-dir-btn tb-file-btn"
																role="button"
																href="#variables.attrs['linkPath']#?method=runRemote"
																<cfif !variables.attrs['cpu']>target="_blank"</cfif>
															><span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span></a>
															<a class="tb-file-btn"
																href="#variables.attrs['linkPath']#?method=runRemote"
																<cfif !variables.attrs['cpu']>target="_blank"</cfif>
															>#variables.attrs.directoryContents.name#</a>
														</li>
													</cfif>
												</cfloop>
											</ul>
										</div>
									</div>
								</form>
							</div>
							<!--- Results --->
							<iframe style="border:0;width:100%;min-height:800px;display:none;" id="tb-results"></iframe>
						</div>
					</div>
				</div>
			</body>
		</html>
	</cfoutput>
	<cfcatch>
		<cfset variables.attrs['cfcatch']=cfcatch />
		<cfdump var="#variables.attrs#" label="#cfcatch.message#" />
		<cfabort />
	</cfcatch>
</cftry>