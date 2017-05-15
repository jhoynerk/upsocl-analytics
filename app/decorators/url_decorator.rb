class UrlDecorator < Draper::Decorator
  delegate_all

  def tag_names
   object.campaign.decorate.tag_names + object.active_tag_names
  end

  def agencies_countries_mark_format
  	object.campaign.decorate.agencies_countries_mark_format
  end

end
