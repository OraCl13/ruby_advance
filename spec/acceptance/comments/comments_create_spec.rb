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

  scenario 'Authenticated user creates comment for question', js: true do
    sign_in(user)
    click_on 'See answers'
    within '.new_comment' do
      fill_in '.', with: 'QUESTION_COMMENT'
      click_on 'Create'
    end
    visit question_path(question)
    expect(page).to have_content 'QUESTION_COMMENT'
  end

  scenario 'Authenticated user creates comment for answer', js: true do
    sign_in(user)
    click_on 'See answers'
    within '.new_answer_comment' do
      fill_in '.', with: 'ANSWER_COMMENT'
      click_on 'Create'
    end
    expect(page).to have_content 'ANSWER_COMMENT'
  end

  scenario 'Non-Authenticated user creates comment for answer/question', js: true do
    visit questions_path
    click_on 'See answers'
    within '.new_answer_comment' do
      expect(page).to have_no_content 'Create'
    end

    within '.new_comment' do
      expect(page).to have_no_content 'Create'
    end
  end
end
