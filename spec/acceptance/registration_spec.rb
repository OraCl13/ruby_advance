require_relative 'acceptance_helper'

feature 'User register', %q{
 In order to be able to ask question
 As an user
 I want to be able to register myself
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign in' do # save_and_open_page
    visit new_user_session_path

    click_on 'Sign up'

    fill_in 'Email', with: 'register@test.com'
    fill_in 'Password', with: '87654321'
    fill_in 'Password confirmation', with: '87654321'
    click_on 'Sign up'

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
  end

  scenario 'Registration with invalid email' do
    visit new_user_session_path
    click_on 'Sign up'

    fill_in 'Email', with: 'register'
    fill_in 'Password', with: '87654321'
    fill_in 'Password confirmation', with: '87654321'
    click_on 'Sign up'

    expect(page).to have_content 'Email is invalid'
  end

  scenario 'Registration with invalid password verefication' do
    visit new_user_session_path
    click_on 'Sign up'

    fill_in 'Email', with: 'register@test.com'
    fill_in 'Password', with: '87654321'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'Registration with invalid short password' do
    visit new_user_session_path
    click_on 'Sign up'

    fill_in 'Email', with: 'register@test.com'
    fill_in 'Password', with: '1'
    fill_in 'Password confirmation', with: '1'
    click_on 'Sign up'

    expect(page).to have_content 'Password is too short (minimum is 6 characters)'
  end
end