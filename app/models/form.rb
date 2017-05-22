class Form < ActiveRecord::Base
  validates :name, :last_name, :email, :address, :path_url, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end

end
