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

  it 'When consulting statistics should' do
    expect( url_active.stadistics ).to include('device_stadistics' => [], 'traffic_stadistics' => [], 'country_stadistics' => [], 'page_stadistics' => ActiveRecord::AssociationRelation, 'dfp_stadistics' => Hash)
  end

  it 'When consulting total statistics should' do
    expect( url_active.totals_stadistics ).to include(pageviews: Integer, users: Integer, avgtimeonpage: String)
    expect( url_active.totals_stadistics ).not_to include(pageviews: nil, users: nil, avgtimeonpage: nil)
    expect( url_active.totals_stadistics ).not_to match(pageviews: Integer, users: Integer, avgtimeonpage: nil)
    expect( url_active.totals_stadistics ).not_to match(pageviews: Integer, users: nil, avgtimeonpage: String)
    expect( url_active.totals_stadistics ).not_to match(pageviews: nil, users: Integer, avgtimeonpage: String)
  end

  it 'When consulting total statistics should' do
    url_with_country = create(:url_with_country)
    expect( url_with_country.totals_stadistics ).to include(pageviews: Integer, users: Integer, avgtimeonpage: String)
  end

  it 'Convert seconds to minutes and seconds' do
    expect( Url.new().toClock(1) ).to eq("00:01")
    expect( Url.new().toClock(10) ).to eq("00:10")
    expect( Url.new().toClock(60) ).to eq("01:00")
  end

  it 'When consult total pageviews eq 0' do

    expect( url_active.total_pageviews ).to eq(0)
  end

  it 'When consult total pageviews eq 20' do
    page_stadistic = create(:page_stadistic, url: url_active, pageviews: 20, date: 3.days.ago)
    expect( url_active.total_pageviews ).to eq(20)
  end

  it 'When consult total pageviews eq 70' do
    page_stadistic = create( :page_stadistic, url: url_active, pageviews: 20, date: 1.days.ago )
    page_stadistic = create( :page_stadistic, url: url_active, pageviews: 50, date: 2.days.ago )
    expect( url_active.total_pageviews ).to eq(70)
  end

  it 'Count votes to reactions' do
    reaction = create(:reaction)
    expect( Url.last.count_votes ).to match([{ title: reaction.title, reaction_id: reaction.id, counts: Integer }])
    reaction = create(:reaction)
    expect( Url.last.count_votes ).to match(Reaction.all.map{ |r| {title: r.title, reaction_id: r.id, counts: Integer} })

    expect( Url.last.builder_reactions ).to match( {"#{Reaction.last.title}" => Integer, "#{Reaction.first.title}" => Integer} )
  end

  it 'When multiple URLs from the same campaign' do
    campaign = create(:campaign)
    url_campaign_1 = create(:url, campaign: campaign)
    url_campaign_2 = create(:url, campaign: campaign)
    url_campaign_3 = create(:url, campaign: campaign)
    expect( url_campaign_1.campaign_urls ).to match_array([ url_campaign_1, url_campaign_2, url_campaign_3 ])

    expect( url_campaign_2.next_url ).to eq( url_campaign_3 )
    expect( url_campaign_2.previous_url ).to eq( url_campaign_1 )
    expect( url_campaign_3.previous_url ).to eq( url_campaign_2 )
    expect( url_campaign_3.next_url ).to eq( nil )
    expect( url_campaign_1.previous_url ).to eq( nil )
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
