require_relative '../acceptance_helper'

feature 'Create Answer', %q{
  In order to get info from community
  As an authenticated users
  They want to be able to give answers
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user create answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'
    within find('.new_answer') do
      click_on 'Create'
    end

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'My answer'
    end
  end

  scenario 'User try to create invalid answer', js: true do
    sign_in(user)
    visit question_path(question)
    within find('.new_answer') do
      click_on 'Create'
    end
    expect(page).to have_content "Body can't be blank"
  end
end