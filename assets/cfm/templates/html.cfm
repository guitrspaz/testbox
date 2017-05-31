<cfset cDir = getDirectoryFromPath( getCurrentTemplatePath() )>
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
		<ul class="list-group">
			<li class="list-group-item">
				<span class="badge">#results.getTotalBundles()#</span>
				Bundles
			</li>
			<li class="list-group-item">
				<span class="badge">#results.getTotalSuites()#</span>
				Suites
			</li>
			<li class="list-group-item">
				<span class="badge">#results.getTotalSpecs()#</span>
				Specs
			</li>
		</ul>
		<ul class="list-group">
			<li class="list-group-item success">
				<span class="badge">#results.getTotalPass()#</span>
				Pass
			</li>
			<li class="list-group-item warning">
				<span class="badge">#results.getTotalFail()#</span>
				Failures
			</li>
			<li class="list-group-item danger">
				<span class="badge">#results.getTotalError()#</span>
				Errors
			</li>
			<li class="list-group-item info">
				<span class="badge">#results.getTotalSkipped()#</span>
				Skipped
			</li>
			<cfif arrayLen( results.getLabels() )>
				<li class="list-group-item info">Labels Applied <span class="badge">#ArrayLen(arrayToList( results.getLabels() ))#</span>
					<ul class="list-group">
						<cfscript>
							ArrayEach(results.getLabels(),function(item){
								WriteOutput('<li class="list-group-item">');
									WriteOutput(item);
								WriteOutput('</li>');
							});
						</cfscript>
					</ul>
				</li>
			</cfif>
		</ul>
	</div>
	<!--- Bundle Info --->
	<cfloop array="#variables.bundleStats#" index="thisBundle">
		<!--- Bundle div --->
		<div class="panel panel-primary bundle" id="bundleStats_#thisBundle.path#" data-bundle="#thisBundle.path#">
			<cfif !isSimpleValue( thisBundle.globalException )>
				<div class="panel-heading">Global Bundle Exception: #thisBundle.path#</div>
				<cfdump var="#thisBundle.globalException#" />
			<cfelse>
				<div class="panel-heading"><a href="#variables.baseURL#&testBundles=#URLEncodedFormat( thisBundle.path )#" title="Run only this bundle">#thisBundle.path#</a> <em>(#thisBundle.totalDuration# ms)</em></div>
				<ul class="list-group">
					<li class="list-group-item">
						<span class="badge">#thisBundle.totalSuites#</span>
						Suites
					</li>
					<li class="list-group-item">
						<span class="badge">#thisBundle.totalSpecs#</span>
						Specs
					</li>
				</ul>
				<ul class="list-group">
					<li class="list-group-item success specStatus passed" data-status="passed" data-bundleid="#thisBundle.id#">
						<span class="badge">#thisBundle.totalPass#</span>
						Pass
					</li>
					<li class="list-group-item warning specStatus failed" data-status="failed" data-bundleid="#thisBundle.id#">
						<span class="badge">#thisBundle.totalFail#</span>
						Failures
					</li>
					<li class="list-group-item danger specStatus error" data-status="error" data-bundleid="#thisBundle.id#">
						<span class="badge">#thisBundle.totalError#</span>
						Errors
					</li>
					<li class="list-group-item info specStatus skipped" data-status="skipped" data-bundleid="#thisBundle.id#">
						<span class="badge">#thisBundle.totalSkipped#</span>
						Skipped
					</li>
				</ul>
				<cfif ArrayLen(thisBundle.suiteStats)>
					<ul class="list-group">
						<cfloop array="#thisBundle.suiteStats#" index="suiteStats">
							<li class="list-group-item">#genSuiteReport( suiteStats,thisBundle )#</li>
						</cfloop>
					</ul>
				</cfif>
				<cfif arrayLen( thisBundle.debugBuffer )>
					<div class="panel-body">
						<a class="btn btn-primary" role="button" data-toggle="collapse" href="##debug#thisBundle.id#" aria-expanded="false" aria-controls="debug#thisBundle.id#">Debug Panel</a>
						<div class="collapse" id="debug#thisBundle.id#" data-specid="#thisBundle.id#">
							<div class="well">
								<p>The following data was collected in order as your tests ran via the <em>debug()</em> method:</p>
								<div id="debugBlock#thisBundle.id#">
									<ul class="list-group">
										<cfloop array="#thisBundle.debugBuffer#" index="thisDebug">
											<li class="list-group-item">
												<h3>Debug: <span class="label label-default">#thisDebug.label#</span></h3>
												<cfdump var="#thisDebug.data#" label="#thisDebug.label# - #dateFormat( thisDebug.timestamp, "short" )# at #timeFormat( thisDebug.timestamp, "full")#" top="#thisDebug.top#" />
												<cfdump var="#thisDebug.thread#" label="Thread data" />
											</li>
										</cfloop>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</cfif>
			</cfif>
		</div>
	</cfloop>

