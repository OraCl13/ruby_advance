class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    if params[:question_id]
      @question = Question.find(params[:question_id])
      @comment = @question.comments.build(comment_params)
    else
      @answer = Answer.find(params[:answer_id])
      @comment = @answer.comments.build(comment_params)
    end

    respond_to do |format|
      if @comment.save
        format.html { render partial: 'questions/answers', layout: false }
        format.json { render json: @comment }
      else
        format.html { render plain: @comment.errors.full_messages.join("\n"), status: :unprocessable_entity }
        format.json { render plain: @comment.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :article_id, :article_type)
  end
end
