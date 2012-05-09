class PaidTimeEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  attr_accessible :effective_date, :minutes, :team_id, :user_id, :is_overtime

  validates :user, presence: true
  validates :team, presence: true
  validates :effective_date, presence: true
  validates :minutes, presence: true
  #validates :is_overtime, presence: true

  def hours
    (self.minutes.to_f / 60).round(2)
  end

  def seconds
    (self.minutes * 60)
  end
end
