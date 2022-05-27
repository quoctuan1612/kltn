$(document).on('submit', '#create-question-form', function() {
  $('.an-answer-container:visible').each(function() {
    $(this).find('input.is-delete-answer').val('false');
  })
  $('.is_true_question').removeAttr("disabled");
  $('#submit-question-btn').prop('disabled', true);
});

$(document).on('turbolinks:load', function() {
  $(".link-new-answers").click(function(e) {
    var answer_field = $(this).data('formPrepend').replace(/new_record/g, new Date().getTime());
    if ($('#js-select-question-type').val() == 'multi_choice'){
      answer_field = answer_field.replace(/radio/g, 'checkbox');
    }
    var obj = $(answer_field);
    obj.insertBefore(this);
    return false;
  });

  $('body').on('click', '.remove-answer-button', function(e){
    e.preventDefault();
    $(this).closest('.an-answer-container').find('input.is-delete-answer').val('true');
    $(this).closest('.an-answer-container').toggle();
  });

  $('body').on('change', '#answers-form-container input[type=radio]', function() {
    $('#answers-form-container input[type=radio]:checked').not(this).prop('checked', false);
  });

  var type = $('#js-select-question-type').val();
  if (type == 'multi_choice'){
    $('#answers-form-container input[type=radio]').prop('type', 'checkbox');
  }

  $('body').on('click', '.confirm-delete-question', function(){
    var id = $(this).attr('data-id');

    swal({
      title: 'Xác nhận xóa câu hỏi',
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
        submit_delete_question(id);
      }
      else {
        swal.close();
      }
    });
  });

  function submit_delete_question (id) {
    $.ajax({
      url: '/admin/questions/' + id,
      type: 'DELETE'
    });
  }
});

$(document).on('keypress', '#admin_question_search', function(e) {
  if(e.which == 13) {
    var value = $(this).val();
    var category = $('#category-filter-question').val();
    var user = $('#user-filter-question').val();
    var level = $('#level-filter-question').val();
    var type = $('#type-filter-question').val();
    $.ajax({
      url: '/admin/questions/',
      type: 'GET',
      data: {
        "q[content_or_answers_content_cont]": value,
        "category_id": category,
        "user_id": user,
        "level": level,
        "type": type
      }
    });
  }
});

var filterQuestion = function() {
  var value = $('#admin_question_search').val();
  var category = $('#category-filter-question').val();
  var user = $('#user-filter-question').val();
  var level = $('#level-filter-question').val();
  var type = $('#type-filter-question').val();
  $.ajax({
    url: '/admin/questions/',
    type: 'GET',
    data: {
      "q[content_or_answers_content_cont]": value,
      "category_id": category,
      "user_id": user,
      "level": level,
      "type": type
    }
  });
}

$(document).on('click', '#admin_question_search_btn', filterQuestion);
$(document).on('change','#category-filter-question', filterQuestion)
$(document).on('change','#user-filter-question', filterQuestion)
$(document).on('change','#level-filter-question', filterQuestion)
$(document).on('change','#type-filter-question', filterQuestion)
