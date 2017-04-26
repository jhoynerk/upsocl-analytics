class DelayedRake < Struct.new(:task, :options)
  def perform
    env_options = ''
    options && options.stringify_keys!.each do |key, value|
      env_options << " #{key.upcase}=#{value}" if key
    end
    system("cd #{Rails.root} && RAILS_ENV=#{Rails.env} bundle exec rake #{task} #{env_options} >> log/delayed_rake.log")
  end
end