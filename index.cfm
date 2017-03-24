<cfsetting showdebugoutput="false" >
<!--- CPU Integration --->
<cfparam name="url.cpu" default="false">
<!--- SETUP THE ROOTS OF THE BROWSER RIGHT HERE --->
<cfset rootMapping 	= '/src/tests' />
<cfif directoryExists( rootMapping )>
	<cfset rootPath = rootMapping>
<cfelse>
	<cfset rootPath = expandPath( rootMapping )>
</cfif>

<!--- param incoming --->
<cfparam name="url.path" default="/">

<!--- Decodes & Path Defaults --->
<cfset url.path = urlDecode( url.path )>
<cfif !len( url.path )>
	<cfset url.path = "/">
</cfif>

<!--- Prepare TestBox --->
<cfset testbox = new testbox.system.TestBox()>

<!--- Run Tests Action?--->
<cfif structKeyExists( url, "action")>
	<cfif directoryExists( expandPath( rootMapping & url.path ) )>
		<cfoutput>#testbox.init( directory=rootMapping & url.path ).run()#</cfoutput>
	<cfelse>
		<cfoutput><h1>Invalid incoming directory: #rootMapping & url.path#</h1></cfoutput>
	</cfif>
	<cfabort>
</cfif>

<!--- Get list of files --->
<cfdirectory action="list" directory="#rootPath & url.path#" name="qResults" sort="asc" />
	<cfdump var="#qResults#" />
<!--- Get the execute path --->
<cfset executePath = rootMapping & ( url.path eq "/" ? "/" : url.path & "/" )>
<!--- Get the Back Path --->
<cfif url.path neq "/">
	<cfset variables.backPath = replacenocase( url.path, listLast( url.path, "/" ), "" )>
	<cfset variables.backPath = reReplace( variables.backPath,"/##","" ) />
</cfif>

<cfoutput>
<!--- Do HTML --->
	<!DOCTYPE html>
	<html>
		<head>
			<meta charset="utf-8">
			<meta name="generator" content="TestBox v#testbox.getVersion()#">
			<title>TestBox Test Runner</title>
			<link rel="stylesheet" href="/node_modules/bootstrap/dist/css/bootstrap.min.css" />
			<link rel="stylesheet" href="/assets/css/testbox.css" />
			<script type="text/javascript" src="/node_modules/normalize/lib/normalize.js"></script>
			<script type="text/javascript" src="/node_modules/jquery/dist/jquery.min.js"></script>
			<script type="text/javascript" src="/node_modules/bootstrap/dist/js/bootstrap.min.js"></script>
			<script type="text/javascript" src="/assets/js/testbox.js"></script>
		</head>
		<body class="container-fluid">
			<div id="page" class="site">
				<header id="masthead" role="navigation">
					<nav class="navbar navbar-default navbar-static-top" id="site-branding">
						<div class="container-fluid">
							<a href="##" class="navbar-brand"><img src="//www.ortussolutions.com/__media/testbox-185.png" alt="TestBox" id="tb-logo" /></a>
							<ul class="nav navbar-nav">
								<li><p class="navbar-text">v#testbox.getVersion()#</p></li>
								<li><a href="index.cfm?action=runTestBox&path=#URLEncodedFormat( url.path )#" target="_blank">Run All</a></li>
								<cfif StructKeyExists(variables,'backpath')>
									<li><a href="index.cfm?path=#URLEncodedFormat( variables.backPath )#">Go Back</a></li>
								</cfif>
							</ul>
						</div>
					</nav>
				</header>
				<div class="site-content-contain">
					<div id="content" class="site-content">
						<div id="primary" class="content-area">
							<h1>TestBox Test Browser: </h1>
							<p>
								Below is a listing of the files and folders starting from your root <code>#rootPath#</code>.  You can click on individual tests in order to execute them
								or click on the <strong>Run All</strong> button on your left and it will execute a directory runner from the visible folder.
							</p>
							<form name="runnerForm" id="runnerForm">
								<input type="hidden" name="opt_run" id="opt_run" value="true" />
								<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
									<div class="panel panel-primary">
										<div class="panel-heading clearfix">
											<h3 class="panel-title pull-left">Contents: #executePath#</h3>
											<div class="btn-group pull-right">
												<a role="button" class="btn btn-default" data-toggle="collapse" data-parent="##accordion" href="##contents" aria-expanded="true" aria-controls="contents">Expand <span class="caret"></span></a>
											</div>
										</div>
										<cfif qResults.recordCount>
											<ul id="contents" class="collapse list-group" role="tabpanel" aria-labelledby="Contents: #executePath#">
												<cfloop query="qResults">
													<cfif refind( "^\.", qResults.name )>
														<cfcontinue>
													</cfif>
													<cfset dirPath = URLEncodedFormat( ( url.path neq '/' ? '#url.path#/' : '/' ) & qResults.name )>
													<cfif qResults.type eq "Dir">
														<li><a href="index.cfm?path=#dirPath#">+#qResults.name#</a></li>
													<cfelseif listLast( qresults.name, ".") eq "cfm">
														<li><a class="btn btn-primary" role="button" href="#executePath & qResults.name#" <cfif !url.cpu>target="_blank"</cfif>>#qResults.name#</a></li>
													<cfelseif listLast( qresults.name, ".") eq "cfc" and qresults.name neq "Application.cfc">
														<li><a class="btn btn-primary" role="button" href="#executePath & qResults.name#?method=runRemote" <cfif !url.cpu>target="_blank"</cfif>>#qResults.name#</a></li>
													<cfelse>
														<li>#qResults.name#</li>
													</cfif>
												</cfloop>
											</ul>
										</cfif>
									</div>
								</div>
							</form>
						</div>
						<!--- Results --->
						<div id="tb-results"></div>
					</div>
				</div>
			</div>
		</body>
	</html>
</cfoutput>