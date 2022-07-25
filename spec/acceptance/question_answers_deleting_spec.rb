require_relative 'acceptance_helper'

feature 'Delete question and answer', %q{
  In order to my answers and question not be deleted by another person
  As an authenticated user
  I want to be able to do it only by myself
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }

  scenario 'Deleting ours questions&answers', js: true do # save_and_open_page
    sign_in(user1)

    create_question
    create_answer

    expect(page).to have_content 'Title_test'
    expect(page).to have_content 'bodubodybody'

    click_on 'Destroy answer'
    expect(page).to have_content 'Your answer successfully deleted.'

    visit questions_path

    click_on 'Destroy question'
    expect(page).to have_content 'Your question successfully deleted.'
  end

  scenario 'Deleting not ours questions&answers', js: true do
    sign_in(user1)
    create_question
    create_answer

    click_on 'Вихід'

    sign_in(user2)
    expect(page).to have_no_content 'Destroy question'
    expect(page).to have_no_content 'Destroy answer'
  end
end