require 'rails_helper'
include RakeHelpers

describe "analytics:update" do
  include_context "rake"

  context 'When the article has already passed a week of its date to be able to update.' do
    is_update({ start_date: 15.days.ago, end_date: 7.days.ago, analytics: 0, dfp: 0 })
  end

  context 'When the article has already passed a month of its date to be able to update.' do
    is_update({ start_date: 2.month.ago, end_date: 30.days.ago, analytics: 0, dfp: 0 })
  end

  context 'When a url is published to be updated for 1 week' do
    is_update({ start_date: 7.month.ago, end_date: 1.days.ago, analytics: 7, dfp: 7 })
  end

  context 'When a url is published to be updated for 6 days' do
    is_update({ start_date: 6.month.ago, end_date: 1.days.ago, analytics: 6, dfp: 6 })
  end

  context 'When a url is published to be updated for 5 days' do
    is_update({ start_date: 5.month.ago, end_date: 1.days.ago, analytics: 5, dfp: 5 })
  end

  context 'When a url is published to be updated for 4 days' do
    is_update({ start_date: 4.month.ago, end_date: 1.days.ago, analytics: 4, dfp: 4 })
  end

  context 'When a url is published to be updated for 1 days' do
    is_update({ start_date: 1.days.ago, end_date: 14.days.since, analytics: 1, dfp: 1 })
  end

  context 'When the url is published in a week, it should not obtain metrics.' do
    is_update({ start_date: 7.days.since, end_date: 14.days.since, analytics: 0, dfp: 0 })
  end

  context 'When the article is published today, it should not obtain metrics.' do
    is_update({ start_date: Date.today, end_date: 14.days.since, analytics: 0, dfp: 0 })
  end

  context 'When a url is published to be updated analytics, but not DFP' do
    #is_update({ start_date: 7.month.ago, end_date: 1.days.ago, analytics: 7, dfp: 0 })
  end

end
