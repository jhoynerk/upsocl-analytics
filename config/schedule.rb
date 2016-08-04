# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :environment, "production"
set :output, "log/cron_log.log"
#
every 1.day, :at => '10:00 am' do
  rake "analytics:add_records[day]"
end

every 1.day, :at => '2:00 am' do
  rake "facebook:add_data"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
