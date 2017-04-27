class FacebookPostDecorator < Draper::Decorator
  delegate_all

  def tag_names
   object.campaign.decorate.tag_names + object.active_tag_names
  end

end
