class Page
  extend Legato::Model

  metrics :pageviews, :visitors, :sessions, :timeonpage, :percent_new_visits 
  dimensions :page_path, :date

  filter :path, &lambda {|path| matches(:page_path, path)}
end
