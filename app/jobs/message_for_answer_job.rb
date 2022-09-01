class MessageForAnswerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts 'WE ARE IN PERFOrM'
    puts 'x' * 1000
    question = case args[-1]
               when 'com_Question'
                 Comment.find(args[0]).article_id
               when 'com_Answer'
                 Answer.find(Comment.find(args[0]).article_id).reply_to.id
               else
                 Answer.find(args[0]).reply_to.id
               end
    puts question
    Question.find(question).subscribers.each do |subscriber_id|
      puts User.find(subscriber_id).email
      puts 'Y' *1000
      NewMessageMailer.message(User.find(subscriber_id).email).deliver_later
    end
  end
end
