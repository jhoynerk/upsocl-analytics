class DfpConnection
  #require 'dfp_api_statement'
  require 'dfp_api'
  require 'open-uri'

  API_VERSION = :v201608
  MAX_RETRIES = 10
  RETRY_INTERVAL = 30

  def initialize
    @dfp = DfpApi::Api.new({
      authentication: {
          method: 'OAuth2',
          oauth2_client_id: ENV['DFP_CLIENT_ID'],
          oauth2_client_secret: ENV['DFP_CLIENT_SECRET'],
          application_name: ENV['DFP_APPLICATION_NAME'],
          network_code: 100064084,
          oauth2_token: {
            access_token: ENV['DFP_ACCESS_TOKEN'],
            refresh_token: ENV['DFP_REFRESH_TOKEN'],
            issued_at: ENV['DFP_ISSUE_AT'].to_time,
            expires_in: 3600
          }
      },
      service: { environment: 'PRODUCTION' },
      connection: { enable_gzip: false },
      library: { log_level: 'INFO' }
    })
  end

  def test(id)
    dfp = @dfp
    report_service = dfp.service(:ReportService, API_VERSION)
    puts report_service.get_report_job_status(id)
  end

  def run_report(start_date: 7.day.ago, end_date: Time.now, item_id: 0)
    dfp = @dfp
    arr = []
    export_format = 'CSV_DUMP'
    file_name = 'test.csv'
    report_service = dfp.service(:ReportService, API_VERSION)

    report_query = {
      :date_range_type => 'CUSTOM_DATE',
      :start_date => {:year => start_date.year,
                      :month => start_date.month,
                      :day => start_date.day},
      :end_date => {:year => end_date.year,
                    :month => end_date.month,
                    :day => end_date.day},
      :dimensions => ['DATE', 'LINE_ITEM_NAME', 'LINE_ITEM_ID'],
      :columns => ['AD_SERVER_IMPRESSIONS', 'AD_SERVER_CLICKS', 'AD_SERVER_CTR'],
      # Create statement object to filter for an order.
      :statement => {
        :query => 'WHERE LINE_ITEM_ID = :item_id',
        :values => [
            {:key => 'item_id',
             :value => {:value => item_id, :xsi_type => 'NumberValue'}}
        ]
      }
    }

    report_job = {:report_query => report_query}
    report_job = report_service.run_report_job(report_job);

    MAX_RETRIES.times do |retry_count|
      report_job_status = report_service.get_report_job_status(report_job[:id])

      break unless report_job_status == 'IN_PROGRESS'
      #puts "Report with ID: %d is still running." % report_job[:id]
      sleep(RETRY_INTERVAL)
    end

    #puts "Report job with ID: %d finished with status %s." %
    #    [report_job[:id],
    #     report_service.get_report_job_status(report_job[:id])]

    download_url = report_service.get_report_download_url(
        report_job[:id], export_format);

    source = open(download_url)
    gz = Zlib::GzipReader.new(source)

    open(file_name, 'w') do |local_file|
     local_file << gz.read
    end

    CSV.foreach(file_name, converters: :numeric, headers: true) do |row|
      arr << {date: row['Dimension.DATE'], line_name: row['Dimension.LINE_ITEM_NAME'], line_id: row['Dimension.LINE_ITEM_ID'], impressions: row['Column.AD_SERVER_IMPRESSIONS'], clicks: row['Column.AD_SERVER_CLICKS'], ctr: row['Column.AD_SERVER_CTR']}
      #puts arr
    end

    File.delete(Rails.root + 'test.csv')
    return arr
  end
end
