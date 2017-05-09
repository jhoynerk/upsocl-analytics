describe "analytics:update" do
  include_context "rake"

  DatabaseCleaner.clean
  context 'Update Analytics' do

    let!(:url_not_active) { create(:url) }
    let!(:url_active_week) { create(:url, data: 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/', line_id: 437733004, publication_date: 8.days.ago, publication_end_date: 1.days.ago) }
    let!(:url_active_month) { create(:url, data: 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/', line_id: 437733004, publication_date: 32.days.ago, publication_end_date: 1.days.ago) }
    let!(:url_active_not_dfp) { create(:url, data: 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/', line_id: 0, publication_date: 8.days.ago, publication_end_date: 1.days.ago) }
    before{ subject.invoke }


    it "generate a message report wait and success" do
      expect(Message.where(status:  MessageStatus::WAIT).count).not_to eq(0)
      expect(Message.where(status:  MessageStatus::SUCCESS).count).not_to eq(0)
    end

    it 'Check the result of different types of urls to be updated' do
      expect(PageStadistic.where(url:  url_not_active).count).to eq(0)
      expect(DeviceStadistic.where(url:  url_not_active).count).to eq(0)
      expect(TrafficStadistic.where(url:  url_not_active).count).to eq(0)
      expect(CountryStadistic.where(url:  url_not_active).count).to eq(0)
      expect(DfpStadistic.where(url:  url_not_active).count).to eq(0)

      expect(PageStadistic.where(url:  url_active_week).count).not_to eq(0)
      expect(DeviceStadistic.where(url:  url_active_week).count).not_to eq(0)
      expect(TrafficStadistic.where(url:  url_active_week).count).not_to eq(0)
      expect(CountryStadistic.where(url:  url_active_week).count).not_to eq(0)
      expect(DfpStadistic.where(url:  url_active_week).count).not_to eq(0)

      expect(PageStadistic.where(url:  url_active_month).count).not_to eq(0)
      expect(DeviceStadistic.where(url:  url_active_month).count).not_to eq(0)
      expect(TrafficStadistic.where(url:  url_active_month).count).not_to eq(0)
      expect(CountryStadistic.where(url:  url_active_month).count).not_to eq(0)
      expect(DfpStadistic.where(url:  url_active_month).count).not_to eq(0)

      expect(PageStadistic.where(url:  url_active_not_dfp).count).not_to eq(0)
      expect(DeviceStadistic.where(url:  url_active_not_dfp).count).not_to eq(0)
      expect(TrafficStadistic.where(url:  url_active_not_dfp).count).not_to eq(0)
      expect(CountryStadistic.where(url:  url_active_not_dfp).count).not_to eq(0)
      expect(DfpStadistic.where(url:  url_active_not_dfp).count).to eq(0)
    end

  end

end

