module RecordAnalytics
  extend ActiveSupport::Concern

  module ClassMethods
    def find_or_create_attributes(attributes)
      self.find_or_create_by(self.parameters(attributes))
    end
  end

  def update_attrs(attributes)
    update(search_parameters(attributes))
  end
end
