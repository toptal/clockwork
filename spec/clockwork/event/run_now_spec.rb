require 'spec_helper'

describe Clockwork::Event do
  include_context :event

  describe '#run_now?' do
    let(:run_now) { subject.run_now?(time) }

    context 'when period is 1 day' do
      let(:period) { 1.day }

      it { expect(run_now).to be_truthy }

      context 'when we want to run at 02:01' do
        let(:at) { '02:01' }
        let(:run_now) { subject.run_now?(time) }

        context 'when time is: mar 27 2016 03:01:00 CEST (on 2016-03-27 we change time from 02:00 to 03:00)' do
          let(:time) { Time.zone.local(2016, 3, 27, 3, 1) }

          it { expect(run_now).to be_truthy }
        end

        context 'when time is: oct 30 2016 02:01:00 CET (on 2016-10-30 we change time from 03:00 to 02:00)' do
          let(:time) { Time.zone.local(2016, 10, 30, 2, 1) }

          it { expect(run_now).to be_truthy }
        end
      end

      context 'when we want to run at 03:01' do
        let(:at) { '03:01' }
        let(:run_now) { subject.run_now?(time) }

        context 'when time is: mar 27 2016 03:01:00 CEST (on 2016-03-27 we change time from 02:00 to 03:00)' do
          let(:time) { Time.zone.local(2016, 3, 27, 3, 1) }

          it { expect(run_now).to be_truthy }
        end

        context 'when time is: oct 30 2016 02:01:00 CET (on 2016-10-30 we change time from 03:00 to 02:00)' do
          let(:time) { Time.zone.local(2016, 10, 30, 3, 1) }

          it { expect(run_now).to be_truthy }
        end
      end
    end

    context 'when period is 1 week' do
      let(:period) { 1.week }

      it { expect(run_now).to be_truthy }

      context 'when we want to run at 02:01' do
        let(:at) { '02:01' }

        context 'when time is: mar 27 2016 03:01:00 CEST (on 2016-03-27 we change time from 02:00 to 03:00)' do
          let(:time) { Time.zone.local(2016, 3, 27, 3, 1) }

          it { expect(run_now).to be_truthy }
        end

        context 'when time is: oct 30 2016 02:01:00 CET (on 2016-10-30 we change time from 03:00 to 02:00)' do
          let(:time) { Time.zone.local(2016, 10, 30, 2, 1) }

          it { expect(run_now).to be_truthy }
        end
      end

      context 'when we want to run at 03:01' do
        let(:at) { '03:01' }

        context 'when time is: mar 27 2016 03:01:00 CEST (on 2016-03-27 we change time from 02:00 to 03:00)' do
          let(:time) { Time.zone.local(2016, 3, 27, 3, 1) }

          it { expect(run_now).to be_truthy }
        end

        context 'when time is: oct 30 2016 02:01:00 CET (on 2016-10-30 we change time from 03:00 to 02:00)' do
          let(:time) { Time.zone.local(2016, 10, 30, 3, 1) }

          it { expect(run_now).to be_truthy }
        end
      end

      context 'when we want to run at 02:01 on Sunday' do
        let(:at) { 'Sunday 02:01' }

        context 'when time is: mar 27 2016 03:01:00 CEST (on 2016-03-27 we change time from 02:00 to 03:00)' do
          let(:time) { Time.zone.local(2016, 3, 27, 3, 1) }

          it { expect(run_now).to be_truthy }
        end

        context 'when time is: oct 30 2016 02:01:00 CET (on 2016-10-30 we change time from 03:00 to 02:00)' do
          let(:time) { Time.zone.local(2016, 10, 30, 2, 1) }

          it { expect(run_now).to be_truthy }
        end
      end

      context 'when we want to run at 03:01 on Sunday' do
        let(:at) { 'Sunday 03:01' }

        context 'when time is: mar 27 2016 03:01:00 CEST (on 2016-03-27 we change time from 02:00 to 03:00)' do
          let(:time) { Time.zone.local(2016, 3, 27, 3, 1) }

          it { expect(run_now).to be_truthy }
        end

        context 'when time is: oct 30 2016 02:01:00 CET (on 2016-10-30 we change time from 03:00 to 02:00)' do
          let(:time) { Time.zone.local(2016, 10, 30, 3, 1) }

          it { expect(run_now).to be_truthy }
        end
      end
    end

    context 'when period is 1 month' do
      let(:period) { 1.month }

      it { expect(run_now).to be_truthy }

      context 'when we want to run at 02:01' do
        let(:at) { '02:01' }

        context 'when time is: mar 27 2016 03:01:00 CEST (on 2016-03-27 we change time from 02:00 to 03:00)' do
          let(:time) { Time.zone.local(2016, 3, 27, 3, 1) }

          it { expect(run_now).to be_truthy }
        end

        context 'when time is: oct 30 2016 02:01:00 CET (on 2016-10-30 we change time from 03:00 to 02:00)' do
          let(:time) { Time.zone.local(2016, 10, 30, 2, 1) }

          it { expect(run_now).to be_truthy }
        end
      end

      context 'when we want to run at 03:01' do
        let(:at) { '03:01' }

        context 'when time is: mar 27 2016 03:01:00 CEST (on 2016-03-27 we change time from 02:00 to 03:00)' do
          let(:time) { Time.zone.local(2016, 3, 27, 3, 1) }

          it { expect(run_now).to be_truthy }
        end

        context 'when time is: oct 30 2016 02:01:00 CET (on 2016-10-30 we change time from 03:00 to 02:00)' do
          let(:time) { Time.zone.local(2016, 10, 30, 3, 1) }

          it { expect(run_now).to be_truthy }
        end
      end

      context 'when we want to run at 02:01 on Sunday' do
        let(:at) { 'Sunday 02:01' }

        context 'when time is: mar 27 2016 03:01:00 CEST (on 2016-03-27 we change time from 02:00 to 03:00)' do
          let(:time) { Time.zone.local(2016, 3, 27, 3, 1) }

          it { expect(run_now).to be_truthy }
        end

        context 'when time is: oct 30 2016 02:01:00 CET (on 2016-10-30 we change time from 03:00 to 02:00)' do
          let(:time) { Time.zone.local(2016, 10, 30, 2, 1) }

          it { expect(run_now).to be_truthy }
        end
      end

      context 'when we want to run at 03:01 on Sunday' do
        let(:at) { 'Sunday 03:01' }

        context 'when time is: mar 27 2016 03:01:00 CEST (on 2016-03-27 we change time from 02:00 to 03:00)' do
          let(:time) { Time.zone.local(2016, 3, 27, 3, 1) }

          it { expect(run_now).to be_truthy }
        end

        context 'when time is: oct 30 2016 02:01:00 CET (on 2016-10-30 we change time from 03:00 to 02:00)' do
          let(:time) { Time.zone.local(2016, 10, 30, 3, 1) }

          it { expect(run_now).to be_truthy }
        end
      end
    end
  end
end
