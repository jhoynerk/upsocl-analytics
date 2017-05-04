class FacebookConnection

  def initialize(user_id, post_id = nil)
    @graph = Koala::Facebook::API.new(oauth_access_token, ENV['FB_APP_SECRET'])
    @post_id = post_id
    @user_id = user_id
  end

  def self.insights_metrics
    [:post_impressions_unique, :post_video_views, :post_video_views_10s,
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
    x = @graph.get_object(user_post, fields: query_data)

    $stderr.puts '******' * 50
    $stderr.puts x.inspect

    x
  end

  def query_data
    #api-2.9
    "insights.metric(post_impressions_unique, post_video_views_10s, post_video_views, post_video_avg_time_watched, post_video_view_time).period(lifetime){name,values}, reactions.summary(true).limit(0), comments.summary(true).filter(stream).limit(0), shares"
  end

  def oauth_access_token
    @oauth_access_token = ENV['FB_ACCESS_TOKEN'];
  end
end
