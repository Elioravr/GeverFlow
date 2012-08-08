class Task < ActiveRecord::Base
  attr_accessible :comment_id, :description, :time_estimated, 
    :time_spent, :title, :user_id, :column_id, :column

  validates_presence_of :title

  belongs_to :column
  has_one :board, through: :column
  belongs_to :user
  #has_and_belongs_to_many :tags
  has_many :subtasks, :dependent => :delete_all
  #:comments

end
