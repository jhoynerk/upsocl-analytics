# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :environment, "production"
set :output, "log/cron_log.log"

every '* 10 * * *' do
  rake "analytics:add_records[week, day]"
end

every '0 0 1 * *' do
  rake "analytics:add_records[week, month]"
end

every '0 0 1 1,7 *' do
  rake "analytics:add_records[week, 6month]"
end


every 1.day, :at => '2:00 am' do
  rake "facebook:add_data"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
