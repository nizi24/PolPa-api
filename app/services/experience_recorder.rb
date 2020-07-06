class ExperienceRecorder

  def initialize(user)
    @user = user
  end

  def record(time_report)
    gain_exp = cal_exp(time_report)

    experience_record = find_or_build(time_report, gain_exp)

    if experience_record.persisted?
      experience_record = update_record(experience_record, gain_exp)
      down_check = true
    end

    if experience_record.save!
      @user.experience.total += gain_exp
      check_level_down if down_check
      check_level
      @user.experience.save!
      experience_record
    end
  end

  def delete_record(time_report)
    experience_record = time_report.experience_record
    exp = experience_record.experience_point
    @user.experience.total -= exp
    check_level_down
    check_level
    @user.experience.save!
    experience_record.destroy!
  end

  private def cal_exp(time_report)
    hours = time_report.study_time.hour
    minutes = time_report.study_time.min
    gain_exp = hours * 60 + minutes
  end

  private def find_or_build(time_report, gain_exp)
    ExperienceRecord.find_by(time_report_id: time_report.id) ||
    @user.experience_records.build(
      experience_point: gain_exp,
      time_report_id: time_report.id
    )
  end

  private def update_record(experience_record, gain_exp)
    old_exp = experience_record.experience_point
    @user.experience.total -= old_exp
    @user.experience.to_next -= old_exp
    experience_record.experience_point = gain_exp
    experience_record
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

  private def check_level_down
    required = RequiredExp.find_by(level: @user.experience.level - 1)
    if required
      sub_total = required.total_experience - @user.experience.total
      if sub_total >= 0
        @user.experience.level -= 1
        check_level_down
      end
    end
  end
end
