module TimeUpdate

  START_DATE = 1.week.ago
  END_DATE = 1.day.ago

  private
    def attr_start_date
      lower_than_constant_date? ? @start_date : TimeUpdate::START_DATE
    end

    def lower_than_constant_date?
      (@start_date.present? && TimeUpdate::START_DATE < @start_date)
    end

    def attr_end_date
      @end_date ||= TimeUpdate::END_DATE
    end
end
