class ChangeTasksBoardIdToColumnId < ActiveRecord::Migration
  def up
    remove_column :tasks, :board_id
    add_column :tasks, :column_id, :integer
    add_index :tasks, :column_id
  end
end
