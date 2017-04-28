class UpdateAnalytic
  START_DATE = 3.month.ago
  END_DATE = 1.day.ago

  def initialize(url, start_date = nil, end_date = nil)
    @stadistics = ['PageStadistic', 'CountryStadistic', 'TrafficStadistic', 'DeviceStadistic']
    @url = url
    @start_date = start_date
    @end_date = start_date
    search_data
  end

  def search_data
    @stadistics.each do |model|
      ProcessData.new(data(model), @url).analytics_find_or_create(model)
    end
  end

  private
    def attr_start_date
      @start_date ||= UpdateAnalytic::START_DATE
    end

    def attr_end_date
      @end_date ||= UpdateAnalytic::END_DATE
    end

    def data(model)
      conection(@url.profile_id, source(model), @url.only_path)
    end

    def source(model)
      model.sub('Stadistic', '')
    end

    def conection(profile, source, path)
      AnalyticConnection.new(profile).historical_data_for(source: source, url: path, start_date: attr_start_date, end_date: attr_end_date)
    end
end
