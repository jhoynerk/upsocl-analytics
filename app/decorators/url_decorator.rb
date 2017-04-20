class UrlDecorator < Draper::Decorator
  delegate_all

  def tag_names
   object.campaign.decorate.tag_names + _tag_names
  end

  def _tag_names
    TagType.to_a.map do |key|
      key_name = TagType.key_for(key[1])
      key_name = "type_tag_#{key_name}"
      names = object.tags.send(key_name).pluck(:title).join(', ')
      names.blank? ? nil : {key: key[0], value: names}
    end.compact
  end

end
