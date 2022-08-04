$ ->
  answersList = $(".answers")
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show();
    console.log(111)

  $('form.cancel').bind 'ajax:error', (e, xhr, status, error) ->
    $('.position-answers-errors').append(xhr.responseText)

  $('form.change_pos').bind 'ajax:error', (e, xhr, status, error) ->
    $('.position-answers-errors').append(xhr.responseText)

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      answersList.append data
  });
