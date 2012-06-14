class UserUserGroup < ActiveRecord::Migration
  def up
    create_table :user_groups_users, :id => false do |t|
      t.references :user, :null => false
      t.references :user_group, :null => false
    end

    # Adding the index can massively speed up join tables. Don't use the
    # # unique if you allow duplicates.
    add_index(:user_groups_users, [:user_id, :user_group_id], :unique => true)
  end

  def down
    drop_table :user_groups_users
  end
end
