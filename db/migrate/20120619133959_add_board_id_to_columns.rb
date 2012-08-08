class AddBoardIdToColumns < ActiveRecord::Migration
  def change
    add_column :columns, :board_id, :integer
  end
end
