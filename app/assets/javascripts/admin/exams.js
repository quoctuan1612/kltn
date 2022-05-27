// var listDeleteQuestions = [];
var filterAvaiable = function(user, content){
  if(user != ''){    
    $(".avaiable-questions > div").removeClass("hidden");
    $(".avaiable-questions > div").filter(function() {
      return $(this).attr('data-user-id') != user || $(this).text().toLowerCase().indexOf(content) <= -1;
    }).addClass('hidden');
  }else {
    $(".avaiable-questions > div").removeClass("hidden");
    $(".avaiable-questions > div").filter(function() {
      return $(this).text().toLowerCase().indexOf(content) <= -1;
    }).addClass('hidden');
  }
}

var filterSelected = function(user, content){
  if(user != ''){    
    $(".selected-questions > div").removeClass("hidden");
    $(".selected-questions > div").filter(function() {
      return $(this).attr('data-user-id') != user || $(this).text().toLowerCase().indexOf(content) <= -1;
    }).addClass('hidden');
  }else {
    $(".selected-questions > div").removeClass("hidden");
    $(".selected-questions > div").filter(function() {
      return $(this).text().toLowerCase().indexOf(content) <= -1;
    }).addClass('hidden');
  }
}

$(document).on('change', '#search-avaiable-questions-by-user', function() {
  var user = $(this).val();
  var content = $('#search-avaiable-questions').val().toLowerCase();
  filterAvaiable(user, content);
})

$(document).on('keyup', '#search-avaiable-questions', function() {
  var content = $(this).val().toLowerCase();
  var user = $('#search-avaiable-questions-by-user').val();
  filterAvaiable(user, content);
});

$(document).on('change', '#search-selected-questions-by-user', function() {
  var user = $(this).val();
  var content = $('#search-selected-questions').val().toLowerCase();
  filterSelected(user, content);
})

$(document).on('keyup', '#search-selected-questions', function() {
  var content = $(this).val().toLowerCase();
  var user = $('#search-selected-questions-by-user').val();
  filterSelected(user, content);
})

$(document).on('change', '#select-category-exam', function() {
  var value = $(this).val();
  $.ajax({
    url: '/admin/exams/new',
    type: 'GET',
    data: {
      category_id: value
    },
    success: function( data ) {
      statisticQuestions();
    }
  });
});

