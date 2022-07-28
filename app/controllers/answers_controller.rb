class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update, :cancel_choice]
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

  def position_edit
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:answer_id])

    flag = true
    @question.answers.each do |answer|
      if (answer.pos_answers_users + answer.neg_answers_users).include? current_user.id
        flag = false
        puts 'There are already your choice. Touch cancel to decline previous changes'
      end
    end
    if params[:good] && flag
      @answer.pos_answers_users += [current_user.id]
      puts @answer.body
      puts 'Choosed good' * 30
    elsif params[:bad] && flag
      @answer.neg_answers_users += [current_user.id]
      puts 'Choosed bad' * 30
    end
    @answer.save
  end

  def cancel_choice
    @question = Question.find(params[:question_id])
    flag = false
    if params[:cancel]
      @question.answers.each do |answer|
        if answer.pos_answers_users.include? current_user.id
          answer.pos_answers_users -= [current_user.id]
          answer.save
          flag = true
          break
        elsif answer.neg_answers_users.include? current_user.id
          answer.neg_answers_users -= [current_user.id]
          answer.save
          flag = true
          break
        end
      end
      unless flag
        puts 'There are no' * 30
        respond_to do |format|
          format.html { render text: 'You dont make choice', status: :not_acceptable }
          format.json { render text: ['You dont make choice'], status: :not_acceptable }
        end
      end
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:good, :bad, :cancel, :body, attachments_attributes: [:file, :_destroy])
  end
end
