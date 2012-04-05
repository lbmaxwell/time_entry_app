class Assignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  belongs_to :team
  attr_accessible :end_date, :start_date, :user_id, :role_id, :team_id
end
