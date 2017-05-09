module AvgUtils
  extend ActiveSupport::Concern

  def self.included(dsl)
    dsl.before_save do |resource|
      resource.avgtimeonpage = time_converted_to_integer(params, resource)
    end

    dsl.controller do
      def avg_from_params(params, resource)
        params[resource.model_name.param_key][:avgtimeonpage]
      end

      def time_converted_to_integer(params, resource)
        time_avg = avg_from_params(params, resource)
        DateTime.strptime("1970-01-01 #{time_avg}", '%Y-%m-%d %H:%M:%S').strftime("%s")
      end
    end
  end
end
