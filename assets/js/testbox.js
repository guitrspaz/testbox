jQuery(document).ready(function() {
	jQuery(document).on('click','.tb-toggle-btn',function(event){
		var target=jQuery(event.currentTarget).attr('href');
		if( jQuery(target).hasClass('in') ){
			jQuery(event.currentTarget).find('.tb-accordion-btn-text').eq(0).text('Collapse');
			jQuery(event.currentTarget).find('.caret').eq(0).removeClass('caret-right');
		} else {
			jQuery(event.currentTarget).find('.tb-accordion-btn-text').eq(0).text('Expand');
			jQuery(event.currentTarget).find('.caret').eq(0).addClass('caret-right');
		}
	});
});
function runTests(){
	jQuery("#btn-run").html( 'Running...' ).css( "opacity", "0.5" );
	jQuery("#tb-results").load( "index.cfm", jQuery("#runnerForm").serialize(), function( data ){
		jQuery("#btn-run").html( 'Run' ).css( "opacity", "1" );
	} );
}
function clearResults(){
	jQuery("#tb-results").html( '' );
	jQuery("#target").html( '' );
	jQuery("#labels").html( '' );
}
