class IntervalRange
  attr_accessor :start_interval , :end_interval, :interval

  def initialize(interval = 'day')
    interval_range(interval)
    @interval = interval
  end

  private
    def interval_range(interval)
      case interval
      when 'month'
        @start_interval = 3.month.ago
        @end_interval = 3.week.ago
      when 'day'
        @start_interval = 3.week.ago
        @end_interval = Time.now
      else
        @start_interval = 3.month.ago
        @end_interval = Time.now
      end
    end
end
