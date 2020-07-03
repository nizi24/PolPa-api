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


  #コードが冗長でわかりにくいので、必要総経験値から減算する方法にすると単純になるかも
  # private def check_level(gain_exp)
  #   to_next = @user.experience.to_next
  #   to_next -= gain_exp
  #   if to_next <= 0
  #     # next_level = RequiredExp.find_by(level: @user.experience.level + 1)
  #     # sub_next = next_level.required_exp - (- to_next)
  #     level_up(sub_next)
  #   else
  #     @user.experience.to_next = to_next
  #   end
  # end
  #
  # private def level_up(sub_next)
  #   next_level = RequiredExp.find_by(level: @user.experience.level + 1)
  #   if sub_next > 0
  #     @user.experience.level += 1
  #     @user.experience.to_next = next_level.required_exp - sub_next
  #   else
  #     @user.experience.level += 1
  #     sub_next += next_level.required_exp
  #     level_up(sub_next)
  #   end
  # end
end
