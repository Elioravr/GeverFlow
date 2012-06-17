class Board < ActiveRecord::Base
  attr_accessible :name, :user_group_id

  belongs_to :user_group

  def to_s
    "#{name}"
  end
end
