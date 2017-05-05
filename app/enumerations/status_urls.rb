class StatusUrls < EnumerateIt::Base
  associate_values( inactive: false, active: true)
end
