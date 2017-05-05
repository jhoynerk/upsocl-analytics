module TimeUpdate

  START_DATE = 3.month.ago
  END_DATE = 1.day.ago

  private
    def attr_start_date
      @start_date ||= TimeUpdate::START_DATE
    end

    def attr_end_date
      @end_date ||= TimeUpdate::END_DATE
    end
end
