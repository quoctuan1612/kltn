$(document).on('turbolinks:before-cache', function() { 
	$('.select-select2').select2('destroy');
})

$(document).on('turbolinks:load', function() {
  $('.select-select2').select2();
})
