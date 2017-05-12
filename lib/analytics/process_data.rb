class ProcessData

  def initialize(data, url)
    @url = url
    @data = data
  end

  def analytics_find_or_create(model)
    @data.each { |d| AnalyticsFindOrCreate.new( attr_type_hash( d ) ).find_or_create(model) }
  end

  private
    def attr_type_hash(data)
      {
        url: @url,
        date: data&.date.to_date,
        sessions: data&.sessions.to_i,
        avgtimeonpage: data&.avgtimeonpage.to_f,
        pageviews: data&.pageviews.to_i,
        users: data&.users.to_i,
        country_code: data&.countryIsoCode,
        country_id: country_id_from(data&.countryIsoCode),
        traffic_type: data&.traffictype,
        device_type: data&.deviceCategory
      }
    end

    def country_id_from(country_code)
      Country.find_by(code: country_code)&.id
    end
end
