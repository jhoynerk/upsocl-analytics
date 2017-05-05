module RecordAnalytics
  extend ActiveSupport::Concern

  included do
    belongs_to :url
  end

  module ClassMethods
    def find_or_create_attributes(attributes)
      self.find_or_create_by(self.parameters(attributes))
    end
  end

  def update_attrs(attributes)
    update(search_parameters(attributes))
  end
end