$(document).on('turbolinks:load', function() {

  $('body').on('click', '.confirm-delete-exam', function(){
    var id = $(this).attr('data-id');

    swal({
      title: 'Xác nhận xóa đề thi',
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
      url: '/admin/exams/' + id,
      type: 'DELETE'
    });
  }

  // Validate input number
  (function($) {
    $.fn.inputFilter = function(inputFilter) {
      return this.on("input keydown keyup mousedown mouseup select contextmenu drop", function() {
        if (inputFilter(this.value)) {
          this.oldValue = this.value;
          this.oldSelectionStart = this.selectionStart;
          this.oldSelectionEnd = this.selectionEnd;
        } else if (this.hasOwnProperty("oldValue")) {
          this.value = this.oldValue;
          this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
        } else {
          this.value = "";
        }
      });
    };
  }(jQuery));

  $("#random_medium").inputFilter(function(value) {
    var hard = parseInt($('#random_hard').val()) || 0;
    var remain = 100 - hard;
    return /^\d*$/.test(value) && (value === "" || parseInt(value) <= remain); });

  $("#random_hard").inputFilter(function(value) {
    var medium = parseInt($('#random_medium').val()) || 0;
    var remain = 100 - medium;
    return /^\d*$/.test(value) && (value === "" || parseInt(value) <= remain); });

  $("#number_questions").inputFilter(function(value) {
    return /^-?\d*$/.test(value); });
  // $("#intTextBox").inputFilter(function(value) {
  //   return /^-?\d*$/.test(value); });
  // $("#uintTextBox").inputFilter(function(value) {
  //   return /^\d*$/.test(value); });


  // $("#floatTextBox").inputFilter(function(value) {
  //   return /^-?\d*[.,]?\d*$/.test(value); });
  // $("#currencyTextBox").inputFilter(function(value) {
  //   return /^-?\d*[.,]?\d{0,2}$/.test(value); });
  // $("#latinTextBox").inputFilter(function(value) {
  //   return /^[a-z]*$/i.test(value); });
  // $("#hexTextBox").inputFilter(function(value) {
  //   return /^[0-9a-f]*$/i.test(value); });
});

$(document).on('click', '#random-question-button', function() {
  if ($("#number_questions").val() == ''){
    swal('', "Bạn phải nhập số câu hỏi!");
    return;
  }
  var numberQuestions = parseInt($("#number_questions").val());
  var categoryId = $('#select-category-exam').val();
  var numberHard = Math.ceil((parseInt($('#random_hard').val())/100)*numberQuestions);
  var numberMedium = Math.ceil((parseInt($('#random_medium').val())/100)*numberQuestions);
  $.ajax({
    url: '/admin/exams/random_questions',
    data: {
      category_id: categoryId,
      total_request: numberQuestions,
      hard_request: numberHard,
      medium_request: numberMedium
    },
    beforeSend: function( xhr ) {
      $('#loading-modal').show();
      $('#page-container').addClass('loading');
      $('#search-selected-questions-by-user').val('');
      $('#search-selected-questions-by-user').trigger('change');
      $('#search-avaiable-questions-by-user').val('');
      $('#search-avaiable-questions-by-user').trigger('change');
      $('#search-selected-questions').val('');
      $('#search-selected-questions').trigger('keyup');
      $('#search-avaiable-questions').val('');
      $('#search-avaiable-questions').trigger('keyup');
      $('.selected-questions > div').each(function() {
        $('.avaiable-questions').append($(this))
        $('.selected-questions').remove($(this))
        // listDeleteQuestions.push($(this).data('id'));
        $('.avaiable-questions-count').html(parseInt($('.avaiable-questions-count').html()) + 1);
        $('.selected-questions-count').html(parseInt($('.selected-questions-count').html()) - 1);
      });
    },
    success: function( data ) {
      $('#loading-modal').hide();
      $('#page-container').removeClass('loading');
      if (data.data.error_total){
        swal('', "Số lượng câu hỏi trong danh mục không đủ!");
      } else if(data.data.error_hard){
        swal('', "Số lượng câu hỏi mức khó không đủ!");
      } else if (data.data.error_medium){
        swal('', "Số lượng câu hỏi mức trung bình không đủ!");
      } else if (data.data.error_easy){
        swal('', "Số lượng câu hỏi mức dễ không đủ!");
      } else if (data.data.error_easy_medium){
        swal('', "Số lượng câu hỏi mức dễ và trung bình không đủ!");
      } else if (data.data.error_easy_hard){
        swal('', "Số lượng câu hỏi mức dễ và khó không đủ!");
      } else {
        $('.avaiable-questions > div').each(function() {
          if (jQuery.inArray(parseInt($(this).attr('data-question-id')), data.data.selected_questions_id) !== -1){
            $('.selected-questions').append($(this))
            $('.avaiable-questions').remove($(this))
            // listDeleteQuestions.splice( listDeleteQuestions.indexOf($(this).data('id')), 1 );
            $('.avaiable-questions-count').html(parseInt($('.avaiable-questions-count').html()) - 1);
            $('.selected-questions-count').html(parseInt($('.selected-questions-count').html()) + 1);
          }
        });
      }
      statisticQuestions();
    },
    error: function( error ) {
      swal('', error);
    }
  });
})

$(document).on('click', '#reset-question-button', function() {
  $("#number_questions").val('');
  $('#random_hard').val('');
  $('#random_medium').val('');
  $('.selected-questions > div').each(function() {
    $('.avaiable-questions').append($(this))
    $('.selected-questions').remove($(this))
    // listDeleteQuestions.push($(this).data('id'));
    $('.avaiable-questions-count').html(parseInt($('.avaiable-questions-count').html()) + 1);
    $('.selected-questions-count').html(parseInt($('.selected-questions-count').html()) - 1);
  });
  statisticQuestions();
})

$(document).on('click' ,'#submit-exam-btn', function() {
  $(this).attr('disabled', true);
  var form = $(this).closest('#exam-form');
  var url = form.attr('action');
  var type = form.find('input[name="_method"]').val() || form.attr('method');

  var categoryId = $('#select-category-exam').val();
  var title = $('#exam_title').val();
  var duration = parseInt($('#exam_duration').val(), 10)*60;
  var resultPass = $('#exam_result_pass').val();
  var maxTimes = $('#exam_max_number_of_times').val();
  var userId = $('#exam_user_id').val();
  var isShowDetailResult = $('#exam_is_show_detail_result').is(":checked");
  var password = $('#exam_password').val();

  var exam_questions_attributes = {}
  
  $('.selected-questions .block-question').each(function(index){
    exam_questions_attributes[index] = {"id": $(this).data('id'), "question_id": $(this).data('question-id')}
  });

  var number_questions_selected = Object.keys(exam_questions_attributes).length;

  $('.avaiable-questions .remove-exam').each(function(index){
    exam_questions_attributes[index + number_questions_selected] = {"id": $(this).data('id'), "_destroy": true}
  });

  $.ajax({
    url: url,
    type: type,
    data: {
      "exam[user_id]": userId,
      "exam[category_id]": categoryId,
      "exam[title]": title,
      "exam[duration]": duration,
      "exam[result_pass]": resultPass,
      "exam[max_number_of_times]":maxTimes,
      "exam[is_show_detail_result]": isShowDetailResult,
      "exam[password]": password,
      "exam[exam_questions_attributes]": exam_questions_attributes
    }
  });
});
$(document).on('click', '.block-question', function() {
  if ($(this).parent('.avaiable-questions').length){
    $('.selected-questions').append($(this))
    $('.avaiable-questions').remove($(this))
    // listDeleteQuestions.splice( listDeleteQuestions.indexOf($(this).data('id')), 1 );
    $('.avaiable-questions-count').html(parseInt($('.avaiable-questions-count').html()) - 1);
    $('.selected-questions-count').html(parseInt($('.selected-questions-count').html()) + 1);
  }
  else if ($(this).parent('.selected-questions').length){
    $('.avaiable-questions').append($(this))
    $('.selected-questions').remove($(this))
    // listDeleteQuestions.push($(this).data('id'));
    $('.avaiable-questions-count').html(parseInt($('.avaiable-questions-count').html()) + 1);
    $('.selected-questions-count').html(parseInt($('.selected-questions-count').html()) - 1);
  }
  statisticQuestions();
});

var statisticQuestions = function() {
  var selectedQuestions = parseInt($('.selected-questions-count').html());
  var easyQuestions = $('.selected-questions .easy-question').length;
  var mediumQuestions = $('.selected-questions .medium-question').length;
  var hardQuestions = $('.selected-questions .hard-question').length;
  $('.exam-form-hard-count').html(hardQuestions);
  $('.exam-form-medium-count').html(mediumQuestions);
  $('.exam-form-easy-count').html(easyQuestions);
  if (selectedQuestions == 0) {
    $('.exam-form-easy-percent').html('0%');
    $('.exam-form-medium-percent').html('0%');
    $('.exam-form-hard-percent').html('0%');
  } else {
    $('.exam-form-easy-percent').html(Math.round((easyQuestions/selectedQuestions)*100) + '%');
    $('.exam-form-medium-percent').html(Math.round((mediumQuestions/selectedQuestions)*100) + '%');
    $('.exam-form-hard-percent').html(Math.round((hardQuestions/selectedQuestions)*100) + '%');
  }
}

$(document).on('keypress', '#admin_exam_search', function(e) {
  if(e.which == 13) {
    var value = $(this).val();
    var category = $('#category-filter-exam').val();
    var user = $('#user-filter-exam').val();
    $.ajax({
      url: '/admin/exams',
      type: 'GET',
      data: {
        "q[title_or_category_name_cont]": value,
        "category_id": category,
        "user_id": user
      }
    });
  }
});

var filterExam = function() {
  var value = $('#admin_exam_search').val();
  var category = $('#category-filter-exam').val();
  var user = $('#user-filter-exam').val();
  $.ajax({
    url: '/admin/exams',
    type: 'GET',
    data: {
      "q[title_or_category_name_cont]": value,
      "category_id": category,
      "user_id": user
    }
  });
}

$(document).on('click', '#admin_exam_search_btn', filterExam);
$(document).on('change', '#category-filter-exam', filterExam);
$(document).on('change', '#user-filter-exam', filterExam);

$(document).on('click', '.block-question-cannot-change', function() {
  swal({
    title: 'Không thể thay đổi câu hỏi vì đã có người làm đề thi!',
    icon: 'warning',
    buttons: {
      confirm: {
        text: 'Đồng ý',
        value: true,
        visible: true,
      }
    },
  })
});

var filterAttemptInExam = function() {
  var status = $('#filter-status-attempts-in-exam').val();
  var result = $('#filter-result-attempts-in-exam').val();
  var exam_id = $('#exam_id').val();
  var nameOrEmail = $('#search-users-attempt-in-exam').val();
  $.ajax({
    url: '/admin/exams/' + exam_id + '/attempts_in_exam',
    type: 'GET',
    data: {
      status: status,
      result: result,
      "q[user_email_or_user_user_name_cont]": nameOrEmail
    }
  });
}

$(document).on('change', '#filter-status-attempts-in-exam', function() {
  filterAttemptInExam();
});

$(document).on('change', '#filter-result-attempts-in-exam', function() {
  filterAttemptInExam();
});

$(document).on('keypress', '#search-users-attempt-in-exam', function(e) {
  if(e.which == 13) {
    filterAttemptInExam();
  }
});

$(document).on('click', '#search-users-attempt-in-exam-btn', function() {
  filterAttemptInExam();
});

$(document).on('click', '.delete-attempt', function() {
  var id = $(this).data('id');
  swal({
    title: 'Xác nhận xóa kết quả',
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
      $.ajax({
        url: '/admin/attempts/' + id,
        type: 'DELETE'
      });
    }
    else {
      swal.close();
    }
  });
});
