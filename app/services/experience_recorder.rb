class ExperienceRecorder

  def initialize(user)
    @user = user
  end

  def record(time_report)
    hours = time_report.study_time.hour
    minutes = time_report.study_time.min
    gain_exp = hours * 60 + minutes

    experience_record = @user.experience_records.build(
      experience_point: gain_exp,
      time_report_id: time_report.id
    )

    if experience_record.save!
      @user.experience.total += gain_exp
      check_level
      @user.experience.save!
      experience_record
    end
  end

  private def check_level
    required = RequiredExp.find_by(level: @user.experience.level)
    sub_total = required.total_experience - @user.experience.total
    if sub_total <= 0
      @user.experience.level += 1
      check_level
    else
      @user.experience.to_next = sub_total
    end
  end
end
