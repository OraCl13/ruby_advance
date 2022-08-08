$ ->
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
