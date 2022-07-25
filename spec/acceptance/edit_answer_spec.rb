require_relative 'acceptance_helper'

feature 'Answer editing', %q{
 In order to be able to edit your own answers
 As an author of answer
 I want to be able to edit it
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, reply_to: question) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'

  end
  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      create_question
      create_answer
    end
    scenario ' sees link to edit his answer' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Edit'
      fill_in 'Answer', with: 'edited answer'
      expect(page).to_not have_content answer.body
    end

    scenario ' try to edit other users question' do

    end
  end
end