class Column < ActiveRecord::Base
  attr_accessible :name, :board_id, :group_by_date

  belongs_to :board
  has_many :tasks

  def to_s
    name
  end
end
