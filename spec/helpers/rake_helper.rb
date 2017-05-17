
module Helpers
  def count_messages_status(count)
    expect(Message.where(status:  MessageStatus::WAIT).count).to eq(count)
    expect(Message.where(status:  MessageStatus::SUCCESS).count).to eq(count)
    expect(Message.where(status:  MessageStatus::ERROR).count).to eq(0)
  end
end
