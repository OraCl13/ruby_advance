require_relative '../acceptance_helper'

feature 'Sign in via facebook', %q{
 In order to be able to ask question
 As an user
 I want to be able to register myself
 as quickly as possible
} do

  given(:user) { create(:user) }

  before do
    OmniAuth.config.add_mock(:facebook, {:uid => '12345', :email => 'abbb@ccc.cp'})
  end

  scenario 'Registered user try to sign in' do
    visit new_user_session_url
    click_on 'Sign in with Facebook'
    save_and_open_page
  end
end
