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
			<div class="btn-group pull-left" role="group" aria-label="packages">
				<button type="button" class="btn inactive-btn btn-info">Bundles <span class="badge">#results.getTotalBundles()#</span></button>
				<button type="button" class="btn inactive-btn btn-info">Suites <span class="badge">#results.getTotalSuites()#</span></button>
				<button type="button" class="btn inactive-btn btn-info">Specs <span class="badge">#results.getTotalSpecs()#</span></button>
			</div>
			<div class="btn-group pull-right" role="group" aria-label="statuses">
				<button type="button" class="btn inactive-btn btn-success">Pass <span class="badge">#results.getTotalPass()#</span></button>
				<button type="button" class="btn inactive-btn btn-warning">Failures <span class="badge">#results.getTotalFail()#</span></button>
				<button type="button" class="btn inactive-btn btn-error">Errors <span class="badge">#results.getTotalError()#</span></button>
				<button type="button" class="btn inactive-btn btn-info">Skipped <span class="badge">#results.getTotalSkipped()#</span></button>
			</div>
			<cfif arrayLen( results.getLabels() )>
				<a class="btn btn-info" role="button" data-toggle="collapse" href="##debug#thisBundle.id#" aria-expanded="false" aria-controls="debug#thisBundle.id#">Labels Applied </a>
				<div class="collapse" id="debug#thisBundle.id#" data-specid="#thisBundle.id#">
					<div class="well">
						#ArrayToList(results.getLabels(),',')#
					</div>
				</div>
			</cfif>
			<div class="tb-list-group tb-test-bundles">
			<!--- Bundle Info --->
				<cfloop array="#variables.bundleStats#" index="thisBundle">
					<!--- Bundle div --->
					<div class="panel panel-primary bundle" id="bundleStats_#thisBundle.path#" data-bundle="#thisBundle.path#">
						<cfif !isSimpleValue( thisBundle.globalException )>
							<div class="panel-heading">Global Bundle Exception: #thisBundle.path#</div>
							<cfdump var="#thisBundle.globalException#" />
						<cfelse>
							<div class="panel-heading"><a href="#variables.baseURL#&testBundles=#URLEncodedFormat( thisBundle.path )#" title="Run only this bundle">#thisBundle.path#</a> <em>(#thisBundle.totalDuration# ms)</em></div>
							<div class="panel-body">
								<div class="btn-group pull-left" role="group" aria-label="packages">
									<button type="button" class="btn inactive-btn btn-info">Suites <span class="badge">#thisBundle.totalSuites#</span></button>
									<button type="button" class="btn inactive-btn btn-info">Specs <span class="badge">#thisBundle.totalSpecs#</span></button>
								</div>
								<div class="btn-group pull-right" role="group" aria-label="statuses">
									<button type="button" class="btn inactive-btn btn-success">Pass <span class="badge">#thisBundle.totalPass#</span></button>
									<button type="button" class="btn inactive-btn btn-warning">Failures <span class="badge">#thisBundle.totalFail#</span></button>
									<button type="button" class="btn inactive-btn btn-error">Errors <span class="badge">#thisBundle.totalError#</span></button>
									<button type="button" class="btn inactive-btn btn-info">Skipped <span class="badge">#thisBundle.totalSkipped#</span></button>
								</div>
								<cfif arrayLen( thisBundle.debugBuffer )>
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
								</cfif>
							</div>
							<cfif ArrayLen(thisBundle.suiteStats)>
								<cfloop array="#thisBundle.suiteStats#" index="suiteStats">
									#genSuiteReport( suiteStats,thisBundle )#
								</cfloop>
							</cfif>
						</cfif>
					</div>
				</cfloop>
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
								<div class="col-xs-6"><a href="#variables.baseURL#&testBundles=#URLEncodedFormat( arguments.bundleStats.path )#" title="Run only this bundle">#arguments.suiteStats.name#</a> <em>(#arguments.suiteStats.totalDuration# ms)</em></div>
								<div class="col-xs-6">
									<div class="btn-group" role="group" aria-label="statuses">
										<button type="button" class="btn inactive-btn btn-success">Pass <span class="badge">#arguments.suiteStats.totalPass#</span></button>
										<button type="button" class="btn inactive-btn btn-warning">Failures <span class="badge">#arguments.suiteStats.totalFail#</span></button>
										<button type="button" class="btn inactive-btn btn-error">Errors <span class="badge">#arguments.suiteStats.totalError#</span></button>
										<button type="button" class="btn inactive-btn btn-info">Skipped <span class="badge">#arguments.suiteStats.totalSkipped#</span></button>
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
							</div>
						</div>
						<cfif arrayLen( arguments.suiteStats.suiteStats )>
							<cfloop array="#arguments.suiteStats.suiteStats#" index="local.nestedSuite">
								#genSuiteReport( local.nestedSuite, arguments.bundleStats )#
							</cfloop>
						</cfif>
					</cfif>
				</div>
			</cfoutput>
		</cfsavecontent>
		<cfreturn local.report>
	</cffunction>
</cfoutput>