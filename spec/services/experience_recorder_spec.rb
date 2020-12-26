require 'rails_helper'

describe ExperienceRecorder do

  let!(:user) { create(:user) }
  let!(:experience) { create(:experience, user: user) }

  describe '#record' do

    context '1つレベルアップする時' do
      it '正しくレベルアップすること' do
        time_report = create(:time_report, study_time: '2000-01-01 0:51:00')
        ExperienceRecorder.new(user).record(time_report)
        expect(user.experience.level).to eq 2
        expect(user.experience.total).to eq 51
        expect(user.experience.to_next).to eq 53
      end
    end

    context '2以上レベルアップする時' do
      it '正しくレベルアップすること' do
        time_report = create(:time_report, study_time: '2000-01-01 6:20:00')
        ExperienceRecorder.new(user).record(time_report)
        expect(user.experience.level).to eq 7
        expect(user.experience.total).to eq 6 * 60 + 20
        expect(user.experience.to_next).to eq 24
      end
    end

    context 'レベルアップしない時' do
      it '経験値が更新されること' do
        time_report = create(:time_report, study_time: '2000-01-01 0:20:00')
        ExperienceRecorder.new(user).record(time_report)
        expect(user.experience.level).to eq 1
        expect(user.experience.total).to eq 20
        expect(user.experience.to_next).to eq 30
      end
    end

    context '境界値' do
      it '正しくレベルアップすること' do
        time_report = create(:time_report, study_time: '2000-01-01 6:44:00')
        ExperienceRecorder.new(user).record(time_report)
        expect(user.experience.level).to eq 8
        expect(user.experience.total).to eq 6 * 60 + 44
        expect(user.experience.to_next).to eq 66
      end
    end

    context 'タイムレポートを更新して経験値が増える時' do
      it '経験値が更新されること' do
        time_report = create(:time_report, study_time: '2000-01-01 0:20:00')
        ExperienceRecorder.new(user).record(time_report)
        time_report.update(study_time: '2000-01-01 1:00:00')
        ExperienceRecorder.new(user).record(time_report)
        expect(user.experience.level).to eq 2
        expect(user.experience.total).to eq 1 * 60
        expect(user.experience.to_next).to eq 44
      end
    end

    context 'タイムレポートを更新して経験値が減る時' do
      it 'レベルが下がること' do
        time_report = create(:time_report, study_time: '2000-01-01 1:00:00')
        ExperienceRecorder.new(user).record(time_report)
        time_report.update(study_time: '2000-01-01 0:20:00')
        ExperienceRecorder.new(user).record(time_report)
        expect(user.experience.level).to eq 1
        expect(user.experience.total).to eq 20
        expect(user.experience.to_next).to eq 30
      end

      it 'レベルが複数下がること' do
        time_report = create(:time_report, study_time: '2000-01-01 3:00:00')
        ExperienceRecorder.new(user).record(time_report)
        time_report.update(study_time: '2000-01-01 1:00:00')
        ExperienceRecorder.new(user).record(time_report)
        expect(user.experience.level).to eq 2
        expect(user.experience.total).to eq 60
        expect(user.experience.to_next).to eq 44
      end
    end
  end

  describe '#delete_record' do

    context 'タイムレポートを削除した時' do
      it '総経験値は下がること' do
        time_report = create(:time_report, study_time: '2000-01-01 0:20:00')
        ExperienceRecorder.new(user).record(time_report)
        ExperienceRecorder.new(user).delete_record(time_report)
        expect(user.experience.level).to eq 1
        expect(user.experience.total).to eq 0
        expect(user.experience.to_next).to eq 50
      end

      it 'レベルが一つ下がること' do
        time_report = create(:time_report, study_time: '2000-01-01 1:00:00')
        ExperienceRecorder.new(user).record(time_report)
        ExperienceRecorder.new(user).delete_record(time_report)
        expect(user.experience.level).to eq 1
        expect(user.experience.total).to eq 0
        expect(user.experience.to_next).to eq 50
      end

      it 'レベルが複数下がること' do
        time_report = create(:time_report, study_time: '2000-01-01 2:00:00')
        ExperienceRecorder.new(user).record(time_report)
        ExperienceRecorder.new(user).delete_record(time_report)
        expect(user.experience.level).to eq 1
        expect(user.experience.total).to eq 0
        expect(user.experience.to_next).to eq 50
      end

      it '連続して削除できること' do
        time_report1 = create(:time_report, study_time: '2000-01-01 2:00:00')
        time_report2 = create(:time_report, study_time: '2000-01-01 2:00:00')
        time_report3 = create(:time_report, study_time: '2000-01-01 1:00:00')
        time_report4 = create(:time_report, study_time: '2000-01-01 0:01:00')
        ExperienceRecorder.new(user).record(time_report1)
        ExperienceRecorder.new(user).record(time_report2)
        ExperienceRecorder.new(user).record(time_report3)
        ExperienceRecorder.new(user).record(time_report4)
        ExperienceRecorder.new(user).delete_record(time_report1)
        ExperienceRecorder.new(user).delete_record(time_report2)
        ExperienceRecorder.new(user).delete_record(time_report3)
        expect(user.experience.level).to eq 1
        expect(user.experience.total).to eq 1
        expect(user.experience.to_next).to eq 49
      end
    end
  end

  describe '#check_level' do
    context 'レベルが300の時' do
      it 'レベルが上がらないこと' do
        user.experience.level = 299
        user.experience.total = 249300
        user.experience.to_next = 300
        ExperienceRecorder.new(user).check_level
        expect(user.experience.level).to eq 300
        expect(user.experience.to_next).to eq 0
      end
    end
  end
end
