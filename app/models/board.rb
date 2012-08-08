class Board < ActiveRecord::Base
  attr_accessible :name, :user_group_id, :columns, :user_group

  belongs_to :user_group
  has_many :columns
  has_many :tasks, through: :columns

  validates_presence_of :name, :user_group_id

  def to_s
    name
  end

  def set_dufault_columns
    columns.delete_all
    columns.push Column.create(board_id: id, name: 'To-do', group_by_date: false)
    columns.push Column.create(board_id: id, name: 'Do today', group_by_date: false)
    columns.push Column.create(board_id: id, name: 'In progress', group_by_date: false)
    columns.push Column.create(board_id: id, name: 'Done', group_by_date: true)
  end
end
