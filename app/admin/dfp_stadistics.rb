ActiveAdmin.register DfpStadistic do
  permit_params :impressions, :clicks, :ctr
  config.clear_action_items!
  menu parent: "Estadisticas URL"
  actions :index, :show, :update, :edit, :destroy

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
    column :ctr
    actions
  end

  filter :url, label: 'Nombre del articulo', as: :select, input_html: { class: 'chosen-input' }
  filter :date

  form do |f|
    f.inputs "Estadistica de dfp" do
      f.input :impressions
      f.input :clicks
      f.input :ctr
    end
    f.actions
  end
end
