require 'spec_helper'

describe Clockwork::Event do
  include_context :event

  describe '#at_ok_for_run_now?' do
    let(:at_ok_for_run_now) { subject.send(:at_ok_for_run_now?, time) }

    it 'is a private method' do
      expect { subject.at_ok_for_run_now?(time) }.to raise_error(NoMethodError)
    end

    context 'when at is nil' do
      let(:at) { nil }

      it { expect(at_ok_for_run_now).to be_truthy }
    end

    context 'when we want to run at 02:01' do
      let(:at) { '02:01' }

      describe '#run_now?' do
        context 'when time is: mar 27 2016 03:01:00 CEST (on 2016-03-27 we change time from 02:00 to 03:00)' do
          let(:time) { Time.zone.local(2016, 3, 27, 3, 1) }

          it { expect(at_ok_for_run_now).to be_truthy }
        end

        context 'when time is: oct 30 2016 02:01:00 CET (on 2016-10-30 we change time from 03:00 to 02:00)' do
          let(:time) { Time.zone.local(2016, 10, 30, 2, 1) }

          it { expect(at_ok_for_run_now).to be_truthy }
        end
      end
    end

    context 'when we want to run at 03:01' do
      let(:at) { '03:01' }

      describe '#run_now?' do
        context 'when time is: mar 27 2016 03:01:00 CEST (on 2016-03-27 we change time from 02:00 to 03:00)' do
          let(:time) { Time.zone.local(2016, 3, 27, 3, 1) }

          it { expect(at_ok_for_run_now).to be_truthy }
        end

        context 'when time is: oct 30 2016 02:01:00 CET (on 2016-10-30 we change time from 03:00 to 02:00)' do
          let(:time) { Time.zone.local(2016, 10, 30, 3, 1) }

          it { expect(at_ok_for_run_now).to be_truthy }
        end
      end
    end
  end

  describe '#dst_adjusted_period' do
    let(:time) { Time.now }
    let(:dst_adjusted_period) { subject.send(:dst_adjusted_period, time) }

    context 'when period is 1 day' do
      let(:period) { 1.day }

      it 'is a private method' do
        expect { subject.dst_adjusted_period }.to raise_error(NoMethodError)
      end

      context 'when time is: mar 26 2016 03:01:00 CEST' do
        let(:time) { Time.zone.local(2016, 3, 26, 3, 1) }

        it { expect(dst_adjusted_period).to eq(period) }
      end

      context 'when time is: mar 27 2016 03:01:00 CEST' do
        # on 2016-03-27 we change time from 02:00 to 03:00
        let(:time) { Time.zone.local(2016, 3, 27, 3, 1) }

        it  { expect(dst_adjusted_period).to eq(period - 1.hour) }
      end

      context 'when time is: oct 30 2016 02:01:00 CET' do
        # on 2016-10-30 we change time from 03:00 to 02:00
        let(:time) { Time.zone.local(2016, 10, 30, 3, 1) }

        it { expect(dst_adjusted_period).to eq(period) }
      end
    end
  end
end
