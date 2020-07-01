class ExperienceRecorder

  def initialize(user)
    @user = user
  end

  def record(time_report)
    hours,minutes = time_report.study_time.split(':')
    experience = hour * 60 + minutes

    experience_record = @user.experience_records.build(
      experience_point: experience,
      time_report_id: time_report.id
    )

    if experience_record.save
      experience_record
    end
  end
end
