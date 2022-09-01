class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :load_question_by_question_id, only: %i[subscribe cancel_subscrition]
  before_action :build_answer, only: %i[show]
  after_action :publish_question, only: [:create]
  protect_from_forgery except: :update
  authorize_resource
  check_authorization

  def index
    respond_with(@questions = Question.all)
  end

  def show; end

  def new
    respond_with(@question = Question.new)
  end

  def edit; end

  def create
    respond_with(@question = Question.create(question_params.merge(user_id: current_user.id, subscribers: [current_user.id])))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy
  end

  def subscribe
    return unless current_user

    return if @question.subscribers.include? current_user.id

    @question.subscribers += [current_user.id]
    @question.save
  end

  def cancel_subscrition
    return unless current_user

    return unless @question.subscribers.include? current_user.id

    @question.subscribers -= [current_user.id]
    @question.save
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def load_question_by_question_id
    @question = Question.find(params[:question_id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def interpolation_options
    { resource_name: 'New awesome question', time: @question.created_at, user: current_user.email }
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast 'questions',
                                 ApplicationController.render(
                                   partial: 'questions/question',
                                   locals: { question: @question, user: current_user }
                                 )
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
