class DateFilter < EnumerateIt::Base
  associate_values( all: 0, currents: 1, weeks_ago: 2 )
end
