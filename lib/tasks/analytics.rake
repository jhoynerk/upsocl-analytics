namespace :analytics do
  desc "Call Google Analytics Api for get data of url"
  task :update, [:url_id] => :environment do |t, args|
    begin
      @urls = SearchUrls.new(args.url_id).searh
      @count = @urls.count
      puts "|||| Se van a actualizar #{@count} Urls ||||"
      message("#{Time.now} Se inicio la tarea programada. Se van a actualizar #{@count} urls", MessageStatus::WAIT)
      @urls.each do |url|
        puts "|||||| --- Updating url with id [#{url.id}] --- |||||||"
        UpdateAnalytic.new(url).search_data_and_update
        UpdateDfp.new(url).search_data_and_update if url.has_dfp?
        url.update(attention: url.attention_last)
        url.update(data_updated_at: Time.now)
      end
      puts "Task complete... Updated #{@count} urls"
      message("#{Time.now} Tarea completa... Se actualizaron #{@count} urls", MessageStatus::SUCCESS)
    rescue Exception => e
      message("#{Time.now} Ocurrio un problema en la tarea programada. Error: #{e}", MessageStatus::ERROR)
    end
  end

  def message(message, status)
    Message.create(type_update: 1, message: message, status: status)
  end
end
