# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  def show
    @questions = Question.all
    respond_with @questions
  end
end
