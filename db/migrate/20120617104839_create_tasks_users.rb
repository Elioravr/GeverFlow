class CreateTasksUsers < ActiveRecord::Migration
  def up
    create_table :tasks_users, :id => false do |t|
      t.references :user, :null => false
      t.references :task, :null => false
    end

    add_index(:tasks_users, [:user_id, :task_id], :unique => true)
  end

  def down
    drop_table :tasks_users
  end
end
