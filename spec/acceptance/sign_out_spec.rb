require_relative 'acceptance_helper'

feature 'User sign_out', %q{
 In order to be able to not show his identity
 As an user
 I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user try to sign out' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    click_on 'Вихід'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unauthenticated user try to sign out' do
    visit root_path
    expect(page).to have_no_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

end