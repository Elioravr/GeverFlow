class Subtask < ActiveRecord::Base
  attr_accessible :content, :task, :task_id, :is_done

  validates_presence_of :content

  belongs_to :task

end
