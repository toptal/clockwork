RSpec::Matchers.define :run_job do |job_name, timestamps|
  match do |actual|
    timestamps = [ timestamps ].flatten
    timestamps = timestamps.map do |timestamp|
      if timestamp.is_a?(Time)
        timestamp
      else
        Time.parse(timestamp)
      end
    end

    executed = timestamps.select do |timestamp|
      events_to_run = actual.send(:events_to_run, timestamp).map do |event|
        event_details = EventDetails.new(event)
        event_details.job
      end

      actual.tick(timestamp) # run events to have @last on each

      events_to_run.include?(job_name)
    end

    executed.size == timestamps.size
  end

  failure_message do |actual|
    "expected to run job on #{expected} but it did not"
  end
end
