class EventDetails
  def initialize(event)
    @event = event
  end

  def job
    @event.to_s
  end

  def period
    @event.instance_variable_get('@period')
  end

  def at_details
    [ wday, time ].compact.join(' ') if at
  end

  private

  def wday
    at.instance_variable_get('@wday') if at
  end

  def time
    [ hour, minute ].join(':')
  end

  def hour
    "%02d" % hour_raw if hour_raw
  end

  def hour_raw
    at.instance_variable_get('@hour') if at
  end

  def minute
    "%02d" % minute_raw if minute_raw
  end

  def minute_raw
    at.instance_variable_get('@min') if at
  end

  def at
    @at ||= @event.instance_variable_get('@at')
  end
end
