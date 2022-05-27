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

$(document).on('click', '.js-button-update-info-form', function() {
  var form = $(this).closest('.update-info-form');
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

$(document).on('submit', '.update-info-form', function() {
  $(this).attr('disabled', true);
})

$(document).on('click', '.js-button-edit', function() {
  $(':input').attr('disabled', false);
  $(this).addClass('hidden');
  $('.js-button-cancel').removeClass('hidden');
  $('.js-button-update-info-form').removeClass('hidden');
})

$(document).on('click', '.js-button-cancel', function() {
  window.location.reload();
})
