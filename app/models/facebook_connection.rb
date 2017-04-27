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
    @graph.get_object(user_post, fields: "reactions.summary(true)")

@user_id = 1519265661627052
@post_id = 1969534753266805


@user_id = 1519265661627052
@post_id = 1969534753266805

    @graph = Koala::Facebook::API.new(oauth_access_token, ENV['FB_APP_SECRET'])



1519265661627052/posts/1969534753266805




@user_id = 1922865171271266
@post_id = 1969534753266805


@user_id = 1922865171271266
@post_id = 2123011261256655

@post_id = 426918087681428

  def query_statistics
    "reactions.summary(total_count).limit(0), comments.summary(total_count).limit(0), shares,
    "
  end

  def consult_likes
    object(user_post, "reactions.summary(true)")
  end

  def consult_comments
    object(user_post, "comments.summary(true).filter(stream)")
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
    # text graph 219769364857951_825943334240548?fields=shares,reactions.summary(true)
    # text graph 219769364857951_674076472760569/video_insights
    @user_id = '219769364857951'
    @post_id = '674076472760569'
    #upsoclsabores = '1922865171271266'
    parameters = {
    fields: ['insights' ]
    }
    #object(user_post, "video")
    @graph.get_object(user_post, parameters)
    #@graph.get_object(user_post, fields: 'video_lists' )
    #object(user_post, "video_insights")

    #FacebookConnection.new(219769364857951, 674076472760569).test
  end

  private

  def oauth_access_token
    #@oauth_access_token ||= Koala::Facebook::OAuth.new(ENV['FB_APP_ID'], ENV['FB_APP_SECRET']).get_app_access_token
    @oauth_access_token = ENV['FB_ACCESS_TOKEN'];
    @oauth_access_token = 'EAAM5MWdZCVzABAMYEarljECQkrkbT1FKOaBoyqZAuX9h9W1H4kZAiJiPkRHvyBVob0qWiOupn9VkxPtZCP4zG4zVOKQX0UB89Fss7OobMj5OadVmzdoZB4xx4pemIC5yucx0fziYgscJyaZCM4n5ruc5gmjM5dlCJbWe3mZBfhBKuRpgGokIG3A0TKcVkjiiQQZD';
  end
end

