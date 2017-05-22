class AnalyticData
  include FactoryGirl::Syntax::Methods

  def initialize(source, start_date, end_date, url)
    @source = source
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
      date.strftime('%Y%m%d')
    end

    def create_analytic_date(date)
      FactoryGirl.create( name_factory , date: date)
    end

    def name_factory
      ('analytic_' + @source.downcase).to_sym
    end

end
