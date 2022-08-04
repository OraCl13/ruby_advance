class AnswerCommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "answer_comments"
  end
end
