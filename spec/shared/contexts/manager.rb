shared_context :manager do
  before do
    class << subject
      def log(msg); end
    end
    subject.handler { }
  end
end

shared_context :manager_timezone do
  before do
    subject.configure { |config| config[:tz] = timezone }
    Time.zone = timezone
  end
end
