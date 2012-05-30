class Team < ActiveRecord::Base
  attr_accessible :name, :show_performance

  has_many :assignments
  has_many :tasks
  has_many :paid_time_entries
  has_many :users
  has_many :time_entries

  validates :name, presence: true
  validates :show_performance, inclusion: { in: [true, false] }
end
