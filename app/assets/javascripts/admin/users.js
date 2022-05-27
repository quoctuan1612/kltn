function uploadUserAvatar() {
  var img_preview = $('.store-item-image').find('img');
  var old_url = img_preview.attr('src');
  $('#user_avatar').on('change', handleUploadUserAvatar);

  function handleUploadUserAvatar() {
    if(validateSizeUserAvatar(this.files[0].size)) {
      ImagePreview(this.files[0]);
    } else {
      swal({
        title: "Ảnh tải lên không được hơn 3MB",
        icon: 'warning',
        dangerMode: true,
        buttons: {
          confirm: {
            text: "OK",
            value: true,
            visible: true,
          }
        }
      });
      this.value = "";
      defaultImage();
    }
  }

  $('.reset-input-course').on('click', function() {
    defaultImage();
    CKEDITOR.instances.course_description.setData('');
  });

  function validateSizeUserAvatar(size) {
    var max_size = 3 * 1024 * 1024;
    return size <= max_size;
  }

  function ImagePreview(file) {
    var reader = new FileReader();
    reader.onload = function(e) {
      img_preview.attr('src', e.target.result);
    }
    reader.readAsDataURL(file);
  }

  function defaultImage() {
    img_preview.attr('src', old_url);
  }
}

$(document).on('click', '.js-button-form-user', function() {
  var form = $(this).closest('.js-user-form');
  var url = form.attr('action');
  var type = form.find('input[name="_method"]').val() || form.attr('method');

  var formData = new FormData();
  var email = $('#user_email').val();
  var userName = $('#user_user_name').val();
  var password = $('#user_password').val();
  var passwordConfirmation = $('#user_password_confirmation').val();
  var role = $('#user_role').val();
  var avatar = $('#user_avatar')[0].files[0];
  formData.append('user[email]', email);
  formData.append('user[user_name]', userName);
  if (password != ''){
    formData.append('user[password]', password);
    formData.append('user[password_confirmation]', passwordConfirmation);
  }
  formData.append('user[role]', role);

  if (typeof avatar != 'undefined')
    formData.append('user[avatar]', avatar);

  $.ajax({
    url: url,
    type: type,
    dataType: 'SCRIPT',
    processData: false,
    contentType: false,
    data: formData
  });
});

$(document).on('submit', '.js-user-form', function() {
  $(this).attr('disabled', true);
})

$(document).on('turbolinks:load', function() { 
  $('body').on('click', '.confirm-delete-user', function(){
    var id = $(this).attr('data-id');

    swal({
      title: 'Xác nhận xóa người dùng',
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
        submit_delete_user(id);
      }
      else {
        swal.close();
      }
    });
  });

  function submit_delete_user (id) {
    $.ajax({
      url: '/admin/users/' + id,
      type: 'DELETE'
    });
  }
})

$(document).on('keypress', '#admin_user_search', function(e) {
  if(e.which == 13) {
    var value = $(this).val();
    var role = $('#role-filter-user').val();
    $.ajax({
      url: '/admin/users',
      type: 'GET',
      data: {
        "q[user_name_or_email_cont]": value,
        "role": role
      }
    });
  }
});

var filterUser = function() {
  var value = $('#admin_user_search').val();
  var role = $('#role-filter-user').val();
  $.ajax({
    url: '/admin/users',
    type: 'GET',
    data: {
      "q[user_name_or_email_cont]": value,
      "role": role
    }
  });
}

$(document).on('click', '#admin_user_search_btn', filterUser);
$(document).on('change', '#role-filter-user', filterUser)
