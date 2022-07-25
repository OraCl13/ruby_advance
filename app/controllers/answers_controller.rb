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
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
    @answer.destroy

    flash[:notice] = 'Your answer successfully deleted.'
    redirect_to question_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
