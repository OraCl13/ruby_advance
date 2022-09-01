class MessageForAnswerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    question = case args[-1]
               when 'com_Question'
                 Comment.find(args[0]).article_id
               when 'com_Answer'
                 Answer.find(Comment.find(args[0]).article_id).reply_to.id
               else
                 Answer.find(args[0]).reply_to.id
               end
    subs = Question.find(question).subscribers
    subs.each do |subscriber_id|
      user = User.find(subscriber_id)
      NewMessageMailer.digest_question(user, question).deliver_later if user
    end
  end
end
