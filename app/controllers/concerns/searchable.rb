module Searchable
  extend ActiveSupport::Concern

   module ClassMethods
     def search(params)
       results = self.where(nil)
       params.each do |key, value|
         results = results.public_send(key.to_s, value) if param_valid?(key, value)
       end
       results
     end

     private
     def param_valid?(key, value)
        respond_to?(key) && !value.blank?
     end
   end
end
