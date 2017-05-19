class TrafficStadistics::TypesHelpers

  def self.type_by(traffic_name)
    @traffic_name = traffic_name
    search_type
  end

  private
    def self.search_type
      result = TrafficTypeStadistics::OTHERS
      TrafficTypeStadistics.list.each{ |key| result = key if exist_value?(key) }
      result
    end

    def self.exist_value?(key)
      traffic_hash[key.to_s].include?(formatted_string)
    end

    def self.formatted_string
      @traffic_name.delete(' ').downcase
    end

    def self.traffic_hash
      {
        "#{TrafficTypeStadistics::UPSOCL}": ['pagina', 'direct'],
        "#{TrafficTypeStadistics::FACEBOOK}": ['facebook', 'referall'],
        "#{TrafficTypeStadistics::OTHERS}": []
      }.stringify_keys!
    end

end
