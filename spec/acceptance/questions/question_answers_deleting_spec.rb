require_relative '../acceptance_helper'

feature 'Delete question and answer', %q{
  In order to my answers and question not be deleted by another person
  As an authenticated user
  I want to be able to do it only by myself
} do

  given(:user1) { create(:user) }
  given!(:question) { create(:question, user_id: user1.id) }
  given!(:answer) { create(:answer, reply_to: question, user_id: user1.id) }
  given(:user2) { create(:user) }

  scenario 'Deleting ours questions&answers', js: true, json: true do
    sign_in(user1)
    click_on 'See answers'
    visit question_path(Question.first)

    expect(page).to have_button 'Destroy answer'
    click_on 'Destroy answer'

    expect(page).to have_no_content 'MyAnswer'
  end

  scenario 'Deleting not ours questions&answers', js: true do
    sign_in(user2)
    expect(page).to have_no_content 'Destroy question'
    expect(page).to have_no_content 'Destroy answer'
  end
end