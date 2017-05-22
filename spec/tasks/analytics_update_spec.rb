require 'rails_helper'
include RakeHelpers

describe "analytics:update" do
  include_context "rake"

  context 'When the article was published in ' do
    is_update({ start_date: 15.days.ago, end_date: 7.days.ago, analytics: 0, dfp: 0 })
    is_update({ start_date: 2.month.ago, end_date: 1.month.ago, analytics: 0, dfp: 0 })
  end

  context 'When the article is published last week' do
    is_update({ start_date: 7.month.ago, end_date: 1.days.ago, analytics: 7, dfp: 7 })
  end

  context 'When the article is published the last 6 days' do
    is_update({ start_date: 6.days.ago, end_date: 1.days.ago, analytics: 6, dfp: 6 })
  end

  context 'When the article is published the last 5 days' do
    is_update({ start_date: 5.days.ago, end_date: 1.days.ago, analytics: 5, dfp: 5 })
  end

  context 'When the article is published the last 4 days' do
    is_update({ start_date: 4.days.ago, end_date: 1.days.ago, analytics: 4, dfp: 4 })
  end

  context 'When the article is published the last 1 days' do
    is_update({ start_date: 1.days.ago, end_date: 14.days.since, analytics: 1, dfp: 1 })
  end

  context 'When the article is published the following week' do
    is_update({ start_date: 7.days.since, end_date: 14.days.since, analytics: 0, dfp: 0 })
  end

  context 'When the article is published today' do
    is_update({ start_date: Date.today, end_date: 14.days.since, analytics: 0, dfp: 0 })
  end

  context 'When the article is published last week But not' do
    is_update({ start_date: 7.month.ago, end_date: 1.days.ago, analytics: 7, dfp: 0, line_id: 0 })
  end

end
