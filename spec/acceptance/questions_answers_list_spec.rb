require 'rails_helper'

feature 'See questions and answers', %q{
 In order to be able to see questions and answers
 As an user or guest
 I want to be able to see it
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to see list of questions&answers' do # save_and_open_page
    sign_in(user)

    expect(page).to have_content 'Questions'
    expect(page).to have_content 'Ask question'

    create_question

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Your answer'
  end

  scenario 'Non-Registered user try to see list of questions' do # save_and_open_page
    visit root_path
    expect(page).to have_content 'Questions'
    expect(page).to have_content 'Ask question'

    sign_in(user)
    create_question
    click_on 'Вихід'

    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end