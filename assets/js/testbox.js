jQuery(document).ready(function() {
	jQuery(document).on('click','.tb-toggle-btn',function(event){
		var target=jQuery(event.currentTarget).attr('href');
		if( jQuery(event.currentTarget).hasClass('in') ){
			jQuery(event.currentTarget).find('.tb-accordion-btn-text').eq(0).text('Collapse');
		} else {
			jQuery(event.currentTarget).find('.tb-accordion-btn-text').eq(0).text('Expand');
		}
	});
	jQuery('#clearResults').toggle( jQuery('#tb-results').is(':visible') );

	jQuery(document).on('click','.tb-file-btn',function(event){
		event.preventDefault();
		runTests(jQuery(event.currentTarget).attr('href'));
		return false;
	});

	jQuery(document).on('click','#clearResults',function(event){
		event.preventDefault();
		clearResults();
		return false;
	});

	jQuery(document).on('click','.unreachable',function(event){
		event.preventDefault();
		return false;
	});
});

function clearResults(){
	jQuery('.tb-toggle-btn').eq(0).trigger('click');
	jQuery("#tb-results").attr('src','');
	jQuery('#tb-results').hide();
	jQuery('#clearResults').toggle( jQuery('#tb-results').is(':visible') );
}

function runTests(src){
	jQuery('.tb-toggle-btn').eq(0).trigger('click');
	jQuery('#tb-results').attr('src',src);
	jQuery('#tb-results').show();
	jQuery('#clearResults').toggle( jQuery('#tb-results').is(':visible') );
}
