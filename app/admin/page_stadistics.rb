ActiveAdmin.register PageStadistic do
  permit_params :pageviews, :avgtimeonpage
  config.clear_action_items!

  index do
    selectable_column
    column(:campaña) do |u|
      u.url.campaign.name.titleize
    end
    column(:url) do |u|
      truncate(u.url.title, length: 50)
    end
    column :date
    column :pageviews
    column :avgtimeonpage
    actions
  end

  filter :url
  filter :url_id
  filter :date

  form do |f|
    f.inputs "Estadistica por Pagina" do
      f.input :pageviews
      f.input :avgtimeonpage
    end
    f.actions
  end
end
