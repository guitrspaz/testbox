jQuery(document).ready(function() {
	jQuery(document).on('click','.tb-toggle-btn',function(event){
		var target=jQuery(event.currentTarget).attr('href');
		if( jQuery(event.currentTarget).hasClass('in') ){
			jQuery(event.currentTarget).find('.tb-accordion-btn-text').eq(0).text('Collapse');
		} else {
			jQuery(event.currentTarget).find('.tb-accordion-btn-text').eq(0).text('Expand');
		}
	});

	jQuery('.clearResults').each(function(crk,crv){
		jQuery(crv).toggle( jQuery('#tb-results').text().length );
	});

	jQuery(document).on('click','.tb-file-btn',function(event){
		event.preventDefault();
		runTests(jQuery(event.currentTarget).attr('href'));
		return false;
	});

	jQuery(document).on('click','.clearResults',function(event){
		clearResults();
	});

	jQuery(document).on('click','.unreachable',function(event){
		event.preventDefault();
		return false;
	});

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

function clearResults(){
	jQuery('.tb-toggle-btn').eq(0).trigger('click');
	jQuery("#tb-results").empty();
	jQuery('.clearResults').each(function(crk,crv){
		jQuery(crv).hide();
	});
}
function runTests(src){
	jQuery('#tb-results').html('<div class="alert alert-info"><span class="glyphicon normal-right-spinner" aria-hidden="true"></span>&nbsp;Please wait while tests are running...</div>');
	jQuery.ajax({
		url:src,
		method:'get',
		cache:false
	}).done(function(data){
		console.log(data);
		jQuery('.tb-toggle-btn').eq(0).trigger('click');
		jQuery('#tb-results').html(data);
		jQuery('.clearResults').each(function(crk,crv){
			jQuery(crv).show();
		});
	}).fail(function(data,err){
		jQuery('#tb-results').html('<div class="alert alert-danger"><span class="glyphicon glyphicon-alert" aria-hidden="true"></span>&nbsp;The following error occurred: '+err.message+' See the console for more information.</div>');
		console.log('extendedInfo',{data:data,error:err});
	});
}