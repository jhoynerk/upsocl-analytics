class CampaignDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  def created_at
    I18n.l(object.created_at, format: :short)
  end

  def tag_names
    TagType.to_a.map do |key|
      key_name = TagType.key_for(key[1])
      key_name = "type_tag_#{key_name}"
      names = object.tags.send(key_name).pluck(:title).join(', ')
      names.blank? ? nil : {key: key[0], value: names}
    end.compact
  end

end
