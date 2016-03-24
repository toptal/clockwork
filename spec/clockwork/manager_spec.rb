require 'spec_helper'

describe Clockwork::Manager do
  include_context :manager

  context 'when using timezone' do
    include_context :manager_timezone

    context 'Europe/Warsaw' do
      let(:timezone) { 'Europe/Warsaw' }

      context 'when running everyday' do
        before { subject.every(1.day, 'myjob', at: at, tz: timezone) }

        context 'at 02:01' do
          let(:at) { '02:01' }

          # on 2016-03-27 we change time from 02:00 to 03:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 3, 27, 3, 1)) }

          # on 2016-10-30 we change time from 03:00 to 02:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 10, 30, 2, 1)) }
        end

        context 'at 03:01' do
          let(:at) { '03:01' }

          # on 2016-03-27 we change time from 02:00 to 03:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 3, 27, 3, 1)) }

          # on 2016-10-30 we change time from 03:00 to 02:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 10, 30, 3, 1)) }
        end
      end

      context 'when running every week' do
        before { subject.every(1.week, 'myjob', at: at, tz: timezone) }

        context 'at 02:01' do
          let(:at) { '02:01' }

          # on 2016-03-27 we change time from 02:00 to 03:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 3, 27, 3, 1)) }

          # on 2016-10-30 we change time from 03:00 to 02:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 10, 30, 2, 1)) }
        end

        context 'at 03:01' do
          let(:at) { '03:01' }

          # on 2016-03-27 we change time from 02:00 to 03:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 3, 27, 3, 1)) }

          # on 2016-10-30 we change time from 03:00 to 02:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 10, 30, 3, 1)) }
        end

        context 'at 02:01 on Sundays' do
          let(:at) { 'Sunday 02:01' }

          # on 2016-03-27 we change time from 02:00 to 03:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 3, 27, 3, 1)) }

          # on 2016-10-30 we change time from 03:00 to 02:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 10, 30, 2, 1)) }
        end

        context 'at 03:01 on Sundays' do
          let(:at) { 'Sunday 03:01' }

          # on 2016-03-27 we change time from 02:00 to 03:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 3, 27, 3, 1)) }

          # on 2016-10-30 we change time from 03:00 to 02:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 10, 30, 3, 1)) }
        end

        context 'at 02:01 on Mondays' do
          let(:at) { 'Monday 02:01' }

          # on 2016-03-27 we change time from 02:00 to 03:00
          it { is_expected.not_to run_job_on(Time.zone.local(2016, 3, 27, 3, 1)) }

          # on 2016-10-30 we change time from 03:00 to 02:00
          it { is_expected.not_to run_job_on(Time.zone.local(2016, 10, 30, 2, 1)) }
        end

        context 'at 03:01 on Mondays' do
          let(:at) { 'Monday 03:01' }

          # on 2016-03-27 we change time from 02:00 to 03:00
          it { is_expected.not_to run_job_on(Time.zone.local(2016, 3, 27, 3, 1)) }

          # on 2016-10-30 we change time from 03:00 to 02:00
          it { is_expected.not_to run_job_on(Time.zone.local(2016, 10, 30, 3, 1)) }
        end
      end
    end

    context 'America/New_York' do
      let(:timezone) { 'America/New_York' }

      context 'when running everyday' do
        before { subject.every(1.day, 'myjob', at: at, tz: timezone) }

        context 'at 01:01' do
          let(:at) { '01:01' }

          # on 2016-03-13 we change time from 01:00 to 02:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 3, 13, 1, 1)) }

          # on 2016-11-06 we change time from 02:00 to 01:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 11, 6, 1, 1)) }
        end

        context 'at 02:01' do
          let(:at) { '02:01' }

          # on 2016-03-13 we change time from 01:00 to 02:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 3, 13, 2, 01)) }

          # on 2016-11-06 we change time from 02:00 to 01:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 11, 6, 2, 1)) }
        end
      end

      context 'when running every week' do
        before { subject.every(1.week, 'myjob', at: at, tz: timezone) }

        context 'at 01:01' do
          let(:at) { '01:01' }

          # on 2016-03-13 we change time from 01:00 to 02:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 3, 13, 1, 1)) }

          # on 2016-11-06 we change time from 02:00 to 01:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 11, 6, 1, 1)) }
        end

        context 'at 02:01' do
          let(:at) { '02:01' }

          # on 2016-03-13 we change time from 01:00 to 02:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 3, 13, 2, 1)) }

          # on 2016-11-06 we change time from 02:00 to 01:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 11, 6, 2, 1)) }
        end

        context 'at 01:01 on Sundays' do
          let(:at) { 'Sunday 01:01' }

          # on 2016-03-13 we change time from 01:00 to 02:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 3, 13, 1, 1)) }

          # on 2016-11-06 we change time from 02:00 to 01:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 11, 6, 1, 1)) }
        end

        context 'at 02:01 on Sundays' do
          let(:at) { 'Sunday 02:01' }

          # on 2016-03-13 we change time from 01:00 to 02:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 3, 13, 2, 1)) }

          # on 2016-11-06 we change time from 02:00 to 01:00
          it { is_expected.to run_job_on(Time.zone.local(2016, 11, 6, 2, 1)) }
        end

        context 'at 01:01 on Saturdays' do
          let(:at) { 'Saturday 01:01' }

          # on 2016-03-13 we change time from 01:00 to 02:00
          it { is_expected.not_to run_job_on(Time.zone.local(2016, 3, 13, 1, 1)) }

          # on 2016-11-06 we change time from 02:00 to 01:00
          it { is_expected.not_to run_job_on(Time.zone.local(2016, 11, 6, 1, 1)) }
        end

        context 'at 02:01 on Saturdays' do
          let(:at) { 'Saturday 02:01' }

          # on 2016-03-13 we change time from 01:00 to 02:00
          it { is_expected.not_to run_job_on(Time.zone.local(2016, 3, 13, 2, 1)) }

          # on 2016-11-06 we change time from 02:00 to 01:00
          it { is_expected.not_to run_job_on(Time.zone.local(2016, 11, 6, 2, 1)) }
        end
      end
    end
  end
end
