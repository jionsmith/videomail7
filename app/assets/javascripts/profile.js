function profiletoggle() {
  $("#profiletoggle").click(function(event) {
    event.preventDefault();

    $("#profile").slideToggle("slow");

    var icon = $('#profiletoggle .toggle-icon');
    var title = $('#profiletoggle .toggle-title');

    if (icon.hasClass('glyphicon-circle-arrow-down')) {
      title.replaceWith('<span class="toggle-title">Profile</span>');
      icon.removeClass('glyphicon-circle-arrow-down').addClass('glyphicon-circle-arrow-up');
    }
    else {
      title.replaceWith('<span class="toggle-title">Profile</span>');
      icon.removeClass('glyphicon-circle-arrow-up').addClass('glyphicon-circle-arrow-down');
    }

    if ($(window).width() <= 690) {
      $('.navbar-collapse').collapse('hide');
      $(window).scrollTop(0);
    }
  });
}

$(function () {
  $('.list-group-item > .show-menu').on('click', function(event) {
    event.preventDefault();
    $(this).closest('li').toggleClass('open');
  });

  profiletoggle();
});

/*
$(function() {
  // attach table filter plugin to inputs
  $('[data-action="filter"]').filterTable();

  $('.contactlist ').on('click', '.contactlist .panel-heading span.filter', function (e) {
    var $this = $(this),
      $panel = $this.parents('.panel');

    $panel.find('.contactlist .panel-body').slideToggle();
    if ($this.css('display') != 'none') {
      $panel.find('.contactlist .panel-body input').focus();
    }
  });
  $('[data-toggle="tooltip"]').tooltip();
})
*/
