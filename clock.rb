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

  handler do |job|
    Rails.logger.tagged("Clockwork") { Rails.logger.debug("Running #{job}") }
    @current_job = job
    begin
      Rake::Task[job.to_s].execute
    rescue Exception => e
      Raygun.track_exception(e)
    end
  end

  error_handler do |error|
    add_log(error)
  end

  every(1.day, 'rake "analytics:add_records[day, day]"', at: '12:40')

  def self.add_log(error)
    logger = Logger.new(STDOUT)
    logger.info(error.exception)
    logger.debug(@current_job)
    logger.fatal(error.backtrace.join("\n"))
  end
end
