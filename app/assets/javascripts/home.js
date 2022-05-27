$(document).on('change', '#select-exam-id', function(){
  var category_id = $('#select-exam-id option:selected').attr('data-category-id');
  $('#select-category-id').val(category_id).trigger('change');
});

$(document).on('change', '#select-category-id', function() {
  var category_id = $(this).val();

  $('#select-exam-id option[data-category-id!="' + category_id + '"]').attr('disabled', 'disabled');
  $('#select-exam-id option[data-category-id="' + category_id + '"]').removeAttr('disabled');
  $('#select-exam-id option').first().removeAttr('disabled');

  if(category_id == '') {
    $('#select-exam-id option').removeAttr('disabled');
  }

  var exam_category_id = $('#select-exam-id option:selected').attr('data-category-id');

  if(exam_category_id != category_id && exam_category_id) {
    $('#select-exam-id').val(null).trigger('change.select2');
  }
})

$(document).on('change', '#filter-exam-id', function(){
  var category_id = $('#filter-exam-id option:selected').attr('data-category-id');
  $('#filter-category-id').val(category_id).trigger('change');
  if ($(this).val() == ''){
    filterAttempt();
  }
});

$(document).on('change', '#filter-category-id', function() {
  var category_id = $(this).val();

  $('#filter-exam-id option[data-category-id!="' + category_id + '"]').attr('disabled', 'disabled');
  $('#filter-exam-id option[data-category-id="' + category_id + '"]').removeAttr('disabled');
  $('#filter-exam-id option').first().removeAttr('disabled');

  if(category_id == '') {
    $('#filter-exam-id option').removeAttr('disabled');
  }

  var exam_category_id = $('#filter-exam-id option:selected').attr('data-category-id');

  if(exam_category_id != category_id && exam_category_id) {
    $('#filter-exam-id').val(null).trigger('change.select2');
  }
  filterAttempt();
})

$(document).on('change', '#filter-status', function(){
  filterAttempt();
})

$(document).on('change', '#filter-result', function(){
  filterAttempt();
})

var filterAttempt = function() {
  var categoryId = $('#filter-category-id').val();
  var examId = $('#filter-exam-id').val();
  var status = $('#filter-status').val();
  var result = $('#filter-result').val();
  $.ajax({
    url: '/',
    type: 'GET',
    data: {
      category_id: categoryId,
      exam_id: examId,
      status: status,
      result: result
    }
  });
}

$(document).on('click', "#do-exam-btn", function() {
  var examId = $('#select-exam-id').val();
  if (examId == ''){
    $('#form-do-exam').submit();
    return;
  }
  $.ajax({
    url: '/attempts/check_any_pending',
    type: 'GET',
    data: {
      exam_id: examId
    },
    success: function( data ) {
      if (data.data.have_pending){
        swal({
          title: 'Bạn chưa hoàn thành bài thi này, hoàn thành bài thi ngay?',
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
            window.location.replace("/attempts/" + data.data.pending_attempt_id)
          }
          else {
            swal.close();
          }
        });
      } else {
        $('#form-do-exam').submit();
      }
    },
    error: function( error ) {
      swal('', error);
    }
  });
})
