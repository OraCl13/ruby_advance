class RemoveBestAnswerAndAddStatToAnswer < ActiveRecord::Migration
  def change
    # remove_column :answers, :best_answer

    add_column :answers, :pos_answers_users, :integer, array: true, default: []
    add_column :answers, :neg_answers_users, :integer, array: true, default: []
  end
end
