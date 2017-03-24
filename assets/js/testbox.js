jQuery(document).ready(function() {

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
