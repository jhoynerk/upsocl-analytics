class UrlStatus < EnumerateIt::Base
  associate_values( active: 0, finished: 1 )
end
