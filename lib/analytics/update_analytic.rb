class UpdateAnalytic

  def initialize(url, start_date, end_date)
    @stadistics = ['PageStadistic', 'CountryStadistic', 'TrafficStadistic', 'DeviceStadistic']
    @url = url
    @start_date = start_date
    @end_date = end_date
    search_data
  end

  def search_data
    @stadistics.each do |model|
      ProcessData.new(data(model), @url).analytics_find_or_create(model)
    end
  end

  private
    def data(model)
      conection(@url.profile_id, souce(model), @url.only_path)
    end

    def souce(model)
      model.sub('Stadistic', '')
    end

    def conection(profile, source, path)
      AnalyticConnection.new(profile).historical_data_for(source: source, url: path, start_date: @start_date, end_date: @end_date)
    end
end
