namespace :facebook do
  desc "Call Facebook Api for get data of url"
  task :add_data, [:url_id] => :environment do |t, args|
    if args.url_id.nil?
      urls = Url.all
    else
      urls = [Url.find(args.url_id)]
    end

    urls.each do |url|
      puts "|||||| --- Updating url with id [#{url.id}] --- |||||||"
      AnalyticFacebook.new(url).save
    end
    puts "Task complete... Updated data facebook in #{urls.count} urls "
  end
end
