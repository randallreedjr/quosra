$(document).ready(function() {
  $('input.checkbox__category').on('click', function() {
    let categoryId = $(this).val();
    let questionId = $(this).data('questionId');
    let checked = $(this).prop('checked');
    setCategory(questionId, categoryId, checked);
  });
});

function setCategory(questionId, categoryId, checked) {
  if(checked) {
    $.ajax({
      url: "/category_questions",
      type:"POST",
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data:{
        question_id: questionId,
        category_id: categoryId
      },
      success:function(data){
        console.log('Successfully added category to question!');
      }
    });
  } else {
    $.ajax({
      url: "/category_questions/" + questionId,
      type:"DELETE",
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data:{
        question_id: questionId,
        category_id: categoryId
      },
      success:function(data){
        console.log('Successfully deleted category from question!');
      }
    });
  }
}
