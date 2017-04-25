class TimeRange
  attr_accessor :start_date , :end_date, :time

  def initialize(time = 'day')
    time_range(time)
    @time = time
  end

  private
    def time_range(time)
      @end_date = 1.day.ago
      case time
        when 'year'
          @start_date = 1.year.ago
        when '6month'
          @start_date = 6.month.ago
        when 'month'
          @start_date = 1.month.ago
        when 'week'
          @start_date = 1.week.ago
        when 'day'
          @start_date = @end_date
        else
          @start_date = @end_date
      end
    end
end
