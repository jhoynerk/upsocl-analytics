class CampaignDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  def created_at
    I18n.l(object.created_at, format: :short)
  end

  def agencies_countries_mark_format
    object.agencies_countries_mark ? object.agencies_countries_mark.full_info : 'Sin Asignar'
  end

  def tag_names
    active_tag_names
  end
end
