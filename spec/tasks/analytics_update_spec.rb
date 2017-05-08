describe "analytics:update" do
  include_context "rake"

  DatabaseCleaner.clean
  context 'Update Analytics' do

    let!(:url_branded) { create(:url, status: true, data: 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/', line_id: 437733004) }
    let!(:url_active_week) { create(:url, status: true, data: 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/', line_id: 437733004, data_updated_at: 8.days.ago, created_at: 8.days.ago) }
    let!(:url_active_month) { create(:url, status: true, data: 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/', line_id: 437733004, data_updated_at: 32.days.ago, created_at: 32.days.ago) }
    let!(:url_inactive) { create(:url) }
    let!(:url_active_not_dfp) { create(:url, status: true, data: 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/', line_id: 0) }
    before{ subject.invoke }


    it "generate a message report wait and success" do
      expect(Message.where(status:  MessageStatus::WAIT).count).not_to eq(0)
      expect(Message.where(status:  MessageStatus::SUCCESS).count).not_to eq(0)
    end

    it 'Check the result of different types of urls to be updated' do
      expect(PageStadistic.where(url:  url_branded).count).not_to eq(0)
      expect(DeviceStadistic.where(url:  url_branded).count).not_to eq(0)
      expect(TrafficStadistic.where(url:  url_branded).count).not_to eq(0)
      expect(CountryStadistic.where(url:  url_branded).count).not_to eq(0)
      expect(DfpStadistic.where(url:  url_branded).count).not_to eq(0)

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

      expect(PageStadistic.where(url:  url_inactive).count).to eq(0)
      expect(DeviceStadistic.where(url:  url_inactive).count).to eq(0)
      expect(TrafficStadistic.where(url:  url_inactive).count).to eq(0)
      expect(CountryStadistic.where(url:  url_inactive).count).to eq(0)
      expect(DfpStadistic.where(url:  url_inactive).count).to eq(0)

      expect(PageStadistic.where(url:  url_active_not_dfp).count).not_to eq(0)
      expect(DeviceStadistic.where(url:  url_active_not_dfp).count).not_to eq(0)
      expect(TrafficStadistic.where(url:  url_active_not_dfp).count).not_to eq(0)
      expect(CountryStadistic.where(url:  url_active_not_dfp).count).not_to eq(0)
      expect(DfpStadistic.where(url:  url_active_not_dfp).count).to eq(0)
    end

  end

end

