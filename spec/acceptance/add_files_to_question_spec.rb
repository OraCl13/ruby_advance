require_relative 'acceptance_helper'

feature 'Add files to quesiton', %q{
  In order to show question 
  As author
  Id like to be able to touch file
} do
  given(:user) { create(:user) }
  
  background do
    sign_in(user)
    visit new_question_path
  end


  scenario 'Authenticated user adds file to qeustion' do # save_and_open_page
    fill_in 'Title', with: 'Title_test'
    fill_in 'Text', with: 'bodubodybody'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end
