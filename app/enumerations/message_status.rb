class MessageStatus < EnumerateIt::Base
  associate_values( wait: 1, success: 2, error: 3 )
end
