class AnalyticFacebook

  def initialize(url)
    @url = url
    @likes = (url.facebook_likes > 0) ? url.facebook_likes : 0
    @comments = (url.facebook_comments > 0) ? url.facebook_comments : 0
    @shares = (url.facebook_shares > 0) ? url.facebook_shares : 0
  end

  def get_data_facebook
    if @url.has_facebook_post?
      facebook_connection
    else
      social_shares
    end
  end

  def facebook_connection
    likes, comments, shares  = 0, 0, 0
    @url.facebook_posts.each do |fbp|
      fbc = FacebookConnection.new(fbp.account_id, fbp.post_id)
      likes += fbc.count_likes.to_i
      comments += fbc.count_comments.to_i
      shares += fbc.count_shares.to_i
    end
    @likes = (likes >= @likes) ? likes : @likes
    @comments = (comments >= @comments) ? comments : @comments
    @shares = (shares >= @shares) ? shares : @shares
  end

  def social_shares
    @shares = SocialShares.facebook @url.data
  end

  def save
    get_data_facebook
    @url.update!(facebook_likes: @likes, facebook_comments: @comments, facebook_shares: @shares)
  end

  def update
    get_data_facebook
    { facebook_likes: @likes, facebook_comments: @comments, facebook_shares: @shares, data_updated_at: Time.now }
  end

  def update_attr_post_video
    fpc = facebook_post_connection
    {
      total_likes: fpc.count_likes,
      total_comments: fpc.count_comments,
      total_shares: fpc.count_shares,
      post_impressions_unique: fpc.post_impressions_unique,
      post_video_avg_time_watched: fpc.post_video_avg_time_watched,
      post_video_views: fpc.post_video_views,
      post_video_view_time: fpc.post_video_view_time
    }
  end

  def facebook_post_connection
    FacebookConnection.new(@url.account_id, @url.post_id)
  end
end
