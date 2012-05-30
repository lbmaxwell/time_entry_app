class PaidTimeEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  attr_accessible :effective_date, :minutes, :team_id, :user_id, :is_overtime
  attr_accessor :skip_date_range_check

  validates :user, presence: true
  validates :team, presence: true
  validates :effective_date, presence: true, inclusion: { in: Date.today..(Date.today + 7),
    message: "must be between #{Date.today} and #{Date.today + 7}" },
      unless: :skip_date_range_check
  validates :minutes, presence: true
  validates :is_overtime, inclusion: { in: [true, false] }

  def hours
    (self.minutes.to_f / 60).round(2)
  end

  def seconds
    (self.minutes * 60)
  end
end
