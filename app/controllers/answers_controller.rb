class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :destroy ]
  # before_action :load_question, only: [ :new, :create ]
  # before_action :load_answer, only: [ :edit, :update, :destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.reply_to
    flash[:notice] = 'Your answer successfully updated.'
  end

  def destroy
    flash[:notice] = 'Your answer successfully deleted.'
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
    @answer.destroy
  end

  def make_best
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:answer_id])

    @question.answers.update_all(best_answer: false)
    @answer.update(best_answer: true)

    flash[:notice] = 'You choose best answer'
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
