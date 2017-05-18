class DfpData
  include FactoryGirl::Syntax::Methods

  def initialize(start_date, end_date, url)
    @start_date = start_date
    @end_date = end_date
    @url = url
  end

  def results
    date_limits.map { |date| create_analytic_date(format_date(date)) }
  end

  private
    def date_limits
      (@start_date.to_date..@end_date.to_date)
    end

    def format_date(date)
      date.strftime('%Y-%m-%d')
    end

    def create_analytic_date(date)
      FactoryGirl.build( :dfp_data , date: date, url: @url)
    end
end
