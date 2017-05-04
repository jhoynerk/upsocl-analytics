class FacebookPostDecorator < Draper::Decorator
  delegate_all
  include ActionView::Helpers::NumberHelper

  def tag_names
   object.campaign.decorate.tag_names + object.active_tag_names
  end

  def post_impressions_unique
    format(object.post_impressions_unique.ceil.to_i)
  end

  def post_video_views_10s
    format(object.post_video_views_10s.ceil.to_i)
  end

  def post_video_avg_time_watched
    format(to_seconds(object.post_video_avg_time_watched).ceil.to_i)
  end

  def post_video_views
    format(object.post_video_views.ceil.to_i)
  end

  def post_video_view_time
    format(to_minutes(object.post_video_view_time).ceil.to_i)
  end

  def total_likes
    format(object.total_likes)
  end

  def total_comments
    format(object.total_comments)
  end

  def total_shares
    format(object.total_shares)
  end

  private
  def format(number)
    number_with_delimiter(number)
  end

  def to_minutes(val)
    val/1000/60
  end

  def to_seconds(val)
    val/1000
  end

end
