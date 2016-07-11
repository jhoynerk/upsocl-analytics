require 'rails_helper'

describe FacebookAccount do
  let!(:facebook_account) { create(:facebook_account) }

  it "should not be valid without a name" do
    facebook_account.name = nil
    expect(facebook_account).not_to be_valid
  end

  it "should be valid with a name" do
    facebook_account.name = Faker::Name.name
    expect(facebook_account).to be_valid
  end

  it "should not be valid when not is equal" do
    fba = FacebookAccount.new(name: Faker::Name.name, facebook_id: facebook_account.facebook_id)
    expect(fba).not_to be_valid
  end

  it "should not be valid without a facebook id" do
    facebook_account.facebook_id = nil
    expect(facebook_account).not_to be_valid
  end

  it "should be valid with a facebook id" do
    facebook_account.facebook_id = Faker::Number.number(15)
    expect(facebook_account).to be_valid
  end
end
