ActiveAdmin.register CountryStadistic do
  permit_params :pageviews, :avgtimeonpage, :url_id, :date, :users, :country_code, :country_name
  menu parent: "Estadisticas URL"
  config.sort_order = 'country_code_asc'
  index do
    selectable_column
    column :campaign_name
    column(:url) do |u|
      link_to truncate(u.url_title, length: 50), details_admin_url_path(u.url_id, country: u.country_code), method: :post
    end
    #column :date
    column :country_code
    column :pageviews
    column :avgtimeonpage
    #actions
  end
  filter :url, label: 'Nombre del articulo', as: :select, input_html: {class: 'chosen-input'}
  filter :date
  filter :country_code, as: :select, collection: Country.for_select, input_html: {class: 'chosen-input'}
  form do |f|
    f.inputs "Estadisticas de País" do
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
      end_of_association_chain.group(:country_code, "campaigns.name", "urls.title","urls.id").joins(url: :campaign).select("campaigns.name as campaign_name, urls.title as url_title, urls.id as url_id, country_code, SUM(country_stadistics.pageviews) as pageviews, SUM(country_stadistics.avgtimeonpage) as avgtimeonpage").order("country_code")
    end
  end

end