class AnalyticConnection
  def initialize(profile_id = "92974712")
    @user = Legato::User.new GoogleOauth2Installed.access_token
    @profile = search_profile(profile_id)
  end

  def data_for(source:'', url:'')
    ('Analytic::' + source).constantize.path(url, @profile).each { |d| p d }
  end

  def historical_data_for( source:'', url:'', start_date: 1.week.ago , end_date: Time.now )
    ('Analytic::' + source).constantize.results( @profile, start_date: start_date, end_date: end_date ).path( url ).each { |d| p d }
  end

  def group_data_for(sources:[], url:'')
    data = {}
    sources.each do |s|
      data[s] = Object.const_get( 'Analytic::' + s).path( url, @profile ).each { |d| p d }
    end
    data
  end

  def all_profiles
    @user.profiles
  end

  private
  def search_profile(id)
    all_profiles.each do |profile|
      if profile.id == id
        return profile
      end
    end
  end

end
