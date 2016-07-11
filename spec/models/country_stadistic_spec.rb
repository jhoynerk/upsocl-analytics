require 'rails_helper'

describe CountryStadistic do
  let!(:country_stadistic) { create(:country_stadistic) }

  it "should not be valid without a url" do
    country_stadistic.url = nil
    expect(country_stadistic).not_to be_valid
  end

  it "should be valid with a url" do
    country_stadistic.url = create(:url)
    expect(country_stadistic).to be_valid
  end

  it "should not be valid without a pageviews" do
    country_stadistic.pageviews = nil
    expect(country_stadistic).not_to be_valid
  end

  it "should be valid with a pageviews" do
    country_stadistic.pageviews = Faker::Number.number(3)
    expect(country_stadistic).to be_valid
  end
end
