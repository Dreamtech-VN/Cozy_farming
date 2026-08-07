$(function(){
	$('#carousel').carousel({
        num: 5,
        maxWidth: 340,
        maxHeight: 455,
        distance: 150,
        scale: 0.85,
        animationTime: 1000,
        showTime: 4000
    });
    $('#button-bar').click(function(){    	
    	if($(this).hasClass('tap')){
    		$('.overlay').fadeOut('fast');
    		$('#topbarlinks').removeClass('show');
    		$(this).removeClass('tap');
    	}
    	else{
    		$('.overlay').fadeIn('fast');
    		$('#topbarlinks').addClass('show');
    		$(this).addClass('tap');
    	}
    	
    });
});
