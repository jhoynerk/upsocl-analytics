ActiveAdmin.register CountryStadistic do
  permit_params :pageviews, :avgtimeonpage, :url_id, :date, :users, :country_code, :country_name
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
    column :country_code
    column :pageviews
    column :avgtimeonpage
    actions
  end

  filter :url, label: 'Nombre del articulo', as: :select, input_html: {class: 'chosen-input'}
  #filter :url_id, label: 'URL ID', as: :number
  filter :date
  filter :country_code, as: :select, collection: Country.for_select, input_html: {class: 'chosen-input'}

  form do |f|
    f.inputs "Estadisticas de país" do
      f.input :url, :as => :select, :input_html => { :class => "chosen-input"}
      f.input :date
      f.input :country_name
      f.input :country_code
      f.input :pageviews
      f.input :users
      f.input :avgtimeonpage
    end
    f.actions
  end

  controller do
    def scoped_collection
      CountryStadistic.by_assigned_country
    end
  end
end