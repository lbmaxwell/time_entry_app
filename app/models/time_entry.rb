class TimeEntry < ActiveRecord::Base
  belongs_to :task
  belongs_to :user
  has_many :comments
  attr_accessible :effective_date, :number_processed, :time, :task_id, :user_id
end
