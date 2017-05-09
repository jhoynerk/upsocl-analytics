ActiveAdmin.register CountryStadistic do
  include AvgUtils

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
      f.input :avgtimeonpage, as: :time_picker, input_html: { step: :second }
    end
    f.actions
  end
  def avg_from_params(params, resource)
    params[resource.model_name.param_key][:avgtimeonpage]
  end

  def time_converted_to_integer(params, resource)
    time_avg = avg_from_params(params, resource)
    DateTime.strptime("1970-01-01 #{time_avg}", '%Y-%m-%d %H:%M:%S').strftime("%s")
  end
end