<!--- Recursive Output --->
	<cffunction name="genSuiteReport" output="false">
		<cfargument name="suiteStats">
		<cfargument name="bundleStats">

		<cfsavecontent variable="local.report">
			<cfoutput>
				<div class="panel panel-primary spec #lcase( local.thisSpec.status )#" id="bundleStats_#thisBundle.path#" data-bundle="#thisBundle.path#">
					<cfif !isSimpleValue( thisBundle.globalException )>
						<div class="panel-heading">Global Bundle Exception: #thisBundle.path#</div>
						<cfdump var="#thisBundle.globalException#" />
					<cfelse>
						<div class="panel-heading"><a href="#variables.baseURL#&testBundles=#URLEncodedFormat( thisBundle.path )#" title="Run only this bundle">#arguments.suiteStats.name#</a> <em>(#arguments.suiteStats.totalDuration# ms)</em></div>
						<ul class="list-group">
							<li class="list-group-item">
								<span class="badge">#arguments.suiteStats.totalSpecs#</span>
								Specs
							</li>
						</ul>
						<ul class="list-group">
							<li class="list-group-item success specStatus passed" data-status="passed" data-bundleid="#thisBundle.id#">
								<span class="badge">#arguments.suiteStats.totalPass#</span>
								Pass
							</li>
							<li class="list-group-item warning specStatus failed" data-status="failed" data-bundleid="#thisBundle.id#">
								<span class="badge">#arguments.suiteStats.totalFail#</span>
								Failures
							</li>
							<li class="list-group-item danger specStatus error" data-status="error" data-bundleid="#thisBundle.id#">
								<span class="badge">#arguments.suiteStats.totalError#</span>
								Errors
							</li>
							<li class="list-group-item info specStatus skipped" data-status="skipped" data-bundleid="#thisBundle.id#">
								<span class="badge">#arguments.suiteStats.totalSkipped#</span>
								Skipped
							</li>
						</ul>
						<div class="panel-body">
							<cfloop array="#arguments.suiteStats.specStats#" index="local.thisSpec">
								<div class="panel panel-default spec #lcase( local.thisSpec.status )#" data-bundleid="#arguments.bundleStats.id#" data-specid="#local.thisSpec.id#">
									<div class="panel-heading">
										<a href="#variables.baseURL#&testSpecs=#URLEncodedFormat( local.thisSpec.name )#&testBundles=#URLEncodedFormat( arguments.bundleStats.path )#" class="#lcase( local.thisSpec.status )#">#local.thisSpec.name# (#local.thisSpec.totalDuration# ms)</a>
									</div>
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
							</cfloop>
						</div>
						<cfif arrayLen( arguments.suiteStats.suiteStats )>
							<ul class="list-group">
								<cfloop array="#arguments.suiteStats.suiteStats#" index="local.nestedSuite">
									<li class="list-group-item">#genSuiteReport( local.nestedSuite, arguments.bundleStats )#</li>
								</cfloop>
							</ul>
						</cfif>
					</cfif>
				</div>
			</cfoutput>
		</cfsavecontent>
		<cfreturn local.report>
	</cffunction>

	<script type="text/javascript">
		jQuery(document).ready(function() {
			// spec toggler
			jQuery(document).on('click',"span.specStatus",function(event){
				toggleSpecs( jQuery( event.currentTarget ).attr( "data-status" ), jQuery( event.currentTarget ).attr( "data-bundleid" ) );
			});
			// spec toggler
			jQuery(document).on('click',"span.reset",function(event){
				resetSpecs(event);
			});
			// Filter Bundles
			jQuery(document).on('keyup',"##bundleFilter",function(event){
				var targetText = jQuery( event.currentTarget ).val().toLowerCase();
				jQuery( ".bundle" ).each(function( ik,iv ){
					var bundle = jQuery( iv ).attr( "data-bundle" ).toLowerCase();
					jQuery(iv).toggle( (bundle.search( targetText ) < 0)?false:true );
				});
			});
			jQuery( "##bundleFilter" ).focus();
		});

		function resetSpecs(event){
			jQuery("div.spec").each(function(ks,vs){
				jQuery(vs).show();
			});
			jQuery("div.suite").each(function(ks,vs){
				jQuery(vs).show();
			});
		}

		function toggleSpecs( type, bundleID ){
			jQuery("div.suite").each( function(ks,vs){
				handleToggle( jQuery( vs ), bundleID, type );
			} );
			jQuery("div.spec").each( function(ks,vs){
				handleToggle( jQuery( vs ), bundleID, type );
			} );
		}

		function handleToggle( target, bundleID, type ){
			// if bundleid passed and not the same bundle, skip
			if( bundleID != undefined && jQuery(target).attr( "data-bundleid" ) != bundleID ){
				return;
			}
			// toggle the opposite type
			if( !jQuery(target).hasClass( type ) ){
				jQuery(target).fadeOut();
			} else {
				// show the type you sent
				jQuery(target).parents().fadeIn();
				jQuery(target).fadeIn();
			}
		}

		function toggleDebug( specid ){
			jQuery("div.debugdata").each( function(ks,vs){

				// if bundleid passed and not the same bundle
				if( specid != undefined && jQuery(vs).attr( "data-specid" ) != specid ){
					return;
				}
				// toggle.
				jQuery(vs).fadeToggle();
			});
		}
	</script>
</cfoutput>