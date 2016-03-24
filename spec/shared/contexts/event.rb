shared_context :event do
  let(:manager) { double }

  before do
    allow(manager).to receive(:config).and_return({ :thread => true })
    Time.zone = timezone
  end

  let(:time) { Time.zone.local(2016, 3, 26, 3, 1) }
  let(:block) { '' }
  let(:timezone) { 'Europe/Warsaw' }
  let(:at) { '03:01' }
  let(:options) { { at: at, tz: timezone } }
  let(:period) { 1.day }
  subject { Clockwork::Event.new(manager, period, 'job', block, options) }
end
