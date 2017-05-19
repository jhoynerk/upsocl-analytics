require 'rails_helper'

describe TypesHelpers do

  it "should be valid without a name" do
    expect(TrafficStadistics::TypesHelpers.type_by('pagina')).to eq(1)
  end

  it "should not be valid without a name" do
    expect(TrafficStadistics::TypesHelpers.type_by('casa')).to eq(0)
  end

  it "should not be valid without a name" do
    expect(TrafficStadistics::TypesHelpers.type_by('facebook')).to eq(1)
  end

end
