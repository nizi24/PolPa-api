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
    total_hours = total_study_time / 60
    total_minutes = total_study_time % 60
    time_format = total_hours.to_s + ':' + total_minutes.to_s
    weekly_target.progress = time_format
    weekly_target.save!
  end
end
