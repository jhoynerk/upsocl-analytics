require 'rails_helper'

describe AnalyticsFindOrCreate do
  let!(:page_stadistic) { FactoryGirl.attributes_for(:page_stadistic) }
  let!(:country_stadistic) { FactoryGirl.attributes_for(:country_stadistic) }
  let!(:traffic_stadistic) { FactoryGirl.attributes_for(:traffic_stadistic) }
  let!(:device_stadistic) { FactoryGirl.attributes_for(:device_stadistic) }
  let(:model_page) { 'PageStadistic' }
  let(:model_country) { 'CountryStadistic' }
  let(:model_traffic) { 'TrafficStadistic' }
  let(:model_device) { 'DeviceStadistic' }

  it "should be valid with page_stadistic" do
    expect(AnalyticsFindOrCreate.new( page_stadistic ).find_or_create( model_page )).to eq(true)
  end

  it "should be valid with country_stadistic" do
    expect(AnalyticsFindOrCreate.new( country_stadistic ).find_or_create( model_country )).to eq(true)
  end

  it "should be valid with traffic_stadistic" do
    expect(AnalyticsFindOrCreate.new( traffic_stadistic ).find_or_create( model_traffic )).to eq(true)
  end

  it "should be valid with device_stadistic" do
    expect(AnalyticsFindOrCreate.new( device_stadistic ).find_or_create( model_device )).to eq(true)
  end

  it "should not be valid when create model 'country_stadistic' with parameters other" do
    expect(AnalyticsFindOrCreate.new( page_stadistic ).find_or_create( model_country )).to eq(false)
    expect(AnalyticsFindOrCreate.new( traffic_stadistic ).find_or_create( model_country )).to eq(false)
    expect(AnalyticsFindOrCreate.new( device_stadistic ).find_or_create( model_country )).to eq(false)
  end

  it "should not be valid when create model 'traffic_stadistic' with parameters other" do
    expect(AnalyticsFindOrCreate.new( page_stadistic ).find_or_create( model_traffic )).to eq(false)
    expect(AnalyticsFindOrCreate.new( country_stadistic ).find_or_create( model_traffic )).to eq(false)
    expect(AnalyticsFindOrCreate.new( device_stadistic ).find_or_create( model_traffic )).to eq(false)
  end

  it "should not be valid when create model 'country_stadistic' with parameters other" do
    expect(AnalyticsFindOrCreate.new( page_stadistic ).find_or_create( model_device )).to eq(false)
    expect(AnalyticsFindOrCreate.new( country_stadistic ).find_or_create( model_device )).to eq(false)
    expect(AnalyticsFindOrCreate.new( traffic_stadistic ).find_or_create( model_device )).to eq(false)
  end
end
