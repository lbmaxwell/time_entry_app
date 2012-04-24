class Team < ActiveRecord::Base
  attr_accessible :name

  has_many :assignments
  has_many :tasks
  has_many :paid_time_entries
  has_many :users
  has_many :time_entries

  validates :name, presence: true
end
