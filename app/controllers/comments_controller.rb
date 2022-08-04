class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :find_question, only: %i[ create publish_comment ]
  before_action :find_answer, only: %i[ create ]
  after_action :publish_comment, only: [:create]

  def create
    if comment_params[:is_question] == 'true'
      @comment = @question.comments.build(comment_params.except!(:is_question).merge(user_id: current_user.id))
    else
      @comment = @answer.comments.build(comment_params.except!(:is_question).merge(user_id: current_user.id))
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

  def destroy
    @comment = Comment.find(params[:id]) if params[:answer_comment_destroy]
    @comment = Comment.find(params[:id]) if params[:question_comment_destroy]
    @comment.destroy

    respond_to do |format|
      format.html { render partial: 'questions/answers', layout: false }
      format.js
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id]) if params[:question_id]
  end

  def find_answer
    @answer = Answer.find(params[:answer_id]) if params[:answer_id]
  end

  def publish_comment
    return if @comment.errors.any?
    if @comment.article_type == 'Question'
      ActionCable.server.broadcast 'question_comments',
                                   ApplicationController.render(
                                     partial: 'questions/comments',
                                     locals: { question: @question,
                                               answer: @comment.article_id,
                                               comment: @comment,
                                               user: current_user})
    else
      ActionCable.server.broadcast 'answer_comments',
                                   ApplicationController.render(
                                     partial: 'questions/comments',
                                     locals: { question: @question,
                                               answer: @comment.article_id,
                                               comment: @comment,
                                               user: current_user })
    end
  end

  def comment_params
    params.require(:comment).permit(:body, :article_id, :article_type, :is_question)
  end
end
