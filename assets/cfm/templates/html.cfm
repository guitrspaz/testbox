<cfoutput>
	<!--- Navigation --->
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<ul class="nav navbar-nav navbar-left">
				<li><a href="/assets/cfm/runner.cfm?directory=#variables.baseURL#" class="tb-file-btn">Run All</a></li>
				<li><a href="##" class="clearResults"><span class="text-danger">Clear Results</span></a></li>
			</ul>
			<form class="navbar-form navbar-right">
				<div class="form-group">
					<input class="form-control" type="text" name="bundleFilter" id="bundleFilter" placeholder="Filter Bundles..." />
				</div>
			</form>
		</div>
	</nav>

	<!--- Global Stats --->

	<div class="panel panel-info" id="globalStats">
		<div class="panel-heading">Global Stats <em>(#results.getTotalDuration()# ms)</em></div>
		<div class="panel-body">
			<div class="container-fluid">
				<div class="bundle-stats">
					<div class="pull-left">
						<span class="text-result text-info">Bundles <span class="badge">#results.getTotalBundles()#</span></span>
						<span class="text-result text-info">Suites <span class="badge">#results.getTotalSuites()#</span></span>
						<span class="text-result text-info">Specs <span class="badge">#results.getTotalSpecs()#</span></span>
					</div>
					<div class="pull-right">
						<span class="text-result text-success">Pass <span class="badge">#results.getTotalPass()#</span></span>
						<span class="text-result text-warning">Failures <span class="badge">#results.getTotalFail()#</span></span>
						<span class="text-result text-danger">Errors <span class="badge">#results.getTotalError()#</span></span>
						<span class="text-result text-info">Skipped <span class="badge">#results.getTotalSkipped()#</span></span>
					</div>
				</div>
				<cfif arrayLen( results.getLabels() )>
					<div class="row">
						<a class="btn btn-info" role="button" data-toggle="collapse" href="##debug#thisBundle.id#" aria-expanded="false" aria-controls="debug#thisBundle.id#">Labels Applied </a>
						<div class="collapse" id="debug#thisBundle.id#" data-specid="#thisBundle.id#">
							<div class="well">
								#ArrayToList(results.getLabels(),',')#
							</div>
						</div>
					</div>
				</cfif>
				<div class="row">
				<!--- Bundle Info --->
					<cfloop array="#variables.bundleStats#" index="thisBundle">
						<!--- Bundle div --->
						<div class="bundle" id="bundleStats_#thisBundle.path#" data-bundle="#thisBundle.path#">
							<h3>
								<a href="#variables.baseURL#&testBundles=#URLEncodedFormat( thisBundle.path )#" title="Run only this bundle">#thisBundle.path#</a> <em>(#thisBundle.totalDuration# ms)</em>
							</h3>
							<div class="row">
								<div class="pull-left">
									<span class="text-result text-info">Suites <span class="badge">#thisBundle.totalSuites#</span></span>
									<span class="text-result text-info">Specs <span class="badge">#thisBundle.totalSpecs#</span></span>
								</div>
								<div class="pull-right">
									<span class="text-result text-success">Pass <span class="badge">#thisBundle.totalPass#</span></span>
									<span class="text-result text-warning">Failures <span class="badge">#thisBundle.totalFail#</span></span>
									<span class="text-result text-danger">Errors <span class="badge">#thisBundle.totalError#</span></span>
									<span class="text-result text-info">Skipped <span class="badge">#thisBundle.totalSkipped#</span></span>
								</div>
							</div>
							<cfif ArrayLen(thisBundle.suiteStats)>
								<div class="row">
									<cfloop array="#thisBundle.suiteStats#" index="suiteStats">
										#genSuiteReport( suiteStats,thisBundle )#
									</cfloop>
								</div>
							</cfif>
							<cfif arrayLen( thisBundle.debugBuffer )>
								<div class="row">
									<a class="btn btn-danger" role="button" data-toggle="collapse" href="##debug#thisBundle.id#" aria-expanded="false" aria-controls="debug#thisBundle.id#">Debug Panel</a>
									<div class="collapse" id="debug#thisBundle.id#" data-specid="#thisBundle.id#">
										<div class="well">
											<p>The following data was collected in order as your tests ran via the <em>debug()</em> method:</p>
											<div id="debugBlock#thisBundle.id#">
												<ul class="list-group">
													<cfloop array="#thisBundle.debugBuffer#" index="thisDebug">
														<li class="list-group-item">
															<h3>Debug: <span class="label label-default">#thisDebug.label#</span></h3>
															<cfdump var="#thisDebug.data#" label="#thisDebug.label# - #dateTimeFormat( thisDebug.timestamp, "short" )#" top="#thisDebug.top#" />
															<cfdump var="#thisDebug.thread#" label="Thread data" />
														</li>
													</cfloop>
												</ul>
											</div>
										</div>
									</div>
								</div>
							</cfif>
						</div>
					</cfloop>
				</div>
			</div>
		</div>
	</div>


<!--- Recursive Output --->
	<cffunction name="genSuiteReport" output="false">
		<cfargument name="suiteStats">
		<cfargument name="bundleStats">

		<cfsavecontent variable="local.report">
			<cfoutput>
				<ul class="list-group spec #lcase( arguments.suiteStats.status )#" id="bundleStats_#arguments.bundleStats.path#" data-bundle="#arguments.bundleStats.path#">
					<cfif !isSimpleValue( arguments.bundleStats.globalException )>
						<li class="list-group-item">
							<p class="danger">Global Bundle Exception: #arguments.bundleStats.path#</p>
							<cfdump var="#arguments.bundleStats.globalException#" />
						</li>
					<cfelse>
						<li class="list-group-item">
							<div class="alert alert-info">
								<div class="row">
									<div class="col-xs-6">
										<a href="#variables.baseURL#&testBundles=#URLEncodedFormat( arguments.bundleStats.path )#" title="Run only this bundle">#arguments.suiteStats.name#</a> <em>(#arguments.suiteStats.totalDuration# ms)</em>
									</div>
									<div class="col-xs-6">
										<div class="pull-right">
											<span class="text-result text-success">Pass <span class="badge">#arguments.suiteStats.totalPass#</span></span>
											<span class="text-result text-warning">Failures <span class="badge">#arguments.suiteStats.totalFail#</span></span>
											<span class="text-result text-danger">Errors <span class="badge">#arguments.suiteStats.totalError#</span></span>
											<span class="text-result text-info">Skipped <span class="badge">#arguments.suiteStats.totalSkipped#</span></span>
										</div>
									</div>
								</div>
							</div>
							<ul class="list-group tb-list-group">
								<cfloop array="#arguments.suiteStats.specStats#" index="local.thisSpec">
									<li class="list-group-item spec #lcase( local.thisSpec.status )#" data-bundleid="#arguments.bundleStats.id#" data-specid="#local.thisSpec.id#">
										<div class="alert alert-info"><a href="#variables.baseURL#&testSpecs=#URLEncodedFormat( local.thisSpec.name )#&testBundles=#URLEncodedFormat( arguments.bundleStats.path )#" class="#lcase( local.thisSpec.status )#">#local.thisSpec.name# (#local.thisSpec.totalDuration# ms)</a></div>
										<div class="tb-statuses">
											<cfswitch expression="#local.thisSpec.status#">
												<cfcase value="failed">
													<div class="well">
														<strong>#htmlEditFormat( local.thisSpec.failMessage )#</strong>
														<samp>#local.thisSpec.failOrigin[ 1 ].raw_trace#</samp>
														<cfif structKeyExists( local.thisSpec.failOrigin[ 1 ], "codePrintHTML" )>
															<code>#local.thisSpec.failOrigin[ 1 ].codePrintHTML#</code>
														</cfif>
														<a class="btn btn-warning" role="button" data-toggle="collapse" href="##failed#local.thisSpec.id#" aria-expanded="false" aria-controls="failed#local.thisSpec.id#">Failure Origin</a>
														<div class="collapse" id="failed#local.thisSpec.id#" data-specid="#local.thisSpec.id#">
															<cfdump var="#local.thisSpec.failorigin#" label="Failure Origin" />
														</div>
													</div>
												</cfcase>
												<cfcase value="error">
													<div class="well">
														<strong>#htmlEditFormat( local.thisSpec.error.message )#</strong>
														<samp>#local.thisSpec.failOrigin[ 1 ].raw_trace#</samp>
														<cfif structKeyExists( local.thisSpec.failOrigin[ 1 ], "codePrintHTML" )>
															<code>#local.thisSpec.failOrigin[ 1 ].codePrintHTML#</code>
														</cfif>
														<a class="btn btn-danger" role="button" data-toggle="collapse" href="##error#local.thisSpec.id#" aria-expanded="false" aria-controls="error#local.thisSpec.id#">Exception Structure</a>
														<div class="collapse" id="error#local.thisSpec.id#" data-specid="#local.thisSpec.id#">
															<cfdump var="#local.thisSpec.error#" label="Exception Structure" />
														</div>
													</div>
												</cfcase>
											</cfswitch>
										</div>
									</li>
								</cfloop>
							</ul>
							<cfif arrayLen( arguments.suiteStats.suiteStats )>
								<cfloop array="#arguments.suiteStats.suiteStats#" index="local.nestedSuite">
									#genSuiteReport( local.nestedSuite, arguments.bundleStats )#
								</cfloop>
							</cfif>
						</li>
					</cfif>
				</ul>
			</cfoutput>
		</cfsavecontent>
		<cfreturn local.report>
	</cffunction>
</cfoutput>