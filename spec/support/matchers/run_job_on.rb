RSpec::Matchers.define :run_job_on do |expected|
  match do |actual|
    expected_timestamp = if expected.is_a?(Time)
      expected
    else
      Time.parse(expected)
    end
    actual.tick(expected_timestamp).size == 1
  end

  def events_details
    actual.instance_variable_get('@events').map do |event|
      event_details = EventDetails.new(event)
      {
        job: event_details.job,
        period: event_details.period,
        at: event_details.at_details,
      }.inspect
    end.join(', ')
  end

  failure_message do |actual|
    "expected to run job on #{expected} but it did not, events were: #{events_details}"
  end
end
