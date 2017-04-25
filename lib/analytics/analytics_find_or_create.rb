class AnalyticsFindOrCreate

  def initialize(data)
    @data = data
  end

  def find_or_create(model)
    model.constantize.find_or_create_attributes( @data ).update_attrs( @data )
  end

end

