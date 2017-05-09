ActiveAdmin.register CountryStadistic do
  permit_params :pageviews, :avgtimeonpage, :url_id, :date, :users, :country_code, :country_name
  menu parent: "Estadisticas URL"
  index do
    selectable_column
    column(:campaña) do |u|
      u.campaign_name
    end
    column(:url) do |u|
      link_to truncate(u.title, length: 50), details_admin_url_path(u.id, country: u.country_code), method: :post
    end
    #column :date
    column :country_code
    column :pageviews
    column :avgtimeonpage
    actions
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
      #end_of_association_chain.by_assigned_country.select(:country_code).distinct
      #User.group('date(created_at)').select('date(created_at), sum(id) as total_amount').first.attributes
      #Url.all.joins(:country_stadistics).select("SUM(country_stadistics.id) as total_amount, SUM(country_stadistics.pageviews) as pageviews, SUM(country_stadistics.avgtimeonpage) as avgtimeonpage").group(:country_code)
      #end_of_association_chain.totals_filtered_by
      #end_of_association_chain.totals(Country.limit(10))
      end_of_association_chain.group(:country_code).select("country_code, SUM(country_stadistics.pageviews) as pageviews, SUM(country_stadistics.avgtimeonpage) as avgtimeonpage")
      #Url.joins(:country_stadistics)
    end
  end

end