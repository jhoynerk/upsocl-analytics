namespace :analytics do
  desc "Call Google Analytics Api for get data of url"
  task :add_records, [:time, :interval, :url_id] => :environment do |t, args|
    begin
      time_range(args.time)
      arg_interval = args.interval
      interval_range(arg_interval)
      if args.url_id.nil?
        interval = interval_status(arg_interval)
        urls = Url.where("id > ? ", 4100).update_interval(@start_interval, @end_interval, interval.upcase).order(id: :desc).where(publico: false)
      else
        urls = [Url.find(args.url_id)]
      end
      count = urls.count
      puts "|||| Se van a actualizar #{count} Urls ||||"
      Message.create(type_update: 1, message: "#{Time.now} Se inicio la tarea programada Con Argumentos (#{args.time}, #{args.interval}) . Se van a actualizar #{urls.count} urls", status: 1)
      urls.each do |url|
        puts "|||||| --- Updating url with id [#{url.id}] --- |||||||"

        page_stadistics = AnalyticConnection.new(url.profile_id).historical_data_for(source: 'Page', url: url.only_path, start_date: @start_date, end_date: @end_date)
        country_stadistics = AnalyticConnection.new(url.profile_id).historical_data_for(source: 'Country', url: url.only_path, start_date: @start_date, end_date: @end_date)
        traffic_stadistics = AnalyticConnection.new(url.profile_id).historical_data_for(source: 'Traffic', url: url.only_path, start_date: @start_date, end_date: @end_date)
        device_stadistics = AnalyticConnection.new(url.profile_id).historical_data_for(source: 'Device', url: url.only_path, start_date: @start_date, end_date: @end_date)
        dfp_stadistics = DfpConnection.new.run_report(start_date: @start_date, end_date: @end_date, item_id: url.line_id)

        url.page_stadistics.where("date >= ? AND date <= ?", @start_date, @end_date ).delete_all
        page_stadistics.each do |data|
          PageStadistic.create(url: url, date: data.date.to_date, avgtimeonpage: data.avgtimeonpage.to_f, pageviews: data.pageviews.to_i, sessions: data.sessions.to_i, users: data.users.to_i)
        end

        url.country_stadistics.where("date >= ? AND date <= ?", @start_date, @end_date ).delete_all
        country_stadistics.each do |data|
          CountryStadistic.create(url: url, date: data.date.to_date, country_code: data.countryIsoCode, country_name: data.country, pageviews: data.pageviews.to_i, users: data.users.to_i, avgtimeonpage: data.avgtimeonpage.to_f)
        end

        url.traffic_stadistics.where("date >= ? AND date <= ?", @start_date, @end_date ).delete_all
        traffic_stadistics.each do |data|
          TrafficStadistic.create(url: url, date: data.date.to_date, traffic_type: data.traffictype, pageviews: data.pageviews.to_i)
        end

        url.device_stadistics.where("date >= ? AND date <= ?", @start_date, @end_date ).delete_all
        device_stadistics.each do |data|
          DeviceStadistic.create(url: url, date: data.date.to_date, device_type: data.deviceCategory, pageviews: data.pageviews.to_i)
        end

        url.dfp_stadistics.where("date >= ? AND date <= ?", @start_date, @end_date ).delete_all
        dfp_stadistics.each do |data|
          DfpStadistic.create(url: url, date: data[:date], line_id: data[:line_id], line_name: data[:line_name], impressions: data[:impressions], clicks: data[:clicks], ctr: data[:ctr])
        end
        url.update(attention: attention(url))if attention(url).to_i > url.attention.to_i
        url.update(data_updated_at: Time.now)
      end

      puts "Task complete... Updated #{count} urls"
      Message.create(type_update: 1, message: "#{Time.now} Tarea completa... Se actualizaron #{count} urls", status: 2)
    rescue Exception => e
      Message.create(type_update: 1, message: "#{Time.now} Ocurrio un problema en la tarea programada. Error: #{e}", status: 3)
    end
  end

  def time_range(time)
    @end_date = 1.day.ago
    case time
      when 'year'
        @start_date = 1.year.ago
      when '6month'
        @start_date = 6.month.ago
      when 'month'
        @start_date = 1.month.ago
      when 'week'
        @start_date = 1.week.ago
      when 'day'
        @start_date = @end_date
    end
  end

  def interval_range(time)
    case time
    when '6month'
      @start_interval = 6.month.ago
      @end_interval = 3.month.ago
    when 'month'
      @start_interval = 3.month.ago
      @end_interval = 3.week.ago
    when 'day'
      @start_interval = 3.week.ago
      @end_interval = Time.now
    end
  end

  def interval_status(time)
    (time == '6month') ? 'month6' : time
  end

  def attention(url)
    unless url.totals_stadistics.nil?
      unless url.totals_stadistics[:avgtimeonpage].nil? && url.totals_stadistics[:pageviews].nil?
        return (url.totals_stadistics[:avgtimeonpage] * url.totals_stadistics[:pageviews]) / 60
      end
    end
  end
end
