module RakeHelpers

  def counter
    @count = (@count.nil?) ? 1 : @count + 1
  end

  def count_messages_status(count)
    expect(Message.where(status:  MessageStatus::WAIT).count).to eq(count)
    expect(Message.where(status:  MessageStatus::SUCCESS).count).to eq(count)
    expect(Message.where(status:  MessageStatus::ERROR).count).to eq(0)
  end

  def is_update(args = {})
    let!(:url) { 'http://www.upsocl.com/branded/10-looks-para-que-te-atrevas-a-usar-la-tendencia-que-se-tomo-instagram-pestanas-de-colores/' }
    let!(:line_id) { 437733004 }
    let!(:url_test) { create(:url, data: url, line_id: line_id, publication_date: args[:start_date], publication_end_date: args[:end_date] ) }
    describe do
      it 'should be' do
        subject.invoke
        expect(PageStadistic.where(url:  url_test).count).to eq(args[:analytics])
        expect(DeviceStadistic.where(url:  url_test).count).to eq(args[:analytics])
        expect(TrafficStadistic.where(url:  url_test).count).to eq(args[:analytics])
        expect(CountryStadistic.where(url:  url_test).count).to eq(args[:analytics])
        expect(DfpStadistic.where(url:  url_test).count).to eq(args[:dfp])
        count_messages_status(counter)
      end
    end
  end
end
