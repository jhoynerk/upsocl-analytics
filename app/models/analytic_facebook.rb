class AnalyticFacebook

  def initialize(url)
    @url = url
    @likes = 0
    @comments = 0
    @shares = 0
  end
  
  def get_data_facebook
    if @url.has_facebook_post?
      facebook_connection
    else
      social_shares
    end
  end

  def facebook_connection
    @url.facebook_posts.each do |fbp|
      fbc = FacebookConnection.new(fbp.post_id, fbp.account_id)
      @likes += fbc.count_likes.to_i
      @comments += fbc.count_comments.to_i
      @shares += fbc.count_shares.to_i
    end
  end

  def social_shares
    info_social = SocialShares.selected @url.data, %w(facebook)
    unless info_social[:facebook].nil?
      @likes = info_social[:facebook]["like_count"]
      @comments = info_social[:facebook]["comment_count"]
      @shares = info_social[:facebook]["share_count"]
    end
  end

  def save
    get_data_facebook
    @url.update(facebook_likes: @likes, facebook_comments: @comments, facebook_shares: @shares)
  end

  def update
    get_data_facebook
    { facebook_likes: @likes, facebook_comments: @comments, facebook_shares: @shares }
  end
end
