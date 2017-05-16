module TimeUpdate

  START_DATE = 1.week.ago.to_date
  END_DATE = 1.day.ago.to_date

  private
    def attr_start_date
      @attr_start_date ||= get_start_date
    end

    def get_start_date
      lower_than_constant_date? ? @start_date : TimeUpdate::START_DATE
    end

    def lower_than_constant_date?
      (@start_date.present? && TimeUpdate::START_DATE < @start_date)
    end

    def attr_end_date
      @end_date ||= TimeUpdate::END_DATE
    end
end
