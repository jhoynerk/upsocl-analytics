class FacebookConnection

  def initialize(user_id, post_id = nil)
    @graph = Koala::Facebook::API.new(oauth_access_token, ENV['FB_APP_SECRET'])
    @post_id = post_id
    @user_id = user_id
  end

  def self.insights_metrics
    [:post_impressions_unique, :post_video_views,
     :post_video_avg_time_watched, :post_video_view_time]
  end

  def object(id, fields)
    @graph.get_object(id, fields: fields)
  end

  def user_post
    "#{@user_id}_#{@post_id}"
  end

  def count_likes
    data["reactions"]["summary"]["total_count"]
  end

  def count_comments
    data["comments"]["summary"]["total_count"]
  end

  def count_shares
    (data["shares"]) ? data["shares"]["count"] : 0
  end

  FacebookConnection.insights_metrics.each do |insight_method|
    define_method insight_method do
      insights_metrics
      instance_variable_get("@#{insight_method}")
    end
  end

    def data
      @data ||= get_data
    end

    def insights_metrics
      data['insights']['data'].each do |metric|
        instance_variable_set("@#{metric['name']}", extract_insights_metric(metric))
      end
    end

    def extract_insights_metric(metric)
      metric['values'].first['value']
    end

    def get_data
      @graph.get_object(user_post, fields: query_data)
    end

    def query_data
      #api-2.9
      "insights.metric(post_impressions_unique, post_video_views, post_video_avg_time_watched, post_video_view_time).period(lifetime){name,values}, reactions.summary(true).limit(0), comments.summary(true).filter(stream).limit(0), shares"
    end

    def oauth_access_token
      @oauth_access_token = ENV['FB_ACCESS_TOKEN'];
    end
end

# post_impressions_unique, #personas alcanzadas
# post_video_avg_time_watched, #tiempo promedio
# post_video_views # reproducciones de video
# post_video_view_time #Minutos totales reproducidos /1000/60
# @graph.get_object(user_post, fields: "insights.metric(post_impressions_unique, post_video_views, post_video_avg_time_watched, post_video_view_time).period(lifetime){name,values}, reactions.summary(true).limit(0), comments.summary(true).filter(stream).limit(0), shares")

  # def test
  #   # text graph 219769364857951_825943334240548?fields=shares,reactions.summary(true)
  #   # text graph 219769364857951_674076472760569/video_insights
  #   @user_id = '219769364857951'
  #   @post_id = '674076472760569'
  #   #upsoclsabores = '1922865171271266'
  #   parameters = {
  #   fields: ['insights' ]
  #   }
  #   #object(user_post, "video")
  #   @graph.get_object(user_post, parameters)
  #   #@graph.get_object(user_post, fields: 'video_lists' )
  #   #object(user_post, "video_insights")

  #   #FacebookConnection.new(219769364857951, 674076472760569).test
  # end

  #@oauth_access_token ||= Koala::Facebook::OAuth.new(ENV['FB_APP_ID'], ENV['FB_APP_SECRET']).get_app_access_token
  # get_data['insights']['data'].select{|metric| metric['name'] == 'post_impressions_unique'}.first['values'].first['value']

