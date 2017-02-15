namespace :facebook do
  desc "Call Facebook Api for get data of url"
  task :add_data, [:url_id] => :environment do |t, args|
    @start_interval = 4.week.ago
    @end_interval = Time.now
    interval = "month"
    begin
      if args.url_id.nil?
        urls = Url.where("id > ? ", 4100).update_interval(@start_interval, @end_interval, interval.upcase).order(id: :desc).where(publico: false)
      else
        urls = [Url.find(args.url_id)]
      end

      Message.create(type_update: 2, message: "#{Time.now} Se inicio la tarea programada. Se van a actualizar #{urls.count} urls", status: 1)
      urls.each do |url|
        puts "|||||| --- Updating url with id [#{url.id}] --- |||||||"
        AnalyticFacebook.new(url).save
      end
      puts "Task complete... Updated data facebook in #{urls.count} urls "
      Message.create(type_update: 2, message: "#{Time.now} Tarea completa... Se actualizaron #{urls.count} urls", status: 2)
    rescue Exception => e
      Message.create(type_update: 2, message: "#{Time.now} Ocurrio un problema en la tarea programada. Error: #{e}", status: 3)
    end
  end
end
