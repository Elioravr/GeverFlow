class AddGroupByDateToColumns < ActiveRecord::Migration
  def change
    add_column :columns, :group_by_date, :boolean
  end
end
