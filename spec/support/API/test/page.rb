class Test::Page
  include TestUtils
  include FactoryGirl::Syntax::Methods

  def results
    create_data_set
  end

  private
    def create_analytic_date(date)
      FactoryGirl.create(:page, date: date)
    end
end
