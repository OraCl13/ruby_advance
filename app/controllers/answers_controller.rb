class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  # before_action :load_question, only: [ :new, :create ]
  # before_action :load_answer, only: [ :edit, :update, :destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @answer.save
        format.html { render partial: 'questions/answers', layout: false }
        format.json { render json: @answer }
      else
        format.html { render text: @answer.errors.full_messages.join("\n"), status: :unprocessable_entity }
        format.json { render text: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.reply_to
  end

  def destroy
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
    @answer.destroy
  end

  def make_best
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:answer_id])

    @question.answers.update_all(best_answer: false)
    @answer.update(best_answer: true)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :_destroy])
  end
end
