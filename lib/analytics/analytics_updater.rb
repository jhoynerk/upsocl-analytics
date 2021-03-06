class AnalyticsUpdater
  include TimeUpdate

  def initialize(url)
    @stadistics = ['PageStadistic', 'CountryStadistic', 'TrafficStadistic', 'DeviceStadistic']
    @url = url
    @start_date = @url.publication_date
    @end_date = attr_end_date
  end

  def search_data_and_update
    @stadistics.each do |model|
      ProcessData.new(data(model), @url).analytics_find_or_create(model)
    end
  end

  private

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
