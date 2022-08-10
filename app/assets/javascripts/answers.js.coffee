$(document).on 'turbolinks:load', ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show();
$ ->
  $('form.change_pos').bind 'ajax:error', (e, xhr, status, error) ->
    alert(xhr.responseText);

  $('form.new_answer').bind 'ajax:error', (e, xhr, status, error) ->
    $('.answer-errors').append(xhr['responseJSON'][0])

  answersList = $(".answers")
  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      answersList.append data
      $(".answers").load(location.href + " .answers");
  });

$(document).ready(ready)
$(document).page('page:load', ready)
