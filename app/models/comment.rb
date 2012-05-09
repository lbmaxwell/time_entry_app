class Comment < ActiveRecord::Base
  belongs_to :time_entry
  belongs_to :user
  attr_accessible :comment, :time_entry, :user
end
