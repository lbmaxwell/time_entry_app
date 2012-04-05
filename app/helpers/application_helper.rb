module ApplicationHelper
  def full_title
    base_title = "MDE Tally System"
#    if page_title.empty?
#      base_title
#    else
#      "#{base_title} | #{page_title}"
#    end
  end

  def sign_in_or_out
    "Sign in"
  end
end
