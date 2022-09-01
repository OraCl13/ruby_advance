class NewMessageMailer < ApplicationMailer
  def message(sub_mail)
    @greeting = 'You have new answer for yours question'
    mail to: sub_mail, subject: 'Welcome to My Awesome Site'
  end
end
