class MessageForAnswerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    question = case args[-1]
               when 'com_Question'
                 Comment.find(args[0]).article_id
               when 'com_Answer'
                 Answer.find(Comment.find(args[0]).article_id).reply_to
               else
                 Answer.find(args[0]).reply_to
               end
    Question.find(question).subscribers.each do |subscriber_id|
      NewMessageMailer.message(User.find(subscriber_id).email).deliver_later
    end
  end
end
