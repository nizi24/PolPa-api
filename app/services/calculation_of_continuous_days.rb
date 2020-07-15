class CalculationOfContinuousDays
  delegate :experience, to: :@user

  def initialize(user)
    @user = user
  end

  def date_judgment(time_report)
    today = Time.current.in_time_zone.all_day
    last_three_days = (3.days.ago.beginning_of_day..Time.current.end_of_day)
    report_date = time_report.study_date
    if today.include?(report_date)
      add_continous_days
    elsif last_three_days.include?(report_date)
      current_days = 0
      prev_continue_days_judgment(report_date, current_days)
    end
  end

  def add_continous_days
    prev_day = Time.current.yesterday
    prev_day_report = @user.time_reports
      .where(study_date: prev_day.in_time_zone.all_day)
    if prev_day_report
      experience.current_continue += 1
      if experience.max_continue < experience.current_continue
        experience.max_continue = experience.current_continue
      end
    end
  end

  # def prev_continue_days_judgment(report_date, current_days)
  #   prev_day = report_date.yesterday
  #   prev_day_report = @user.time_reports
  #     .where(study_date: prev_day.in_time_zone.all_day)
  #   if prev_day_report
  #     current_days += 1
  #     continue_days_judgment(prev_day, current_days)
  #   else
  #     next_continue_days_judgment
  #   end
  # end
  #
  # def next_continue_days_judgment
  # end

  def cal_bonus_magnification
    continue_days = experience.current_continue
    bonus_magnification = 1
    if continue_days >= 7
      bonus_magnification = 1.5
    elsif current_days >= 3
      bonus_magnification += (continue_days - 2) / 10
    end
  end
end
