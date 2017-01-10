# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
every 1.day, :at => '1:30 am' do
  command "backup perform -t db_backup"
end

set :environment, "production"
set :output, "log/cron_log.log"


every 1.day, :at => '2:00 am' do
  rake "facebook:add_data"
end

every 1.day, :at => '2:30 am' do
  rake '"analytics:add_records[week, day]"'
end

every 1.month, :at => '3:30 am' do
  rake '"analytics:add_records[month, month]"'
end


