$(document).on('turbolinks:load', function() {
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
  var categories = $.map( $('.badge-success'), function(element) {
    return element.innerText;
  });
  var $query = $('.input__search').val();

  $.ajax({
    url: "/questions",
    type:"GET",
    data:{
      categories: categories,
      q: $query
    },
    dataType: 'script',
    success:function(data){
      console.log('Successfully filtered questions by categories!');
    }
  });
}
