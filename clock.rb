require 'clockwork'
require_relative './config/boot'
require_relative './config/environment'
require_relative './config/application'
require 'rubygems'
require 'raygun4ruby'

module Clockwork
  UpsoclAnalytics::Application.load_tasks

  configure do |config|
    config[:tz] = 'America/Santiago'
  end

  error_handler do |error|
    add_log(error)
  end

  every(1.day, "analytics:add_records", at: '10:40') do
    Rails.logger.tagged("Clockwork") { Rails.logger.debug("Running analytics:add_records") }
    begin
      Rake::Task['analytics:add_records'].reenable
      Rake::Task["analytics:add_records"].invoke('week', 'day')
    rescue Exception => e
      Raygun.track_exception(e)
    end
  end

  def self.add_log(error)
    logger = Logger.new(STDOUT)
    logger.info(error.exception)
    logger.debug(@current_job)
    logger.fatal(error.backtrace.join("\n"))
  end
end
