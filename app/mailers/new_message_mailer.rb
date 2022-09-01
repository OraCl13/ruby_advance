class NewMessageMailer < ApplicationMailer
  def message(email)
    @greeting = 'You have new answer for yours question'
    mail to: email, subject: 'Welcome to My Awesome Site'
  end
end
