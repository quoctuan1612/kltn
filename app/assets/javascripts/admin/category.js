$(document).on('turbolinks:load', function() {
  $('body').on('click', '.confirm-delete-category', function(){
    var id = $(this).attr('data-id');

    swal({
      title: 'Xác nhận xóa danh mục',
      icon: 'warning',
      buttons: {
        cancel: {
          text: 'Hủy bỏ',
          value: null,
          visible: true,
        },
        confirm: {
          text: 'Đồng ý',
          value: true,
          visible: true,
        }
      },
    }).then(function(isConfirm){
      if (isConfirm) {
        submit_delete_category(id);
      }
      else {
        swal.close();
      }
    });
  });

  function submit_delete_category (id) {
    $.ajax({
      url: '/admin/categories/' + id,
      type: 'DELETE'
    });
  }
});

$(document).on('keypress', '#admin_category_search', function(e) {
  if(e.which == 13) {
    var value = $(this).val();
    $.ajax({
      url: '/admin/categories/',
      type: 'GET',
      data: {"q[name_or_description_cont]": value}
    });
  }
});

$(document).on('click', '#admin_category_search_btn', function() {
  var value = $('#admin_category_search').val();
  $.ajax({
    url: '/admin/categories/',
    type: 'GET',
    data: {"q[name_or_description_cont]": value}
  });
});
