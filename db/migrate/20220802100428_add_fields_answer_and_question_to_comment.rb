class AddFieldsAnswerAndQuestionToComment < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :article_type, :string
    add_column :comments, :article_id, :integer

    # add_index :comments, :article_id
    # add_index :comments, :article_type
  end
end
