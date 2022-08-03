$ ->
  $('form.new_comment').bind 'ajax:success', (e, data, status, xhr) ->
    console.log(xhr.responseText)
    comment = $.parseJSON(xhr.responseText)
    $('.comments').append(
      '<p>' + comment.body  + '</p>',
    )