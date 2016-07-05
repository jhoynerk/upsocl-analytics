require 'rails_helper'

describe Country do
  let!(:country) { create(:country) }

  it "should not be valid without a name" do
    country.name = nil
    expect(country).not_to be_valid
  end

  it "should be valid with a name" do
    country.name = Faker::Address.country
    expect(country).to be_valid
  end

  it "should not be valid without a code" do
    country.code = nil
    expect(country).not_to be_valid
  end

  it "should be valid with a code" do
    country.code = Faker::Address.postcode
    expect(country).to be_valid
  end
end
