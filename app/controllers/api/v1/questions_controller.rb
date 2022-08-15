# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  protect_from_forgery with: :null_session

  def create
    @question = Question.create(question_params.merge(user_id: current_resource_owner.id))
    respond_with @question
  end

  def index
    respond_with Question.all
  end

  def show
    respond_with Question.find(params[:id])
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
