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

  questionCommentsList = $(".question_comments")

  App.cable.subscriptions.create('QuestionCommentsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      questionCommentsList.append data
  });

  App.cable.subscriptions.create('AnswerCommentsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      answerCommentsList = $(".answer_comments_#{$.parseHTML(data)[0]['id']}")
      answerCommentsList.append data
  });
