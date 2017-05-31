<cfset cDir = getDirectoryFromPath( getCurrentTemplatePath() )>
<cfoutput>
	<!--- Navigation --->
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<div class="navbar-header">
				<a href="/" class="navbar-brand"><img src="//www.ortussolutions.com/__media/testbox-185.png" alt="TestBox" id="tb-logo" /></a>
			</div>
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
		<div class="panel-heading">Global Stats (#results.getTotalDuration()# ms)</div>
		<ul class="list-group">
			<li class="list-group-item">Bundles <span class="badge">#results.getTotalBundles()#</span></li>
			<li class="list-group-item">Suites <span class="badge">#results.getTotalSuites()#</span></li>
			<li class="list-group-item">Specs <span class="badge">#results.getTotalSpecs()#</span></li>
		</ul>
		<ul class="list-group">
			<li class="list-group-item success">Pass <span class="badge">#results.getTotalPass()#</span></li>
			<li class="list-group-item warning">Failures <span class="badge">#results.getTotalFail()#</span></li>
			<li class="list-group-item danger">Errors <span class="badge">#results.getTotalError()#</span></li>
			<li class="list-group-item info">Skipped <span class="badge">#results.getTotalSkipped()#</span></li>
			<cfif arrayLen( results.getLabels() )>
				<li class="list-group-item info">Labels Applied <span class="badge">#ArrayLen(arrayToList( results.getLabels() ))#</span>
					<ul class="list-group-item">
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
		<div class="box bundle" id="bundleStats_#thisBundle.path#" data-bundle="#thisBundle.path#">

			<!--- bundle stats --->
			<h2><a href="#variables.baseURL#&testBundles=#URLEncodedFormat( thisBundle.path )#" title="Run only this bundle">#thisBundle.path#</a> (#thisBundle.totalDuration# ms)</h2>
			[ Suites/Specs: #thisBundle.totalSuites#/#thisBundle.totalSpecs# ]
			[ <span class="specStatus passed" 	data-status="passed" data-bundleid="#thisBundle.id#">Pass: #thisBundle.totalPass#</span> ]
			[ <span class="specStatus failed" 	data-status="failed" data-bundleid="#thisBundle.id#">Failures: #thisBundle.totalFail#</span> ]
			[ <span class="specStatus error" 	data-status="error" data-bundleid="#thisBundle.id#">Errors: #thisBundle.totalError#</span> ]
			[ <span class="specStatus skipped" 	data-status="skipped" data-bundleid="#thisBundle.id#">Skipped: #thisBundle.totalSkipped#</span> ]
			[ <span class="reset" title="Clear status filters">Reset</span> ]

			<!-- Globa Error --->
			<cfif !isSimpleValue( thisBundle.globalException )>
				<h2>Global Bundle Exception<h2>
				<cfdump var="#thisBundle.globalException#" />
			</cfif>

			<!-- Iterate over bundle suites -->
			<cfloop array="#thisBundle.suiteStats#" index="suiteStats">
				<div class="suite #lcase( suiteStats.status)#" data-bundleid="#thisBundle.id#">
				<ul>
					#genSuiteReport( suiteStats, thisBundle )#
				</ul>
				</div>
			</cfloop>

			<!--- Debug Panel --->
			<cfif arrayLen( thisBundle.debugBuffer )>
				<hr>
				<h2>Debug Stream <button onclick="toggleDebug( '#thisBundle.id#' )" title="Toggle the test debug stream">+</button></h2>
				<div class="debugdata" data-specid="#thisBundle.id#">
					<p>The following data was collected in order as your tests ran via the <em>debug()</em> method:</p>
					<cfloop array="#thisBundle.debugBuffer#" index="thisDebug">
						<h1>#thisDebug.label#</h1>
						<cfdump var="#thisDebug.data#" 		label="#thisDebug.label# - #dateFormat( thisDebug.timestamp, "short" )# at #timeFormat( thisDebug.timestamp, "full")#" top="#thisDebug.top#"/>
						<cfdump var="#thisDebug.thread#" 	label="Thread data">
						<p>&nbsp;</p>
					</cfloop>
				</div>
			</cfif>

		</div>
	</cfloop>

<!--- Recursive Output --->
	<cffunction name="genSuiteReport" output="false">
		<cfargument name="suiteStats">
		<cfargument name="bundleStats">

		<cfsavecontent variable="local.report">
			<cfoutput>
			<!--- Suite Results --->
			<li>
				<a title="Total: #arguments.suiteStats.totalSpecs# Passed:#arguments.suiteStats.totalPass# Failed:#arguments.suiteStats.totalFail# Errors:#arguments.suiteStats.totalError# Skipped:#arguments.suiteStats.totalSkipped#"
				   href="#variables.baseURL#&testSuites=#URLEncodedFormat( arguments.suiteStats.name )#&testBundles=#URLEncodedFormat( arguments.bundleStats.path )#"
				   class="#lcase( arguments.suiteStats.status )#"><strong>+#arguments.suiteStats.name#</strong></a>
				(#arguments.suiteStats.totalDuration# ms)
			</li>
				<cfloop array="#arguments.suiteStats.specStats#" index="local.thisSpec">

					<!--- Spec Results --->
					<ul>
					<div class="spec #lcase( local.thisSpec.status )#" data-bundleid="#arguments.bundleStats.id#" data-specid="#local.thisSpec.id#">
						<li>
							<a href="#variables.baseURL#&testSpecs=#URLEncodedFormat( local.thisSpec.name )#&testBundles=#URLEncodedFormat( arguments.bundleStats.path )#" class="#lcase( local.thisSpec.status )#">#local.thisSpec.name# (#local.thisSpec.totalDuration# ms)</a>

							<cfif local.thisSpec.status eq "failed">
								- <strong>#htmlEditFormat( local.thisSpec.failMessage )#</strong>
								  <button onclick="toggleDebug( '#local.thisSpec.id#' )" title="Show more information">+</button><br>
								  <div class="">#local.thisSpec.failOrigin[ 1 ].raw_trace#</div>
								  <cfif structKeyExists( local.thisSpec.failOrigin[ 1 ], "codePrintHTML" )>
									<div class="">#local.thisSpec.failOrigin[ 1 ].codePrintHTML#</div>
								  </cfif>
								<div class="box debugdata" data-specid="#local.thisSpec.id#">
									<cfdump var="#local.thisSpec.failorigin#" label="Failure Origin">
								</div>
							</cfif>

							<cfif local.thisSpec.status eq "error">
								- <strong>#htmlEditFormat( local.thisSpec.error.message )#</strong>
								  <button onclick="toggleDebug( '#local.thisSpec.id#' )" title="Show more information">+</button><br>
								  <div class="">#local.thisSpec.failOrigin[ 1 ].raw_trace#</div>
								  <cfif structKeyExists( local.thisSpec.failOrigin[ 1 ], "codePrintHTML" )>
									<div class="">#local.thisSpec.failOrigin[ 1 ].codePrintHTML#</div>
								  </cfif>
								<div class="box debugdata" data-specid="#local.thisSpec.id#">
									<cfdump var="#local.thisSpec.error#" label="Exception Structure">
								</div>
							</cfif>
						</li>
					</div>
					</ul>
				</cfloop>

				<!--- Do we have nested suites --->
				<cfif arrayLen( arguments.suiteStats.suiteStats )>
					<cfloop array="#arguments.suiteStats.suiteStats#" index="local.nestedSuite">
						<div class="suite #lcase( arguments.suiteStats.status )#" data-bundleid="#arguments.bundleStats.id#">
							<ul>
							#genSuiteReport( local.nestedSuite, arguments.bundleStats )#
						</ul>
						</div>
					</cfloop>
				</cfif>

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