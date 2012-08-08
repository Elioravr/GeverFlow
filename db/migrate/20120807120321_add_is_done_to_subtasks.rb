class AddIsDoneToSubtasks < ActiveRecord::Migration
  def change
    add_column :subtasks, :is_done, :boolean
  end
end
