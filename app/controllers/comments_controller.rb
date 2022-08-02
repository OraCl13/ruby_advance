class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    puts 'z'*400
    if params[:question_id]
      @question = Question.find(params[:question_id])
      @comment = @question.comments.create(comment_params)
      puts 'y'*300
    else
      @answer = Answer.find(params[:answer_id])
      @comment = @answer.comments.create(comment_params)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :article_id, :article_type)
  end
end
