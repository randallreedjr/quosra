$(document).ready(function() {
  $('span.badge__category').on('click', function() {
    var $badge = $(this);
    if($badge.hasClass('badge-default')) {
      // activating category filter
      $badge.removeClass('badge-default');
      $badge.addClass('badge-success');
    } else {
      // removing category filter
      $badge.removeClass('badge-success');
      $badge.addClass('badge-default');
    }
    filterQuestionsByCategories();
  });
});

function filterQuestionsByCategories() {
  var categoryIds = $.map( $('.badge-success'), function(e) {
    return $(e).data('categoryId');
  });

  $.ajax({
    url: "/questions",
    type:"GET",
    data:{
      category_ids: categoryIds
    },
    dataType: 'script',
    success:function(data){
      console.log('Successfully filtered questions by categories!');
    }
  });
}
