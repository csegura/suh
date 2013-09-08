class GroupByDate
  attr_reader :date, :id

  def initialize
    @date = nil
    @id = 0
  end

  def change? datetime
    if @date != datetime.to_date
      @date = datetime.to_date
      @id += 1
      true
    else
      false
    end
  end
end