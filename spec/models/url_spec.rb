require 'rails_helper'

describe Url do
  let!(:facebook_account) { create(:facebook_account) }
  let!(:url_inactive) { create(:url) }
  let!(:url_active) { create(:url, publication_date: 5.days.ago, publication_end_date: 0.days.ago) }
  let!(:url_active_week) { create(:url, publication_date: 8.days.ago, publication_end_date: 1.days.ago) }
  let!(:url_active_month) { create(:url, publication_date: 32.days.ago, publication_end_date: 1.days.ago) }

  it 'when this url creates a title should be' do
    title = 'El juez se levanta totalmente cautivado cuando esta pareja hace esto. Te pasará lo mismo'
    expect(url_inactive.title).to eq(title)
  end

  it 'last update' do
    expect(url_inactive.last_update_date.to_date).to eq(Date.today)
  end


  describe 'Search for urls to update' do
    it { expect( Url.search_urls_to_update ).to eq([url_active, url_active_week, url_active_month ]) }

    it 'When the publication date was completed two days ago' do
      url_active.update(publication_end_date: 2.days.ago)
      expect( Url.search_urls_to_update ).to eq([ url_active_week, url_active_month ])
    end

    it 'When the date for publication is completed in two days' do
      url_active.update(publication_end_date: 2.days.since)
      expect( Url.search_urls_to_update ).to eq([ url_active_week, url_active_month, url_active ])
    end
  end

end
