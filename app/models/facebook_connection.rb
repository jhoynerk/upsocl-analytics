class FacebookConnection
  def initialize(user_id, post_id = nil)
    @graph = Koala::Facebook::API.new(oauth_access_token, ENV['FB_APP_SECRET'])
    @post_id = post_id
    @user_id = user_id
  end

  # Old connection
  def consult_url
    @graph.get_object('', { id: @user_id })
  end

  def consult_shares_by_url
    consult_url['share']["share_count"]
  end

  # new connection
  def object(id, fields)
    @graph.get_object(id, fields: fields)
  end

  def user_post
    "#{@user_id}_#{@post_id}"
  end

  def consult_likes
    object(user_post, "reactions.summary(true)")
  end

  def consult_comments
    object(user_post, "comments.summary(true)")
  end

  def consult_shares
    object(user_post, "shares")
  end

  def count_likes
    consult_likes["reactions"]["summary"]["total_count"]
  end

  def count_comments
    consult_comments["comments"]["summary"]["total_count"]
  end

  def count_shares
    (consult_shares["shares"].nil?) ? 0 : consult_shares["shares"]["count"]
  end

  def test
    @user_id = '219769364857951'
    @post_id = '529310477237170'
    upsoclsabores = '1922865171271266'
    parameters = {
    fields: ['video_insights' ],
    data_columns: ['campaign_name', 'reach', 'frequency', 'impressions', 'social_reach',
        'social_impressions', 'unique_impressions', 'cpm', 'cpp', 'spend']
    }
    #object(user_post, "video")
    #@graph.get_object(user_post, parameters)
    @graph.get_object(@user_id, fields: 'video_lists' )
    #object(user_post, "video_insights")

    #FacebookConnection.new(219769364857951, 674076472760569).test
  end

  private

  def oauth_access_token
    @oauth_access_token ||= Koala::Facebook::OAuth.new(ENV['FB_APP_ID'], ENV['FB_APP_SECRET']).get_app_access_token
  end
end

