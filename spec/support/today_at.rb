module TodayAt
  def today_at(time)
    year, month, day = date.split('-')
    hour, min = time.split(':')
    Time.zone.local(year.to_i, month.to_i, day.to_i, hour.to_i, min.to_i)
  end
end

RSpec.configure do |config|
  config.include TodayAt
end
