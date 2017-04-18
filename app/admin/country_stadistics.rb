ActiveAdmin.register CountryStadistic do
  permit_params :pageviews, :avgtimeonpage, :url_id, :date, :users, :country_code, :country_name
  menu parent: "Estadisticas URL"

  index do
    selectable_column
    column(:campaña) do |u|
      u.url.campaign.name.titleize unless u.url.nil?
    end
    column(:url) do |u|
      truncate(u.url.title, length: 50) unless u.url.nil?
    end
    column :date
    column :country_code
    column :pageviews
    column :avgtimeonpage
    actions
  end

  filter :url
  filter :url_id
  filter :date
  filter :country_code

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

end
