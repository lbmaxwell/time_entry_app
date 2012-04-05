class PaidTimeEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  attr_accessible :effective_date, :time
end
