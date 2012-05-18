module PaidTimeEntriesHelper
  def input_params_to_date(date_hash)
    date = date_hash[:year]
    date += '-'
    date += date_hash[:month]
    date += '-'
    date += date_hash[:day]
    date = date.to_date
  end
end
