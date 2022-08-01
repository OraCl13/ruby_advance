$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show();

  $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('.answers').append(
      '<p>Rate</p>',
      '<strong>'+"#{answer.pos_answers_users.length}/#{answer.neg_answers_users.length}" + '</strong>',
      '<p>Body</p>',
      '<p>' + answer.body + '</p>')
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index,value) ->
      $('.answer-errors').append(value)

  $('form.cancel').bind 'ajax:error', (e, xhr, status, error) ->
    $('.position-answers-errors').append(xhr.responseText)

  $('form.change_pos').bind 'ajax:error', (e, xhr, status, error) ->
    $('.position-answers-errors').append(xhr.responseText)

