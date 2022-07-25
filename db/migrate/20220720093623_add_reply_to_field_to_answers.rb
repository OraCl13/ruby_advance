class AddReplyToFieldToAnswers < ActiveRecord::Migration
  def change
    add_belongs_to :answers, :reply_to
  end
end
