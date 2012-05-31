module PaidTimeEntriesHelper
  def input_params_to_date(date_hash)
    date = date_hash[:year]
    date += '-'
    date += date_hash[:month]
    date += '-'
    date += date_hash[:day]
    date = date.to_date
  end

  def team_members(team_param)
    users = []

    team_param.assignments.each do |assignment|
      users.push(assignment.user)
    end
    users.uniq!
    return users
  end
end
