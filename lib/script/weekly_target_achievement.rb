class Script::WeeklyTargetAchievement

  def achieve
    start_date = Time.current.prev_week.since(4.hours)
    weekly_targets = WeeklyTarget
      .where('start_date = ? AND progress >= target_time', start_date)
      .includes(user: :experience)
    weekly_targets.each do |weekly_target|
      weekly_target.achieve = true
      user = weekly_target.user
      experience_record = WeeklyTargetProcessor.new(user)
        .experience_record(weekly_target)
      user.experience += experience_record.experience_point
      ExperienceRecorder.new(user).check_level
      user.experience.save!
      weekly_target.save!
    end
  end
end
