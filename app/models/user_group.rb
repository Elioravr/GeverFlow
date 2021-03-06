class UserGroup < ActiveRecord::Base
  attr_accessible :group_name, :user_ids

  validates_presence_of :group_name

  has_and_belongs_to_many :users

  has_many :boards, :dependent => :delete_all

  def to_s
    "#{group_name}"
  end
end
