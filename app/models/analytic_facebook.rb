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
    @url.facebook_posts.each do |fbp|
      fbc = FacebookConnection.new(fbp.account_id, fbp.post_id)
      @likes += fbc.count_likes.to_i
      @comments += fbc.count_comments.to_i
      @shares += fbc.count_shares.to_i
    end
  end

  def social_shares
    @shares = FacebookConnection.new(@url.data).consult_shares_by_url
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
