bookmark_icon = ->
  $("#bookmark-link").click ->
    $(this).children('i').toggleClass('fa-bookmark-o')

$(document).on('page:change', bookmark_icon)