class String
  def checked?
    self == "1"
  end
end

module Enumerable
  def get_months
    self.group_by { |e| e.created_at.beginning_of_month }
  end
end