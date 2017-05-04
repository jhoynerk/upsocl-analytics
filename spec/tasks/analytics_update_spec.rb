describe "analytics:update" do
  include_context "rake"

  context 'Update Analytics' do
    let!(:url_branded) { create(:url, status: true, data: 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/', line_id: 437733004) }
    before{ subject.invoke }

    it "generate a message report wait" do
      expect(Message.where(status:  MessageStatus::WAIT).count).to eq(1)
    end

    it "generate a message report success" do
      expect(Message.where(status:  MessageStatus::SUCCESS).count).not_to eq(0)
    end

    it 'Analytics count greater than by 0' do
      expect(PageStadistic.where(url:  url_branded).count).not_to eq(0)
      expect(DeviceStadistic.where(url:  url_branded).count).not_to eq(0)
      expect(TrafficStadistic.where(url:  url_branded).count).not_to eq(0)
      expect(CountryStadistic.where(url:  url_branded).count).not_to eq(0)
    end

  end

end

