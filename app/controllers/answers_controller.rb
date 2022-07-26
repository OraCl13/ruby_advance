class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy update cancel_choice position_edit]
  after_action :publish_answer, only: [:create]
  before_action :load_answer, only: %i[update destroy]
  before_action :load_question, only: %i[create destroy position_edit cancel_choice]
  before_action :load_answer_by_answer_id, only: %i[position_edit cancel_choice]
  authorize_resource
  check_authorization

  def create
    @answer = @question.answers.build(answer_params.merge(user_id: current_user.id))
    respond_to do |format|
      if @answer.save
        format.html { render partial: 'questions/answers', layout: false }
        format.json { render json: @answer.attachments.nil? ? [@answer, @answer.attachments] : [@answer] }
      else
        format.html { render plain: @answer.errors.full_messages.join("\n"), status: :unprocessable_entity }
        format.json { render plain: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    @answer.update(answer_params)
    @question = @answer.reply_to
  end

  def destroy
    @answer.destroy
  end

  def position_edit
    @question.answers.each do |answer|
      next unless (answer.pos_answers_users + answer.neg_answers_users).include? current_user.id

      respond_to do |format|
        format.html { render text: 'You already made choice', status: :not_acceptable }
        format.json { render text: ['You already made choice'], status: :not_acceptable }
      end
      return
    end
    @answer.pos_answers_users += [current_user.id] if params[:choice] == 'Like'
    @answer.neg_answers_users += [current_user.id] if params[:choice] == 'Dislike'
    @answer.save
  end

  def cancel_choice
    return unless params[:cancel]

    @question.answers.each do |answer|
      next unless answer.pos_answers_users.include?(current_user.id) || answer.neg_answers_users.include?(current_user.id)

      answer.pos_answers_users -= [current_user.id] if answer.pos_answers_users.include? current_user.id
      answer.neg_answers_users -= [current_user.id] if answer.neg_answers_users.include? current_user.id
      answer.save
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast 'answers',
                                 ApplicationController.render(
                                   partial: 'questions/answer',
                                   locals: { user: current_user,
                                             answer: @answer,
                                             question: @answer.reply_to }
                                 )
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer_by_answer_id
    @answer = Answer.find(params[:answer_id])
  end

  def interpolation_options
    { resource_name: 'New awesome answer', time: @answer.created_at, user: current_user.email }
  end

  def answer_params
    params.require(:answer).permit(:good, :bad, :cancel, :body, attachments_attributes: %i[file _destroy])
  end
end
