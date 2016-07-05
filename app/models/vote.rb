class Vote < ActiveRecord::Base
  belongs_to :url
  belongs_to :reaction
end
