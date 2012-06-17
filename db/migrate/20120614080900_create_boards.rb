class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :name
      t.references :user_group, :null => false

      t.timestamps
    end
  end
end
