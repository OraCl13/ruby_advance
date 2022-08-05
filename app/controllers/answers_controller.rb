class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update, :cancel_choice, :position_edit]
  after_action :publish_answer, only: [:create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @answer.save
        format.html { render partial: 'questions/answers', layout: false }
        format.json { render json: [@answer, @answer.attachments] }
      else
        format.html { render plain: @answer.errors.full_messages.join("\n"), status: :unprocessable_entity }
        format.json { render plain: @answer.errors.full_messages, status: :unprocessable_entity }
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

  def position_edit
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:answer_id])

    @question.answers.each do |answer|
      if (answer.pos_answers_users + answer.neg_answers_users).include? current_user.id
        respond_to do |format|
          format.html { render text: 'You already made choice', status: :not_acceptable }
          format.json { render text: ['You already made choice'], status: :not_acceptable }
        end
        return
      end
    end
    @answer.pos_answers_users += [current_user.id] if params[:choice] == 'Like'
    @answer.neg_answers_users += [current_user.id] if params[:choice] == 'Dislike'

    @answer.save
  end

  def cancel_choice
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:answer_id])
    contains_user = false

    if params[:cancel]
      @question.answers.each do |answer|
        if answer.pos_answers_users.include? current_user.id
          puts ''
          answer.pos_answers_users -= [current_user.id]
          answer.save
          contains_user = true
          break
        elsif answer.neg_answers_users.include? current_user.id
          answer.neg_answers_users -= [current_user.id]
          answer.save
          contains_user = true
          break
        end
      end

      unless contains_user
        respond_to do |format|
          format.html { render text: 'You dont make choice', status: :not_acceptable }
          format.json { render text: ['You dont make choice(json)'], status: :not_acceptable }
        end
      end
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
                                             question: @answer.reply_to }) # Answer.order("created_at").last
  end

  def answer_params
    params.require(:answer).permit(:good, :bad, :cancel, :body, attachments_attributes: [:file, :_destroy])
  end
end
