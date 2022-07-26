require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to show answer
  As user
  Id like to be able to touch file
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  
  background do
    sign_in(user)
    visit question_path(question)
  end


  scenario 'Authenticated user adds file to answer', js: true do # save_and_open_page
    fill_in 'Your answer', with: 'ANSWERANSWRR'# TODO
    save_and_open_page
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'
    # save_and_open_page
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end
