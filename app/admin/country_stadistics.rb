ActiveAdmin.register CountryStadistic do
  include AvgUtils

  permit_params :pageviews, :avgtimeonpage, :url_id, :date, :users, :country_code, :country_name
  menu parent: "Estadisticas URL"
  config.sort_order = 'campaign_name_asc'

  index do
    selectable_column
    column :campaign_name
    column(:url) do |u|
      link_to truncate(u.url_title, length: 50), details_admin_url_path(u.url_id, country: u.country_code), method: :post
    end
    column :country_code
    column :pageviews
    column :avgtimeonpage
  end
  filter :url, label: 'Nombre del articulo', as: :select, input_html: {class: 'chosen-input'}
  filter :country_code, as: :select, collection: Country.for_select, input_html: {class: 'chosen-input'}
  form do |f|
    f.inputs "Estadisticas de País" do
      f.input :url, :as => :select, :input_html => { :class => "chosen-input"}
      f.input :date
      f.input :country_name
      f.input :country_code
      f.input :pageviews
      f.input :users
      f.input :avgtimeonpage, as: :time_picker, input_html: { step: :second }
    end
    f.actions
  end

  controller do
    def index
      @country_stadistics = collection.page(params[:page]).grouped_by_country
    end
  end

end