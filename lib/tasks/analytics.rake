namespace :analytics do
  desc "Call Google Analytics Api for get data of url"
  task :add_records, [:time, :interval, :url_id] => :environment do |t, args|
    time_range(args.time)
    arg_interval = args.interval
    interval_range(arg_interval)
    if args.url_id.nil?
      interval = interval_status(arg_interval)
      urls = Url.all.update_interval(@start_interval, @end_interval, interval.upcase)
    else
      urls = [Url.find(args.url_id)]
    end

    urls.each do |url|
      puts "|||||| --- Updating url with id [#{url.id}] --- |||||||"

      page_stadistics = AnalyticConnection.new(url.profile_id).historical_data_for(source: 'Page', url: url.only_path, start_date: @start_date, end_date: @end_date)
      country_stadistics = AnalyticConnection.new(url.profile_id).historical_data_for(source: 'Country', url: url.only_path, start_date: @start_date, end_date: @end_date)
      traffic_stadistics = AnalyticConnection.new(url.profile_id).historical_data_for(source: 'Traffic', url: url.only_path, start_date: @start_date, end_date: @end_date)
      device_stadistics = AnalyticConnection.new(url.profile_id).historical_data_for(source: 'Device', url: url.only_path, start_date: @start_date, end_date: @end_date)
      dfp_stadistics = DfpConnection.new.run_report(start_date: @start_date, end_date: @end_date, item_id: url.line_id)

      page_stadistics.each do |data|
        PageStadistic.create(url: url, date: data.date.to_date, avgtimeonpage: data.avgtimeonpage.to_f, pageviews: data.pageviews.to_i, sessions: data.sessions.to_i, users: data.users.to_i)
      end

      country_stadistics.each do |data|
        CountryStadistic.create(url: url, date: data.date.to_date, country_code: data.countryIsoCode, country_name: data.country, pageviews: data.pageviews.to_i, users: data.users.to_i, avgtimeonpage: data.avgtimeonpage.to_f)
      end

      traffic_stadistics.each do |data|
        TrafficStadistic.create(url: url, date: data.date.to_date, traffic_type: data.traffictype, pageviews: data.pageviews.to_i)
      end

      device_stadistics.each do |data|
        DeviceStadistic.create(url: url, date: data.date.to_date, device_type: data.deviceCategory, pageviews: data.pageviews.to_i)
      end

      dfp_stadistics.each do |data|
        DfpStadistic.create(url: url, date: data[:date], line_id: data[:line_id], line_name: data[:line_name], impressions: data[:impressions], clicks: data[:clicks], ctr: data[:ctr])
      end

      url.update(data_updated_at: Time.now)
    end

    puts "Task complete... Updated #{urls.count} urls"
  end

  def time_range(time)
    case time
    when 'year'
      @start_date = 1.year.ago
      @end_date = 1.day.ago
    when '6month'
      @start_date = 6.month.ago
      @end_date = 1.day.ago
    when 'month'
      @start_date = 1.month.ago
      @end_date = 1.day.ago
    when 'week'
      @start_date = 1.week.ago
      @end_date = 1.day.ago
    when 'day'
      @start_date = 1.day.ago
      @end_date = 1.day.ago
    end
  end

  def interval_range(time)
    case time
    when '6month'
      @start_interval = 6.month.ago
      @end_interval = 3.month.ago
    when 'month'
      @start_interval = 3.month.ago
      @end_interval = 2.week.ago
    when 'day'
      @start_interval = 3.week.ago
      @end_interval = Time.now
    end
  end

  def interval_status(time)
    (time == '6month') ? 'month6' : time
  end
end
