class AnalyticTest

  def results(source, start_date, end_date, url)
    ('Test::' + source).new(source, start_date, end_date, url).contatize.results
  end

end

