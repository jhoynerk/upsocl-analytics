class Form < ActiveRecord::Base
  validates :name, :last_name, :email, :address, :path_url, presence: true
  validates :email, uniqueness: { case_sensitive: false }
end
