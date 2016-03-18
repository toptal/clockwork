require 'spec_helper'

describe Clockwork::Manager do
  include_context :manager
  include_context :manager_timezone
  let(:timezone) { 'America/New_York' }

  context 'when have fully configured manager with many events' do
    before do
      subject.every(20.minutes, 'job every 20 minutes')
      subject.every(1.day, 'job everyday at 00:30', at: '00:30')
      subject.every(1.day, 'job every first of month at 01:00', at: '01:00', if: ->(t) { t.day == 1 })
      subject.every(1.day, 'job everyday at 01:30', at: '01:30')
      subject.every(1.day, [
        'job 1 at 02:00 everyday',
        'job 2 at 02:00 everyday',
        'job 3 at 02:00 everyday'
      ], at: '02:00')
      subject.every(1.day, 'job everyday at 02:30', at: '02:30')
      subject.every(1.day, 'job everyday at 03:00', at: '03:00')
      subject.every(1.day, 'another job everyday at 03:00', at: '03:00')
      subject.every(1.day, 'job everyday at 03:30', at: '03:30')
      subject.every(1.day, 'job everyday at 03:40', at: '03:40')
      subject.every(1.day, 'job everyday at 04:00', at: '04:00')
      subject.every(1.day, 'job everyday at 04:30', at: '04:30')
      subject.every(1.day, [
        'another job 1 at 04:30 everyday',
        'another job 2 at 04:30 everyday',
        'another job 3 at 04:30 everyday'
      ], at: '04:30')
      subject.every(1.day, 'job every Monday at 05:00', at: 'Monday 05:00')
      subject.every(1.day, 'job every Tuesday at 05:00', at: 'Tuesday 05:00')
      subject.every(1.day, 'job everyday at 06:00', at: '06:00')
      subject.every(1.day, 'job everyday at 00:02', at: '00:02')
      subject.every(1.day, 'job everyday at 06:20', at: '06:20')
      subject.every(
        1.week,
        'job every Monday, Wednesday and Friday at 09:00',
        at: ['Monday 09:00', 'Wednesday 09:00', 'Friday 09:00']
      )
      subject.every(1.day, ['job 1 at 09:30 everyday', 'job 2 at 09:30 everyday'], at: '09:00')
      subject.every(1.day, 'job everyday at 09:45', at: '09:45')
      subject.every(1.hour, 'job every hour at 15 minute', at: '**:15')
      subject.every(1.hour, 'job every hour at 2 minute', at: '**:02')
      subject.every(1.hour, 'job every hour at 34 minute', at: '**:34')
      subject.every(1.hour, 'job every hour at 5 minute', at: '**:05')
      subject.every(1.hour, 'job every hour at 20 minute', at: '**:20')
      subject.every(3.hour, 'job every 3 hours at 7 minute', at: '**:07')
      subject.every(1.hour, 'job every hour at 44 minute', at: '**:20')
      subject.every(1.day, 'another job everyday at 06:00', at: '06:00')
      subject.every(1.day, 'job everyday at 00:00', at: '00:00')
      subject.every(3.hour, 'job every 3 hours at 11 minute', at: '**:11')
      subject.every(1.week, 'job every week at 01:00', at: '01:00')
      subject.every(1.day, 'another job everyday at 00:00', at: '00:00')
    end

    shared_context :runs_daily_jobs_properly do
      it { is_expected.to run_job('job everyday at 00:30', today_at('00:30')) }
      it { is_expected.not_to run_job('job everyday at 00:30', today_at('00:31')) }

      it { is_expected.to run_job('job everyday at 01:30', today_at('01:30')) }
      it { is_expected.not_to run_job('job everyday at 01:30', today_at('01:29')) }

      specify do
        is_expected.to run_job(
          ['job 1 at 02:00 everyday', 'job 2 at 02:00 everyday', 'job 3 at 02:00 everyday'].to_s,
          today_at('02:00')
        )
      end
      specify do
        is_expected.not_to run_job(
          ['job 1 at 02:00 everyday', 'job 2 at 02:00 everyday', 'job 3 at 02:00 everyday'].to_s,
          today_at('02:10')
        )
      end

      it { is_expected.to run_job('job everyday at 03:00', today_at('03:00')) }
      it { is_expected.not_to run_job('job everyday at 03:00', today_at('03:02')) }

      it { is_expected.to run_job('another job everyday at 03:00', today_at('03:00')) }
      it { is_expected.not_to run_job('another job everyday at 03:00', today_at('03:03')) }
    end

    shared_context :runs_hourly_jobs_properly do
      it { is_expected.to run_job('job every hour at 15 minute', today_at('05:15')) }
      it { is_expected.to run_job('job every hour at 15 minute', [today_at('05:15'), today_at('06:15'), today_at('07:15')]) }
      it { is_expected.not_to run_job('job every hour at 15 minute', [today_at('05:15'), today_at('06:16'), today_at('07:15')]) }
      it { is_expected.not_to run_job('job every hour at 15 minute', today_at('05:16')) }

      it { is_expected.to run_job('job every 3 hours at 7 minute', today_at('05:07')) }
      it { is_expected.to run_job('job every 3 hours at 7 minute', [today_at('05:07'), today_at('08:07'), today_at('11:07')]) }
      it { is_expected.not_to run_job('job every 3 hours at 7 minute', [today_at('05:07'), today_at('08:08'), today_at('11:07')]) }
      it { is_expected.not_to run_job('job every 3 hours at 7 minute', [today_at('05:07'), today_at('06:07')]) }
      it { is_expected.not_to run_job('job every 3 hours at 7 minute', today_at('05:08')) }
    end

    shared_context :runs_everyday_jobs_properly do
      it_behaves_like :runs_daily_jobs_properly
      it_behaves_like :runs_hourly_jobs_properly

      it { is_expected.to run_job('job every 20 minutes', [today_at('01:00'), today_at('01:20')]) }
      it { is_expected.to run_job('job every 20 minutes', [today_at('01:00'), today_at('01:21'), today_at('01:41')]) }
      it { is_expected.not_to run_job('job every 20 minutes', [today_at('01:00'), today_at('01:19')]) }
    end

    shared_context :runs_weekly_jobs_properly do
      it { is_expected.to run_job('job every week at 01:00', today_at('01:00')) }
      it { is_expected.to run_job('job every week at 01:00', [today_at('01:00'), today_at('01:00').advance(weeks: 1)]) }
      it { is_expected.to run_job('job every week at 01:00', [today_at('01:00'), today_at('01:00').advance(weeks: 1, seconds: 1)]) }
      it { is_expected.not_to run_job('job every week at 01:00', [today_at('01:00'), today_at('01:00').advance(weeks: 1, minutes: 1)]) }
      it { is_expected.not_to run_job('job every week at 01:00', [today_at('01:00'), today_at('01:00').advance(days: 1)]) }
    end

    context 'when today is Tuesday 2016-03-01' do
      let(:date) { '2016-03-01' }

      it_behaves_like :runs_everyday_jobs_properly
      it_behaves_like :runs_weekly_jobs_properly

      it { is_expected.to run_job('job every first of month at 01:00', today_at('01:00')) }
      it { is_expected.not_to run_job('job every first of month at 01:00', today_at('01:01')) }

      it { is_expected.not_to run_job('job every Monday at 05:00', today_at('05:00')) }

      it { is_expected.to run_job('job every Tuesday at 05:00', today_at('05:00')) }
      it { is_expected.not_to run_job('job every Tuesday at 05:00', today_at('05:01')) }

      it { is_expected.not_to run_job('job every Monday, Wednesday and Friday at 09:00', today_at('09:00')) }
    end

    context 'when today is Wednesday 2016-03-02' do
      let(:date) { '2016-03-02' }

      it_behaves_like :runs_everyday_jobs_properly
      it_behaves_like :runs_weekly_jobs_properly

      it { is_expected.not_to run_job('job every first of month at 01:00', today_at('01:00')) }

      it { is_expected.not_to run_job('job every Monday at 05:00', today_at('05:00')) }

      it { is_expected.not_to run_job('job every Tuesday at 05:00', today_at('05:00')) }

      it { is_expected.to run_job('job every Monday, Wednesday and Friday at 09:00', today_at('09:00')) }
      it { is_expected.not_to run_job('job every Monday, Wednesday and Friday at 09:00', today_at('09:01')) }
    end

    context 'when today is Thursday 2016-03-03' do
      let(:date) { '2016-03-03' }

      it_behaves_like :runs_everyday_jobs_properly
      it_behaves_like :runs_weekly_jobs_properly

      it { is_expected.not_to run_job('job every first of month at 01:00', today_at('01:00')) }

      it { is_expected.not_to run_job('job every Monday at 05:00', today_at('05:00')) }

      it { is_expected.not_to run_job('job every Tuesday at 05:00', today_at('05:00')) }

      it { is_expected.not_to run_job('job every Monday, Wednesday and Friday at 09:00', today_at('09:00')) }
    end

    context 'when today is Friday 2016-03-04' do
      let(:date) { '2016-03-04' }

      it_behaves_like :runs_everyday_jobs_properly
      it_behaves_like :runs_weekly_jobs_properly

      it { is_expected.not_to run_job('job every first of month at 01:00', today_at('01:00')) }

      it { is_expected.not_to run_job('job every Monday at 05:00', today_at('05:00')) }

      it { is_expected.not_to run_job('job every Tuesday at 05:00', today_at('05:00')) }

      it { is_expected.to run_job('job every Monday, Wednesday and Friday at 09:00', today_at('09:00')) }
      it { is_expected.not_to run_job('job every Monday, Wednesday and Friday at 09:00', today_at('09:01')) }
    end

    shared_context :runs_monday_jobs_properly do
      it { is_expected.not_to run_job('job every first of month at 01:00', today_at('01:00')) }

      it { is_expected.to run_job('job every Monday at 05:00', today_at('05:00')) }

      it { is_expected.not_to run_job('job every Tuesday at 05:00', today_at('05:00')) }

      it { is_expected.to run_job('job every Monday, Wednesday and Friday at 09:00', today_at('09:00')) }
      it { is_expected.not_to run_job('job every Monday, Wednesday and Friday at 09:00', today_at('09:01')) }

      it { is_expected.to run_job('job every week at 01:00', today_at('01:00')) }
    end

    shared_context :runs_saturday_jobs_properly do
      it { is_expected.not_to run_job('job every first of month at 01:00', today_at('01:00')) }

      it { is_expected.not_to run_job('job every Monday at 05:00', today_at('05:00')) }

      it { is_expected.not_to run_job('job every Tuesday at 05:00', today_at('05:00')) }

      it { is_expected.not_to run_job('job every Monday, Wednesday and Friday at 09:00', today_at('09:00')) }

      it { is_expected.to run_job('job every week at 01:00', today_at('01:00')) }
    end

    shared_context :runs_sunday_jobs_properly do
      it { is_expected.not_to run_job('job every first of month at 01:00', today_at('01:00')) }

      it { is_expected.not_to run_job('job every Monday at 05:00', today_at('05:00')) }

      it { is_expected.not_to run_job('job every Tuesday at 05:00', today_at('05:00')) }

      it { is_expected.not_to run_job('job every Monday, Wednesday and Friday at 09:00', today_at('09:00')) }

      it { is_expected.to run_job('job every week at 01:00', today_at('01:00')) }
    end

    context 'when today is Monday 2016-03-07 (which is six days before day of DST adjustment)' do
      let(:date) { '2016-03-07' }

      it_behaves_like :runs_everyday_jobs_properly
      it_behaves_like :runs_monday_jobs_properly

      it 'handles DST time drift correctly for weekly recurring task' do
        is_expected.to run_job('job every week at 01:00', [today_at('01:00'), today_at('01:00').advance(weeks: 1)])
      end
    end

    context 'when today is Saturday 2016-03-12 (which is one day before day of DST adjustment)' do
      let(:date) { '2016-03-12' }

      it_behaves_like :runs_everyday_jobs_properly
      it_behaves_like :runs_saturday_jobs_properly

      it 'handles DST time drift correctly for weekly recurring task' do
        is_expected.to run_job('job every week at 01:00', [today_at('01:00'), today_at('01:00').advance(weeks: 1)])
      end

      it 'handles DST time drift correctly for daily recurring task' do
        is_expected.to run_job('job everyday at 01:30', [today_at('01:30'), today_at('01:30').advance(days: 1)])
      end
    end

    context 'when today is Sunday 2016-03-13 (which is day of DST adjustment)' do
      let(:date) { '2016-03-13' }

      it_behaves_like :runs_everyday_jobs_properly
      it_behaves_like :runs_sunday_jobs_properly

      it 'handles DST time drift correctly for hourly recurring task' do
        is_expected.to run_job('job every hour at 15 minute', [today_at('00:15'), today_at('01:15'), today_at('02:15') ])
      end

      it 'handles DST time drift correctly for 3-hour recurring task' do
        is_expected.to run_job('job every 3 hours at 7 minute', [today_at('00:07'), today_at('02:07')])
      end
    end

    context 'when today is Monday 2016-10-31 (which is six days before day of DST adjustment)' do
      let(:date) { '2016-10-31' }

      it_behaves_like :runs_everyday_jobs_properly
      it_behaves_like :runs_monday_jobs_properly

      it 'handles DST time drift correctly for weekly recurring task' do
        is_expected.to run_job('job every week at 01:00', [today_at('01:00'), today_at('01:00').advance(weeks: 1)])
      end
    end

    context 'when today is Saturday 2016-11-05 (which is one day before day of DST adjustment)' do
      let(:date) { '2016-11-05' }

      it_behaves_like :runs_everyday_jobs_properly
      it_behaves_like :runs_saturday_jobs_properly

      it 'handles DST time drift correctly for weekly recurring task' do
        is_expected.to run_job('job every week at 01:00', [today_at('01:00'), today_at('01:00').advance(weeks: 1)])
      end

      it 'handles DST time drift correctly for daily recurring task' do
        is_expected.to run_job('job everyday at 01:30', [today_at('01:30'), today_at('01:30').advance(days: 1)])
      end
    end

    context 'when today is Sunday 2016-11-06 (which is day of DST adjustment)' do
      let(:date) { '2016-11-06' }

      it_behaves_like :runs_everyday_jobs_properly
      it_behaves_like :runs_sunday_jobs_properly

      it 'handles DST time drift correctly for hourly recurring task' do
        is_expected.to run_job('job every hour at 15 minute', [today_at('00:15'), today_at('01:15'), today_at('02:15') ])
      end

      it 'handles DST time drift correctly for 3-hour recurring task' do
        is_expected.to run_job('job every 3 hours at 7 minute', [today_at('00:07'), today_at('02:07')])
      end
    end
  end
end
