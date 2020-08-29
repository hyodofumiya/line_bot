require 'rails_helper'

RSpec.describe Standby, type: :model do
  describe "正常" do
    it "user_id, date, startが存在する時有効" do
      standby = FactoryBot.build(:standby, break_start: nil, break_sum: nil)
      expect(standby).to be_valid
    end
    it "user_id, date, start,break_startが存在する時有効" do
      standby = FactoryBot.build(:standby, break_sum: nil)
      expect(standby).to be_valid
    end
    it "user_id, date, start, break_start, break_sumが存在する時有効" do
      standby = FactoryBot.build(:standby)
      expect(standby).to be_valid
    end
  end

  describe "異常" do
    context "user_idが異常" do
      it "nilの場合無効" do 
        standby = FactoryBot.build(:standby, user_id: nil)
        standby.valid?
        expect(standby.errors[:user]).to include("を入力してください")
      end
      it "該当するuserが存在しない場合無効" do 
        standby = FactoryBot.build(:standby, user_id: "122")
        standby.valid?
        expect(standby.errors[:user]).to include("を入力してください")
      end
    end

    context "dateが異常" do
      it "nilの場合無効" do 
        standby = FactoryBot.build(:standby, date: nil)
        standby.valid?
        expect(standby.errors[:date]).to include("を入力してください")
      end

      it "当日以外は無効" do 
        standby = FactoryBot.build(:standby, date: Date.today-1)
        standby.valid?
        expect(standby.errors[:date]).to include("は今日を入力してください")
      end
    end
    context "startが異常" do
      it "nilの場合無効" do 
        standby = FactoryBot.build(:standby, start: nil)
        standby.valid?
        expect(standby.errors[:start]).to include("を入力してください")
      end
      it "日付が当日でない場合無効" do 
        standby = FactoryBot.build(:standby, start: DateTime.now.since(-1.day))
        standby.valid?
        expect(standby.errors[:start]).to include("は今日の時刻を入力してください")
      end
      it "datetime型以外は無効" do 
        standby = FactoryBot.build(:standby, start: "a")
        standby.valid?
        expect(standby.errors[:start]).to include("を入力してください")
      end
    end
    context "break_startが異常" do
      it "日付が当日でない場合無効" do 
        standby = FactoryBot.build(:standby, break_start: (DateTime.now-1).since(-30.minutes))
        standby.valid?
        expect(standby.errors[:break_start]).to include("は今日の時刻を入力してください")
      end
      it "datetime型でない場合無効" do 
        standby = FactoryBot.build(:standby, break_start: "a")
        expect(standby).to be_valid
      end
      it "start > break_startの場合無効" do 
        datetime = DateTime.now
        standby = FactoryBot.build(:standby, date: datetime.to_date, start: datetime, break_start: datetime.since(-1.hour) )
        standby.valid?
        expect(standby.errors[:break_start]).to include("を開始時刻より後にしてください")
      end
    end
    context "break_sumが異常" do
      context "整数でない場合無効" do
        it "自然数でない場合無効" do
          standby1 = FactoryBot.build(:standby, break_sum: 50.9)
          standby2 = FactoryBot.build(:standby, break_sum: -50)
          standby1.valid?
          standby2.valid?
          expect(standby1.errors[:break_sum]).to include("は整数で入力してください")
          expect(standby2.errors[:break_sum]).to include("は0以上の値にしてください")
        end
        it "半角英字の場合無効" do        
          standby = FactoryBot.build(:standby, break_sum: "a")
          standby.valid?
          expect(standby.errors[:break_sum]).to include("は数字で入力してください")
        end
        it "半角カタカナの場合無効" do
          standby = FactoryBot.build(:standby, break_sum: "ﾃｽﾄ")
          standby.valid?
          expect(standby.errors[:break_sum]).to include("は数字で入力してください")
        end
        it "全角カタカナの場合無効" do
          standby = FactoryBot.build(:standby, break_sum: "テスト")
          standby.valid?
          expect(standby.errors[:break_sum]).to include("は数字で入力してください")
        end
        it "平仮名の場合無効" do
          standby = FactoryBot.build(:standby, break_sum: "てすと")
          standby.valid?
          expect(standby.errors[:break_sum]).to include("は数字で入力してください")
        end
        it "全角英字の場合無効" do
          standby = FactoryBot.build(:standby, break_sum: "ａ")
          standby.valid?
          expect(standby.errors[:break_sum]).to include("は数字で入力してください")
        end
        it "記号の場合無効" do
          standby = FactoryBot.build(:standby, break_sum: "@")
          standby.valid?
          expect(standby.errors[:break_sum]).to include("は数字で入力してください")
        end
      end
      it "break_sum > now - startの場合無効" do
        standby = FactoryBot.build(:standby, date: Date.today, start: Time.now.since(-60.minutes), break_start: Time.now.since(-20.minutes) ,break_sum: 70*60)
        standby.valid?
        expect(standby.errors[:break_sum]).to include( "を勤務時間以内にしてください")
      end
    end

    context "その他の異常" do
      it "userのレコードが他に存在する場合は無効" do
        standby1 = FactoryBot.create(:standby)
        standby2 = FactoryBot.build(:standby, user_id: standby1.user_id)
        standby2.valid?
        expect(standby2.errors[:base]).to include("すでに別の出勤情報が登録されています")
      end
    end
  end
end
