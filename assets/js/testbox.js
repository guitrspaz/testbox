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
});
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