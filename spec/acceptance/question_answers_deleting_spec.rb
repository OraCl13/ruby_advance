require_relative 'acceptance_helper'

feature 'Delete question and answer', %q{
  In order to my answers and question not be deleted by another person
  As an authenticated user
  I want to be able to do it only by myself
} do

  given(:user1) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, reply_to: question) }
  given(:user2) { create(:user) }

  scenario 'Deleting ours questions&answers', js: true do # save_and_open_page
    sign_in(user1)
    create_question
    create_answer

    visit question_path(Question.first)

    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText' # TODO
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