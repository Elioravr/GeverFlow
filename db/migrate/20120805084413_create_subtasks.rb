class CreateSubtasks < ActiveRecord::Migration
  def change
    create_table :subtasks do |t|
      t.string :content
      t.integer :task_id

      t.timestamps
    end
  end
end
