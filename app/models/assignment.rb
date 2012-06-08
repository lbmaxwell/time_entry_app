class Assignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  belongs_to :team
  attr_accessible :end_date, :start_date, :user_id, :role_id, :team_id

  validates :start_date, presence: true
  validates :user_id, presence: true
  validates :role_id,  presence: true
  validates :team_id,  presence: true

  def active?
    if self.end_date.nil? || self.end_date >= Date.today
      true
    else
      false
    end
  end
end
