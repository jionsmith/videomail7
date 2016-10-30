function radio_button_replacement() {
  if($('.radio.select input[type="radio"]').length > 0) {
    $('.radio.select input[type="radio"]').each(function() {
      if($(this).prop('checked') == true)
        $(this).parent().addClass('active');
      else
        $(this).parent().removeClass('active');
    });
  }
}