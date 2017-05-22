namespace :db do
  desc "Update traffic_type_int in TrafficStadistic "
  task :update_traffic_type, [:url_id] => :environment do |t, args|
    ActiveRecord::Base.transaction do
      TrafficStadistic.all.each do |traffic_s|
        traffic_s.update(traffic_type_int: TrafficStadistics::TypesHelpers.type_by(traffic_s.traffic_type))
        p "setter id: #{traffic_s.id} --- #{traffic_s.traffic_type} : #{traffic_s.traffic_type_int} "
      end
    end
  end
end
