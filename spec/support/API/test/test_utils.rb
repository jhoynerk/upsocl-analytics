module Test
  module TestUtils
    def initialize(source, start_date, end_date, url)
      @source = source
      @start_date = start_date
      @end_date = end_date
      @url = url
    end

    private
      def create_data_set
        date_limits.map { |date| create_analytic_date(format_date(date)) }
      end

      def date_limits
        (@start_date.to_date..@end_date.to_date)
      end

      def format_date(date)
        date.strftime('%Y%m%d')
      end
  end
end

