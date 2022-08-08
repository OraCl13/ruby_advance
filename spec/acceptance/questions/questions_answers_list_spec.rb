require_relative '../acceptance_helper'

feature 'See questions and answers', %q{
 In order to be able to see questions and answers
 As an user or guest
 I want to be able to see it
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }

  scenario 'Registered user try to see list of questions&answers' do # save_and_open_page
    sign_in(user)

    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
    expect(page).to have_content 'Files:'
  end

  scenario 'Non-Registered user try to see list of questions' do # save_and_open_page
    visit root_path
    expect(page).to have_content 'Questions'
    expect(page).to have_content 'Ask question'

    sign_in(user)

    click_on 'Exit'

    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end