require_relative '../acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)
    create_question

    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Authenticated user creates question with wrong params' do
    sign_in(user)
    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Text', with: ''
    click_on 'Create'

    expect(page).to have_content 'Your question wasnt created'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end