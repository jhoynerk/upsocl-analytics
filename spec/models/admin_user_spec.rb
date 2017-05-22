require 'rails_helper'

describe User do
  let!(:user_admin) { create(:admin_user) }

  it "should not be valid without a email" do
    user_admin.email = nil
    expect(user_admin).not_to be_valid
  end

  it "should be valid with a email" do
    user_admin.email = "admim@example.com"
    expect(user_admin).to be_valid
  end
end
