require_relative '../acceptance_helper'

feature 'Answer editing', %q{
 In order to be able to edit your own answers
 As an author of answer
 I want to be able to edit it
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }
  given!(:answer) { create(:answer, reply_to: question, user_id: user.id) }
  given(:user2) { create(:user) }

  scenario 'Unauthenticated user try to edit question' do
    visit questions_path
    click_on 'See answers'

    expect(page).to_not have_link 'Edit'
  end
  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit questions_path
      click_on 'See answers'
    end
    scenario ' sees link to edit his answer' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Edit'
      fill_in 'Answer', with: 'edited answer'
      click_on 'Save' # TODO

      expect(page).to_not have_content 'MyText'
    end

    scenario ' try to edit other users question' do
      visit questions_path
      sign_in(user2)
      expect(page).to have_no_link 'Edit'
    end
  end
end