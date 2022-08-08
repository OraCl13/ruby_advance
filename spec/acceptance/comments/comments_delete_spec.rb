# frozen_string_literal: true

require_relative '../acceptance_helper'

feature 'Create comment for question/answer', '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
' do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }
  given!(:answer) { create(:answer, reply_to: question, user_id: user.id) }
  given!(:answer_comment) { create(:comment, article_type: 'Answer', article_id: answer.id, user_id: user.id) }
  given!(:question_comment) { create(:comment, article_type: 'Question', article_id: question.id, user_id: user.id) }

  scenario 'Authenticated user delete question comment', js: true do
    sign_in(user)
    click_on 'See answers'
    within '.question_comments' do
      expect(page).to have_content 'COMMENT'
      click_on 'Destroy comment'

      expect(page).to have_no_content 'COMMENT'
    end
  end

  scenario 'Authenticated user delete answer comment', js: true do
    sign_in(user)
    click_on 'See answers'
    within '.answer_comments' do
      expect(page).to have_content 'COMMENT'
      click_on 'Destroy comment'

      expect(page).to have_no_content 'COMMENT'
    end
  end

  scenario 'Non-authenticated user delete answer/question comment', js: true do
    visit questions_path
    click_on 'See answers'
    within '.answer_comments' do
      expect(page).to have_content 'COMMENT'
      expect(page).to have_no_content 'Destroy comment'
    end

    within '.question_comments' do
      expect(page).to have_content 'COMMENT'
      expect(page).to have_no_content 'Destroy comment'
    end
  end
end
