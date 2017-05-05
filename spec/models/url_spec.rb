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

  it 'the date for the update is equal to the date when it is created.' do
    expect(new_url.set_update_date).to eq(new_url.created_at)
  end

  describe 'Search for urls to update' do
    let!(:url_active_week) { create(:url, status: true, data_updated_at: 8.days.ago, created_at: 8.days.ago) }
    let!(:url_active_month) { create(:url, status: true, data_updated_at: 32.days.ago, created_at: 32.days.ago) }
    describe 'when status is active to update' do
      it { expect( url.status ).to eq( false ) }
      it { expect( url_active.status ).to eq( true ) }
      it { expect( Url.update_active ).to eq( [ url_active, url_active_week, url_active_month ] ) }
    end

    describe 'when it is within the update time limit' do
      it { expect( Url.update_active.max_month_update(3) ).to eq( [ url_active, url_active_week, url_active_month ] ) }
    end

    describe 'when the urls must have a week of being updated' do
      it { expect( Url.last_update_greater_one_week ).to eq([ url_active_week, url_active_month ]) }
      it 'when you do not have an update week' do
        url_active_week.update(data_updated_at: 6.days.ago)
        expect( Url.last_update_greater_one_week ).to eq([ url_active_month ])
      end
      it 'When you do not have a week of creation' do
        url_active_week.update(created_at: 6.days.ago)
        expect( Url.last_update_greater_one_week ).to eq([ url_active_month ])
      end
    end

    describe 'when the urls must have a month of being updated' do
      it { expect( Url.last_update_greater_one_month ).to eq([ url_active_month ]) }
      it { expect( Url.update_monthly ).to eq( [ url_active_month ] ) }
    end

    describe 'search all urls to update' do
      it { expect( Url.search_urls_to_update ).to eq([ url_active, url_active_week, url_active_month ])}
    end

  end

end
