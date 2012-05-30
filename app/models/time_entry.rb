class TimeEntry < ActiveRecord::Base
  belongs_to :task
  belongs_to :user
  belongs_to :team
  has_many :comments
  attr_accessor :skip_date_range_check
  attr_accessible :effective_date, :number_processed, :seconds, :task_id, 
    :user_id, :team_id

  validates :task_id, presence: true
  validates :seconds, presence: true, numericality: { only_integer: true, 
              greater_than_or_equal_to: 0 }
  validates :effective_date, presence: true, inclusion: { in: Date.today..(Date.today + 7),
              message: "must be between #{Date.today} and #{Date.today + 7}" }, 
                unless: :skip_date_range_check
  validates :team_id, presence: true

  def minutes
    (self.seconds.to_f / 60).round(2)
  end

  def hours
    (self.seconds.to_f / (60 * 60)).round(2)
  end
end
