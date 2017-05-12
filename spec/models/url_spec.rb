require 'rails_helper'

 DatabaseCleaner.clean
describe Url do
  let!(:url_inactive) { create(:url) }
  let!(:url_active) { create(:url, publication_date: 5.days.ago, publication_end_date: 0.days.ago) }
  let!(:url_active_week) { create(:url, publication_date: 8.days.ago, publication_end_date: 1.days.ago) }
  let!(:url_active_month) { create(:url, publication_date: 32.days.ago, publication_end_date: 1.days.ago) }


  it 'when this url creates a title should be' do
    title = 'El juez se levanta totalmente cautivado cuando esta pareja hace esto. Te pasará lo mismo'
    expect(url_inactive.title).to eq(title)
  end

  it 'date for last update' do
    expect(url_inactive.data_updated_at.to_date).to eq(Date.today)
  end

  it 'When update stadistic facebook' do
    url = create(:url_with_facebook, post_id: "825943334240548")
    url.update_stadistics
    expect(url.facebook_likes).not_to eq(0)
    expect(url.facebook_comments).not_to eq(0)
    expect(url.facebook_shares).not_to eq(0)
  end

  describe 'Find all urls for a month' do
    let(:date) { Date.today }
    it 'all urls creates' do
      expect(Url.by_year_to_month(date.year , date.month) ).to match_array([url_inactive, url_active, url_active_week, url_active_month])
    end

    it 'When you change the month of the creation date' do
      url_inactive.update(created_at: 1.month.ago)
      expect(Url.by_year_to_month(date.year , date.month) ).to match_array([url_active, url_active_week, url_active_month])
    end
  end

  it 'When data change run task' do
    title = url_inactive.title
    url_inactive.update(data: 'http://www.upsocl.com/branded/10-cosas-que-suceden-cuando-comienzas-a-tomar-tus-propias-decisiones/')
    expect(url_inactive.title).not_to eq(title)
  end

  it 'When you update facebook statistics but the post_id is wrong' do
    expect { create(:url_with_facebook, post_id: "2323321") }.to raise_error(ActiveRecord::RecordInvalid,'La validación falló: Post post_id no existe para esta cuenta de facebook')
  end

  it 'Extract end of url' do
    url_inactive.update(data: 'http://www.upsocl.com/branded/10-cosas-que-suceden-cuando-comienzas-a-tomar-tus-propias-decisiones/')
    expect(url_inactive.only_path).to eq('/branded/10-cosas-que-suceden-cuando-comienzas-a-tomar-tus-propias-decisiones/')
  end

  describe 'Search for urls to update' do
    it { expect( Url.search_urls_to_update ).to match_array([url_active, url_active_week, url_active_month ]) }

    it 'When the publication date was completed two days ago' do
      url_active.update(publication_end_date: 2.days.ago)
      expect( Url.search_urls_to_update ).to match_array([ url_active_week, url_active_month ])
    end

    it 'When the date for publication is completed in two days' do
      url_active.update(publication_end_date: 2.days.since)
      expect( Url.search_urls_to_update ).to match_array([ url_active_week, url_active_month, url_active ])
    end
  end

end
