# frozen_string_literal: true

class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: [:create]
  protect_from_forgery with: :null_session

  def create
    @answer = @question.answers.build(answer_params.merge(user_id: current_resource_owner.id))
    if @answer.save
      respond_with(@answer, location: question_answers_path(@answer, @question))
    else
      respond_with(@answer.errors.messages, status: :unprocessable_entity, location: question_answers_path(@question))
    end
  end

  def index
    respond_with load_question_answers
  end

  def show
    respond_with load_question_answers.find(params[:id])
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_question_answers
    Question.find(params['question_id']).answers
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
