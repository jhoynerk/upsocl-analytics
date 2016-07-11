class FacebookConnection
  def initialize(post_id, user_id)
    @graph = Koala::Facebook::API.new(oauth_access_token, ENV['FB_APP_SECRET'])
    @post_id = post_id
    @user_id = user_id
  end

  def object(id, fields)
    @graph.get_object(id, fields: fields)
  end

  def user_post
    "#{@user_id}_#{@post_id}"
  end

  def consult_likes
    object(user_post, "likes.summary(true)")
  end

  def consult_comments
    object(user_post, "comments.summary(true)")
  end

  def consult_shares
    object(user_post, "shares")
  end

  def count_likes
    consult_likes["likes"]["summary"]["total_count"]
  end

  def count_comments
    consult_comments["comments"]["summary"]["total_count"]
  end

  def count_shares
    (consult_shares["shares"].nil?) ? 0 : consult_shares["shares"]["count"]
  end

  private

  def oauth_access_token
    @oauth_access_token ||= Koala::Facebook::OAuth.new(ENV['FB_APP_ID'], ENV['FB_APP_SECRET']).get_app_access_token
  end
end

