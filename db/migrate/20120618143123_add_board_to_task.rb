class AddBoardToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :board_id, :integer
    add_index :tasks, :board_id
  end
end
