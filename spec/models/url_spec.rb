require 'rails_helper'

describe Url do
  let!(:facebook_account) { create(:facebook_account) }
  let!(:url) { create(:url) }
  let!(:url_active) { create(:url, status: true) }
  let!(:new_url) { create(:url) }
  let!(:url_week) { create(:url) }

  it 'when this url creates a title should be' do
    title = 'El juez se levanta totalmente cautivado cuando esta pareja hace esto. Te pasará lo mismo'
    expect(url.title).to eq(title)
  end

  xit 'when the total data query facebook, should be different from nil' do
    expect(url.total_count_facebook).not_to be(nil)
  end

  it 'the date for the update is equal to the date when it is created.' do
    expect(new_url.set_update_date).to eq(new_url.created_at)
  end

  describe 'search for update urls' do
    let!(:interval_day) { 'DAY' }
    let!(:interval_month) { 'MONTH' }
    let!(:interval_month_six) { 'MONTH6' }
    xit 'when the interval is the day and the url is the day' do
      start_interval =  3.week.ago
      end_interval = Time.now
      expect(Url.update_interval(start_interval, end_interval, interval_day)).to eq([url, new_url, url_week])
    end

    xit 'when the interval is in the status DAY' do
      url.update_attributes(interval_status: IntervalStatus::DAY)
      start_interval =  3.week.ago
      end_interval = Time.now
      expect(Url.update_interval(start_interval, end_interval, interval_day)).to eq([new_url, url_week, url])
    end

    xit 'when the interval is the month and the url is the month' do
      url_week.created_at = ( Date.today - (2.month + 1.week ) )
      url_week.data_updated_at = url_week.created_at
      url_week.save!
      start_interval = 3.month.ago
      end_interval = 2.month.ago
      expect(Url.update_interval(start_interval, end_interval, interval_month)).to eq([url_week])
    end

    it 'when the interval is in the status MONTH' do
      url.update_attributes(interval_status: IntervalStatus::MONTH)
      start_interval = 3.month.ago
      end_interval = 2.month.ago
      expect(Url.update_interval(start_interval, end_interval, interval_month)).to eq([url])
    end

    it 'when the interval is the month and the url is the 6month' do
      url_week.created_at = 5.month.ago
      url_week.data_updated_at = url_week.created_at
      url_week.save!
      start_interval = 6.month.ago
      end_interval = 3.month.ago
      expect(Url.update_interval(start_interval, end_interval, interval_month_six)).to eq([url_week])
    end

    it 'when the interval is in the status 6MONTH' do
      url.update_attributes(interval_status: IntervalStatus::MONTH6)
      start_interval = 6.month.ago
      end_interval = 3.month.ago
      expect(Url.update_interval(start_interval, end_interval, interval_month_six)).to eq([url])
    end
  end

  describe 'Search for urls to update' do
    describe 'when status is active to update' do
      it { expect( url.status ).to eq( false ) }
      it { expect( url_active.status ).to eq( true ) }
      it { expect( Url.update_active ).to eq( [ url_active ] ) }
    end

    describe 'when it is within the update time limit' do
      it { expect( Url.update_active.max_month_update(3) ).to eq( [ url_active ] ) }
    end

    describe 'when the urls must have a week of being updated' do
      let!(:url_active_week) { create(:url, status: true, data_updated_at: 8.days.ago, created_at: 8.days.ago) }
      it { expect( Url.last_update_greater_one_week ).to eq([ url_active_week ]) }
    end

  end

end
