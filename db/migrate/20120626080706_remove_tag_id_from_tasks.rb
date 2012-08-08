class RemoveTagIdFromTasks < ActiveRecord::Migration
  def up
    remove_column :tasks, :tag_id
  end

  def down
    remove_column :tasks, :tag_id, :integer
  end
end
