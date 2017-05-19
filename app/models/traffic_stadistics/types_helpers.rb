class TrafficStadistics::TypesHelpers

  def self.type_by(traffic_name)
    @traffic_name = traffic_name
    search_type
  end

  private
    def self.search_type
      self.traffic_hash.each do |key, values|
        return (values.include? formatted_string) ? key : TrafficTypeStadistics::OTHERS
      end
    end

    def self.formatted_string
      @traffic_name.delete(' ').downcase
    end

    def self.traffic_hash
      {
        "#{TrafficTypeStadistics::UPSOCL}": ['pagina', 'direct'],
        "#{TrafficTypeStadistics::FACEBOOK}": ['facebook', 'referall']
      }
    end

end
