require 'rails_helper'

RSpec.describe TimeCard, type: :model do
  describe '正常' do
    it "user_id, date, work_time, start_time, finish_time, break_timeがある場合有効" do
    end
  end

  describe '異常となること' do
    context "user_idが異常" do
      it "nilの場合無効" do
        timecard = FactoryBot.build(:time_card, user_id: nil)
        timecard.valid?
        expect(timecard.errors[:user]).to include("を入力してください")
      end
      it "該当するuserが存在しない場合無効" do
        timecard = FactoryBot.build(:time_card, user_id: "122")
        timecard.valid?
        expect(timecard.errors[:user]).to include("を入力してください")
      end
    end

    context "dateが異常" do
      it "nilの場合無効" do
        timecard = FactoryBot.build(:time_card, date: nil)
        timecard.valid?
        expect(timecard.errors[:date]).to include("を入力してください")
      end
      it "同日のレコードが存在している場合無効" do
        timecard1 = FactoryBot.create(:time_card, date: Date.today)
        timecard = FactoryBot.build(:time_card, user: timecard1.user, date: Date.today)
        timecard.valid?
        expect(timecard.errors[:base]).to include("同日の勤怠簿が存在します")
      end
      it "date以外の値は無効" do
        timecard = FactoryBot.build(:time_card, date: "a")
        timecard.valid?
        expect(timecard.errors[:date]).to include("を入力してください")
      end
    end

    context "start_timeが異常" do
      it "nilの場合無効" do
        timecard = FactoryBot.build(:time_card, start_time: nil)
        timecard.valid?
        expect(timecard.errors[:start_time]).to include("を入力してください")
      end
      it "dateと日付がズレていた場合無効" do
        timecard = FactoryBot.build(:time_card, date: Date.today, start_time: DateTime.now - 1)
        timecard.valid?
        expect(timecard.errors[:start_time]).to include("の日付が勤務日と違います")
      end
      it "datetime型以外は無効" do
        timecard = FactoryBot.build(:time_card, start_time: "a")
        timecard.valid?
        expect(timecard.errors[:start_time]).to include("を入力してください")
      end
    end

    context "finish_timeが異常" do
      it "nilの場合無効" do
        timecard = FactoryBot.build(:time_card, finish_time: nil)
        timecard.valid?
        expect(timecard.errors[:finish_time]).to include("を入力してください")
      end
      it "start_time以前の場合は無効" do
        time = DateTime.now
        timecard = FactoryBot.build(:time_card, start_time: time, finish_time: time.since(-1.hour))
        timecard.valid?
        expect(timecard.errors[:base]).to include("退勤時刻を出勤時刻より遅くしてください")
      end
      it "dateと日付がズレていた場合は無効" do
        timecard1 = FactoryBot.build(:time_card, date: Date.today, finish_time: DateTime.now-1)
        timecard1.valid?
        timecard2 = FactoryBot.build(:time_card, date: Date.today, finish_time: DateTime.now+1)
        timecard2.valid?
        expect(timecard1.errors[:finish_time]).to include("の日付が勤務日と違います")
        expect(timecard2.errors[:finish_time]).to include("の日付が勤務日と違います")
      end
      it "datetime型以外の値は無効" do
        timecard = FactoryBot.build(:time_card, finish_time: "a")
        timecard.valid?
        expect(timecard.errors[:finish_time]).to include("を入力してください")
      end
    end

    context "break_timeが異常" do
      it "nilの場合は無効" do
        timecard = FactoryBot.build(:time_card, break_time: nil)
        timecard.valid?
        expect(timecard.errors[:break_time]).to include("を入力してください")
      end
      it "数字以外の場合は無効" do
        timecard = FactoryBot.build(:time_card, break_time: "a")
        timecard.valid?
        expect(timecard.errors[:break_time]).to include("は数字で入力してください")
      end
      it "小数の場合は無効" do
        timecard = FactoryBot.build(:time_card, break_time: 10.1)
        timecard.valid?
        expect(timecard.errors[:break_time]).to include("は整数で入力してください")
      end
      it "finish_time-start_time<=break_timeの場合は無効" do
        time = DateTime.now
        timecard1 = FactoryBot.build(:time_card, start_time: time.since(-1.hour), finish_time: time, break_time: 60*60)
        timecard2 = FactoryBot.build(:time_card, start_time: time.since(-1.hour), finish_time: time, break_time: 60*60+1)
        timecard1.valid?
        timecard2.valid?
        expect(timecard1.errors[:base]).to include("勤務時間の内訳が異常です")
        expect(timecard2.errors[:base]).to include("勤務時間の内訳が異常です")
      end
    end

    context "work_timeが異常" do
      it "nilの場合は無効" do
        timecard = FactoryBot.build(:time_card, work_time: nil)
        timecard.valid?
        expect(timecard.errors[:work_time]).to include("が異常です")
      end
      it "数字以外の場合は無効" do
        timecard = FactoryBot.build(:time_card, work_time: "a")
        timecard.valid?
        expect(timecard.errors[:work_time]).to include("は数字で入力してください")
      end
      it "小数が含まれる場合は無効" do
        timecard = FactoryBot.build(:time_card, work_time: 1199.1)
        timecard.valid?
        expect(timecard.errors[:work_time]).to include("は整数で入力してください")
      end
      it "finish_time-start_time<work_timeの場合は無効" do
        timecard = FactoryBot.build(:time_card, work_time: 60*120)
        timecard.valid?
        expect(timecard.errors[:base]).to include("勤務時間の内訳が異常です")
      end
    end

    context "その他の異常" do
      it "finish_time-start_time < work_time+breaktimeの場合は無効" do
        timecard = FactoryBot.build(:time_card, work_time: 60*60, break_time: 60*60)
        timecard.valid?
        expect(timecard.errors[:base]).to include("勤務時間の内訳が異常です")
      end
    end
  end
end
