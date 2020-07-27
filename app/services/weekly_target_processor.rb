class WeeklyTargetProcessor

  def initialize(user)
    @user = user
  end

  def totalization(weekly_target)
    weekly_time_reports = @user.time_reports
      .where('time_reports.study_date >= ?', weekly_target.start_date)
      .select('time_reports.study_time')
    total_study_time = 0
    weekly_time_reports.each do |time_report|
      total_study_time += time_report.study_time.hour.to_i * 60
      total_study_time += time_report.study_time.min.to_i
    end
    total_days = total_study_time / (60 * 24)
    total_study_time -= total_days * (60 * 24)
    total_hours = total_study_time / 60
    total_minutes = total_study_time % 60
    time_format = "2000-01-0#{total_days + 1} #{total_hours}:#{total_minutes}"
    weekly_target.progress = time_format
    weekly_target.save!
  end

  def add_progress(time_report)
    start_date = Time.current.beginning_of_week
    weekly_target = @user.weekly_targets
      .find_by('weekly_targets.start_date = ?', start_date)
    if weekly_target && time_report.study_date >= start_date
      weekly_target.progress += time_report.study_time.hour * 3600
      weekly_target.progress += time_report.study_time.min * 60
      weekly_target.save!
      weekly_target
    end
  end

  # タイムレポートの更新前に減算する
  def sub_progress(time_report)
    start_date = Time.current.beginning_of_week
    weekly_target = @user.weekly_targets
      .find_by('weekly_targets.start_date = ?', start_date)
    if weekly_target && time_report.study_date >= start_date
      weekly_target.progress -= time_report.study_time.hour * 3600
      weekly_target.progress -= time_report.study_time.min * 60
      weekly_target.save!
      weekly_target
    end
  end

  # 固定で100exp 追加で目標時間の1/3のexp を加算する
  def experience_record(weekly_target)
    gain_exp = 100
    gain_exp += (weekly_target.target_time.day.to_i - 1) * 20 * 24
    gain_exp += weekly_target.target_time.hour.to_i * 20
    gain_exp += weekly_target.target_time.min.to_i / 3
    experience_record = weekly_target
      .build_weekly_target_experience_record(experience_point: gain_exp, user: weekly_target.user)
    experience_record.save!
    weekly_target.user.experience.total += gain_exp
    ExperienceRecorder.new(weekly_target.user).check_level
    weekly_target.user.experience.save!
  end
end
