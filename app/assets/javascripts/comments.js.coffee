$ ->
  questionCommentsList = $(".question_comments")

  App.cable.subscriptions.create('QuestionCommentsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      questionCommentsList.append data
      $(".question_comments").load(location.href + " .question_comments");
  });

  App.cable.subscriptions.create('AnswerCommentsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      class_name = ".answer_comments_#{$.parseHTML(data)[0]['id']}"
      answerCommentsList = $(class_name)
      answerCommentsList.append data
      $(class_name).load(location.href + ' ' + class_name);
  });
