describe "analytics:update" do
  include_context "rake"

  DatabaseCleaner.clean

  before do
    subject.invoke
    @count = (@count.nil?) ? 1 : @count + 1
  end

  context 'When the article has already passed a week of its date to be able to update.' do
    count_messages_status(@count)
    #testing({ start_date: 15.days.ago, end_date: 7.days.ago, analytics: 0, dfp: 0, count: @count })
  end

end

def testing(args = {})
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

