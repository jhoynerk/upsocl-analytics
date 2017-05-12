module UrlsUtils
  extend ActiveSupport::Concern

  included do
    belongs_to :url
  end

end



