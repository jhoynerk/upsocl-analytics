class Analytic::Traffic
  extend Legato::Model

  metrics :pageviews, :visitors
  dimensions :page_path, :traffictype, :date

  filter :path, &lambda {|path| matches(:page_path, path)}
end
