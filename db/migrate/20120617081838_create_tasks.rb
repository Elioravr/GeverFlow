class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.integer :time_spent
      t.integer :time_estimated
      t.integer :user_id
      t.integer :tag_id
      t.integer :subtask_id
      t.integer :comment_id

      t.timestamps
    end
  end
end
