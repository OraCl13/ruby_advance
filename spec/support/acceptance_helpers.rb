module AcceptanceMacros
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def create_question
    click_on 'Ask question'
    save_and_open_page
    fill_in 'Title', with: 'Title_test'
    fill_in 'Text', with: 'bodubodybody'
    click_on 'Create'
  end

  def create_answer
    fill_in 'Your answer', with: 'bodubodybody'
    save_and_open_page
    click_on 'Create'
  end
end