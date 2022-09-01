class NewMessageMailer < ApplicationMailer
  def message(email)
    @greeting = 'You have new answer for yours question'
    puts 'WE ARE IN MAIL'
    mail to: email, subject: 'Welcome to My Awesome Site'
    puts 'SENDED'
  end
end
