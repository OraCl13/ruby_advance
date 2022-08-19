class AddFieldSubscribeToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :subscribers, :integer, array: true, default: []
  end
end
