$ ->
  $('form.new_comment').bind 'ajax:success', (e, data, status, xhr) ->
    comment = $.parseJSON(xhr.responseText)
    $('.question_comments').append(
      '<p>' + comment.body  + '</p>',
    )

  $('form.new_answer_comment').bind 'ajax:success', (e, data, status, xhr) ->
    comment = $.parseJSON(xhr.responseText)
    $(".answer_comments_#{comment.article_id}").append(
      '<p>' + comment.body  + '</p>',
    )