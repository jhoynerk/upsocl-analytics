
module RakeHelpers
  def count_messages_status(count)
    expect(Message.where(status:  MessageStatus::WAIT).count).to eq(count)
    expect(Message.where(status:  MessageStatus::SUCCESS).count).to eq(count)
    expect(Message.where(status:  MessageStatus::ERROR).count).to eq(0)
  end

  def updated_test(args = {})
    let!(:url) { 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/' }
    let!(:line_id) { 437733004 }
    let!(:url_test) { create(:url, data: url, line_id: line_id, publication_date: args[:start_date], publication_end_date: args[:end_date] ) }

    it 'should be' do
      expect(PageStadistic.where(url:  url_test).count).to eq(args[:analytics])
      expect(DeviceStadistic.where(url:  url_test).count).to eq(args[:analytics])
      expect(TrafficStadistic.where(url:  url_test).count).to eq(args[:analytics])
      expect(CountryStadistic.where(url:  url_test).count).to eq(args[:analytics])
      expect(DfpStadistic.where(url:  url_test).count).to eq(args[:dfp])
    end
  end
end

