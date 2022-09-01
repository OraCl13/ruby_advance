class NewMessageMailer < ApplicationMailer
  def digest_question(user, question)
    @question = question
    @greeting = 'Hi there! :D'
    mail to: user.email
  end
end
