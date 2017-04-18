ActiveAdmin.register DfpStadistic do
  permit_params :impressions, :clicks
  config.clear_action_items!
  menu parent: "Estadisticas URL"

  index do
    selectable_column
    column(:campaña) do |u|
      u.url_campaign_name
    end
    column(:url) do |u|
      truncate(u.url_title, length: 50)
    end
    column :date
    column :impressions
    column :clicks
    actions
  end

  filter :url
  filter :url_id
  filter :date

  form do |f|
    f.inputs "Estadistica de dfp" do
      f.input :impressions
      f.input :clicks
    end
    f.actions
  end
end
