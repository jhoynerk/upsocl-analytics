class DfpUpdater
  include TimeUpdate

  def initialize(url, start_date = nil, end_date = nil)
    @model = 'DfpStadistic'
    @url = url
    @start_date = start_date
    @end_date = start_date
  end

  def search_data_and_update
    conection.each do |data|
      AnalyticsFindOrCreate.new( attr_type_hash(data) ).find_or_create(@model)
    end
  end

  private

    def attr_type_hash(data)
      {
        url: @url,
        date: data[:date],
        line_id: data[:line_id],
        impressions: data[:impressions],
        clicks: data['clicks'],
        ctr: data['ctr']
      }
    end

    def conection
      DfpConnection.new.run_report(start_date: attr_start_date, end_date: attr_end_date, item_id: @url.line_id)
    end
end
