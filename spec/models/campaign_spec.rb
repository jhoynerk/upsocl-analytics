require 'rails_helper'

describe Campaign do
  let!(:campaign) { create(:campaign) }

  it "should not be valid without a name" do
    campaign.name = nil
    expect(campaign).not_to be_valid
  end

  it "should be valid with a name" do
    campaign.name = "example campaign"
    expect(campaign).to be_valid
  end

  it "when it has no links should be 0" do
    expect(campaign.num_urls).to eq(0)
  end
end
