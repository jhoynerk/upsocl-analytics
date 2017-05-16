describe "analytics:update" do
  include_context "rake"

  DatabaseCleaner.clean
  context 'Update Analytics' do

    let!(:url_week_ago) { create(:url, line_id: 437733004, publication_date: 15.days.ago, publication_end_date: 7.days.ago) }
    let!(:url_month_ago) { create(:url, line_id: 437733004, publication_date: 2.month.ago, publication_end_date: 30.days.ago) }
    let!(:url_published_week) { create(:url, data: 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/', line_id: 437733004, publication_date: 7.days.ago, publication_end_date: 1.days.ago) }
    let!(:url_published_6_days) { create(:url, data: 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/', line_id: 437733004, publication_date: 6.days.ago, publication_end_date: 1.days.ago) }
    let!(:url_published_5_days) { create(:url, data: 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/', line_id: 437733004, publication_date: 5.days.ago, publication_end_date: 1.days.ago) }
    let!(:url_published_4_days) { create(:url, data: 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/', line_id: 437733004, publication_date: 4.days.ago, publication_end_date: 1.days.ago) }
    let!(:url_published_1_days) { create(:url, data: 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/', line_id: 437733004, publication_date: 1.days.ago, publication_end_date: 14.days.since) }
    let!(:url_published_in_week) { create(:url, data: 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/', line_id: 437733004, publication_date: 7.days.since, publication_end_date: 14.days.since) }
    let!(:url_published_today) { create(:url, data: 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/', line_id: 437733004, publication_date: Date.today, publication_end_date: 14.days.since) }
    let!(:url_published_week_not_dfp) { create(:url, data: 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/', line_id: 0, publication_date: 8.days.ago, publication_end_date: 1.days.ago) }
    before{ subject.invoke }


    it "generate a message report wait and success" do
      expect(Message.where(status:  MessageStatus::WAIT).count).not_to eq(0)
      expect(Message.where(status:  MessageStatus::SUCCESS).count).not_to eq(0)
      expect(Message.where(status:  MessageStatus::ERROR).count).to eq(0)
    end

    describe 'Check the result of different types of urls to be updated' do
      it 'When the article has already passed a week of its date to be able to update.' do
        expect(PageStadistic.where(url:  url_week_ago).count).to eq(0)
        expect(DeviceStadistic.where(url:  url_week_ago).count).to eq(0)
        expect(TrafficStadistic.where(url:  url_week_ago).count).to eq(0)
        expect(CountryStadistic.where(url:  url_week_ago).count).to eq(0)
        expect(DfpStadistic.where(url:  url_week_ago).count).to eq(0)
      end

      it 'When the article has already passed a month of its date to be able to update.' do
        expect(PageStadistic.where(url:  url_month_ago).count).to eq(0)
        expect(DeviceStadistic.where(url:  url_month_ago).count).to eq(0)
        expect(TrafficStadistic.where(url:  url_month_ago).count).to eq(0)
        expect(CountryStadistic.where(url:  url_month_ago).count).to eq(0)
        expect(DfpStadistic.where(url:  url_month_ago).count).to eq(0)
      end

      it 'When a url is published to be updated for 1 week' do
        expect(PageStadistic.where(url:  url_published_week).count).to eq(7)
        expect(DeviceStadistic.where(url:  url_published_week).count).to eq(7)
        expect(TrafficStadistic.where(url:  url_published_week).count).to eq(7)
        expect(CountryStadistic.where(url:  url_published_week).count).to eq(7)
        expect(DfpStadistic.where(url:  url_published_week).count).to eq(7)
      end

      it 'When a url is published to be updated for 6 days' do
        expect(PageStadistic.where(url: url_published_6_days).count).to eq(6)
        expect(DeviceStadistic.where(url:  url_published_6_days).count).to eq(6)
        expect(TrafficStadistic.where(url:  url_published_6_days).count).to eq(6)
        expect(CountryStadistic.where(url:  url_published_6_days).count).to eq(6)
        expect(DfpStadistic.where(url:  url_published_6_days).count).to eq(6)
      end

      it 'When a url is published to be updated for 5 days' do
        expect(PageStadistic.where(url: url_published_5_days).count).to eq(5)
        expect(DeviceStadistic.where(url:  url_published_5_days).count).to eq(5)
        expect(TrafficStadistic.where(url:  url_published_5_days).count).to eq(5)
        expect(CountryStadistic.where(url:  url_published_5_days).count).to eq(5)
        expect(DfpStadistic.where(url:  url_published_5_days).count).to eq(5)
      end

      it 'When a url is published to be updated for 4 days' do
        expect(PageStadistic.where(url: url_published_4_days).count).to eq(4)
        expect(DeviceStadistic.where(url:  url_published_4_days).count).to eq(4)
        expect(TrafficStadistic.where(url:  url_published_4_days).count).to eq(4)
        expect(CountryStadistic.where(url:  url_published_4_days).count).to eq(4)
        expect(DfpStadistic.where(url:  url_published_4_days).count).to eq(4)
      end

      it 'When a url is published to be updated for 1 days' do
        expect(PageStadistic.where(url: url_published_4_days).count).to eq(4)
        expect(DeviceStadistic.where(url:  url_published_4_days).count).to eq(4)
        expect(TrafficStadistic.where(url:  url_published_4_days).count).to eq(4)
        expect(CountryStadistic.where(url:  url_published_4_days).count).to eq(4)
        expect(DfpStadistic.where(url:  url_published_4_days).count).to eq(4)
      end

      it 'When the url is published in a week, it should not obtain metrics.' do
        expect(PageStadistic.where(url: url_published_in_week).count).to eq(0)
        expect(DeviceStadistic.where(url:  url_published_in_week).count).to eq(0)
        expect(TrafficStadistic.where(url:  url_published_in_week).count).to eq(0)
        expect(CountryStadistic.where(url:  url_published_in_week).count).to eq(0)
        expect(DfpStadistic.where(url:  url_published_in_week).count).to eq(0)
      end

      it 'When the article is published today, it should not obtain metrics.' do
        expect(PageStadistic.where(url: url_published_today).count).to eq(0)
        expect(DeviceStadistic.where(url:  url_published_today).count).to eq(0)
        expect(TrafficStadistic.where(url:  url_published_today).count).to eq(0)
        expect(CountryStadistic.where(url:  url_published_today).count).to eq(0)
        expect(DfpStadistic.where(url:  url_published_today).count).to eq(0)
      end

      it 'When a url is published to be updated analytics, but not DFP' do
        expect(PageStadistic.where(url:  url_published_week_not_dfp).count).to eq(7)
        expect(DeviceStadistic.where(url:  url_published_week_not_dfp).count).to eq(7)
        expect(TrafficStadistic.where(url:  url_published_week_not_dfp).count).to eq(7)
        expect(CountryStadistic.where(url:  url_published_week_not_dfp).count).to eq(7)
        expect(DfpStadistic.where(url:  url_published_week_not_dfp).count).to eq(0)
      end

    end

  end

end

