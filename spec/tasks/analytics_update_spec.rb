require 'rails_helper'

include RakeHelpers

describe "analytics:update" do
  include_context "rake"

  DatabaseCleaner.clean

  # before do
  #   subject.invoke
  #   @count = (@count.nil?) ? 1 : @count + 1
  # end

  describe 'When the article has already passed a week of its date to be able to update.' do
    # count_messages_status(@count)
    is_update({ start_date: 15.days.ago, end_date: 7.days.ago, analytics: 0, dfp: 0, count: 0 })
  end

end
