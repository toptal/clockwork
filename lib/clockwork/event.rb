module Clockwork
  class Event
    attr_accessor :job, :last

    def initialize(manager, period, job, block, options={})
      validate_if_option(options[:if])
      @manager = manager
      @period = period
      @job = job
      @at = At.parse(options[:at])
      @last = nil
      @block = block
      @if = options[:if]
      @thread = options.fetch(:thread, @manager.config[:thread])
      @timezone = options.fetch(:tz, @manager.config[:tz])
    end

    def convert_timezone(t)
      @timezone ? t.in_time_zone(@timezone) : t
    end

    def run_now?(t)
      t = convert_timezone(t)
      elapsed_ready(t) && at_ok_for_run_now?(t) && if_ok_for_run_now?(t)
    end

    def thread?
      @thread
    end

    def run(t)
      @manager.log "Triggering '#{self}'"
      @last = convert_timezone(t)
      if thread?
        if @manager.thread_available?
          t = Thread.new do
            execute
          end
          t['creator'] = @manager
        else
          @manager.log_error "Threads exhausted; skipping #{self}"
        end
      else
        execute
      end
    end

    def to_s
      job.to_s
    end

    private
    def execute
      @block.call(@job, @last)
    rescue => e
      @manager.log_error e
      @manager.handle_error e
    end

    def dst_adjusted_period(t)
      return @period unless t.dst? && t.dst? != t.advance(seconds: -@period).dst?
      @period - 1.hour
    end

    def elapsed_ready(t)
      @last.nil? || (t - @last.to_i).to_i >= dst_adjusted_period(t)
    end

    def validate_if_option(if_option)
      if if_option && !if_option.respond_to?(:call)
        raise ArgumentError.new(':if expects a callable object, but #{if_option} does not respond to call')
      end
    end

    def at_ok_for_run_now?(t)
      return true if @at.nil?

      t1 = t.advance(days: -7) # to also support weekday (instead of -1)
      if t.dst?
        # time switched from non-DST to DST
        t2 = t1.advance(hours: -1) unless t.advance(hours: -1).dst?
      else
        # time switched from DST to non-DST
        t2 = t1.advance(hours: 1) if t.advance(hours: -1).dst?
      end
      # when time switch occurs we need to take 2 hours under consideration
      return ( @at.ready?(t1) || @at.ready?(t2) ) if t2

      @at.ready?(t)
    end

    def if_ok_for_run_now?(t)
      @if.nil? || @if.call(t)
    end
  end
end
