require_relative '../acceptance_helper'

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

  scenario 'Authenticated user adds file to answer', js: true do
    fill_in 'Your answer', with: 'ANSWERANSWRR'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    within find('.new_answer') do
      click_on 'Create'
    end

    visit question_path(question)
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end
