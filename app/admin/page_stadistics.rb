ActiveAdmin.register PageStadistic do
  include AvgUtils

  permit_params :pageviews, :avgtimeonpage, :url_id, :date, :users, :sessions
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
    column :pageviews
    column :avgtimeonpage
    actions
  end

  filter :url, label: 'Nombre del articulo', as: :select, input_html: { class: 'chosen-input' }
  filter :date

  form do |f|
    f.inputs "Estadisticas de pagina" do
      f.input :url, :as => :select, :input_html => { :class => "chosen-input"}
      f.input :date
      f.input :avgtimeonpage, as: :time_picker, input_html: { step: :second }
      f.input :pageviews
      f.input :users
      f.input :sessions
    end
    f.actions
  end
end
