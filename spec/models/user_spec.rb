require 'rails_helper'

RSpec.describe User, type: :model do
  describe '正常に登録できること' do
    it "family_name, first_name, employee_number, line_idがある場合有効" do
      user = FactoryBot.create(:user)
      expect(user).to be_valid
    end
  end

  describe 'エラーが生じること' do
    context "family_nameが異常" do
      it "存在しない場合無効" do
        user = FactoryBot.build(:user, family_name: nil)
        user.valid?
        expect(user.errors[:family_name]).to include("を入力してください")
      end
      it "15文字以上の場合無効" do
        user = FactoryBot.build(:user, family_name: "アイウエオカキクケコサシスセソタ")
        user.valid?
        expect(user.errors[:family_name]).to include("は最大15文字です")
      end
      it "半角英字が含まれている場合無効" do
        user = FactoryBot.build(:user, family_name: "セイa")
        user.valid?
        expect(user.errors[:family_name]).to include("は全角カタカナのみ使用できます")
      end
      it "半角数字が含まれている場合無効" do
        user = FactoryBot.build(:user, family_name: "セイ1")
        user.valid?
        expect(user.errors[:family_name]).to include("は全角カタカナのみ使用できます")
      end
      it "半角カナが含まれている場合無効" do
        user = FactoryBot.build(:user, family_name: "ｾｲ")
        user.valid?
        expect(user.errors[:family_name]).to include("は全角カタカナのみ使用できます")
      end
      it "全角英字が含まれている場合無効" do
        user = FactoryBot.build(:user, family_name: "セイａ")
        user.valid?
        expect(user.errors[:family_name]).to include("は全角カタカナのみ使用できます")
      end
      it "全角数字が含まれている場合無効" do
        user = FactoryBot.build(:user, family_name: "セイ１")
        user.valid?
        expect(user.errors[:family_name]).to include("は全角カタカナのみ使用できます")
      end
      it "漢字が含まれている場合無効" do
        user = FactoryBot.build(:user, family_name: "セイ漢字")
        user.valid?
        expect(user.errors[:family_name]).to include("は全角カタカナのみ使用できます")
      end
      it "全角平仮名が含まれている場合無効" do
        user = FactoryBot.build(:user, family_name: "せい")
        user.valid?
        expect(user.errors[:family_name]).to include("は全角カタカナのみ使用できます")
      end
      it "全角スペースが含まれている場合無効" do
        user = FactoryBot.build(:user, family_name: "セイ　")
        user.valid?
        expect(user.errors[:family_name]).to include("は全角カタカナのみ使用できます")
      end
      it "半角スペースが含まれている場合無効" do
        user = FactoryBot.build(:user, family_name: "セイ ")
        user.valid?
        expect(user.errors[:family_name]).to include("は全角カタカナのみ使用できます")
      end
    end

    context "family_nameが異常" do
      it "存在しない場合無効" do
        user = FactoryBot.build(:user, first_name: nil)
        user.valid?
        expect(user.errors[:first_name]).to include("を入力してください")
      end
      it "15文字以上の場合無効" do
        user = FactoryBot.build(:user, first_name: "アイウエオカキクケコサシスセソタ")
        user.valid?
        expect(user.errors[:first_name]).to include("は最大15文字です")
      end
      it "半角英字が含まれている場合無効" do
        user = FactoryBot.build(:user, first_name: "メイa")
        user.valid?
        expect(user.errors[:first_name]).to include("は全角カタカナのみ使用できます")
      end
      it "半角数字が含まれている場合無効" do
        user = FactoryBot.build(:user, first_name: "メイ1")
        user.valid?
        expect(user.errors[:first_name]).to include("は全角カタカナのみ使用できます")
      end
      it "半角カナが含まれている場合無効" do
        user = FactoryBot.build(:user, first_name: "ｾｲ")
        user.valid?
        expect(user.errors[:first_name]).to include("は全角カタカナのみ使用できます")
      end
      it "全角英字が含まれている場合無効" do
        user = FactoryBot.build(:user, first_name: "メイａ")
        user.valid?
        expect(user.errors[:first_name]).to include("は全角カタカナのみ使用できます")
      end
      it "全角数字が含まれている場合無効" do
        user = FactoryBot.build(:user, first_name: "メイ１")
        user.valid?
        expect(user.errors[:first_name]).to include("は全角カタカナのみ使用できます")
      end
      it "漢字が含まれている場合無効" do
        user = FactoryBot.build(:user, first_name: "メイ漢字")
        user.valid?
        expect(user.errors[:first_name]).to include("は全角カタカナのみ使用できます")
      end
      it "全角平仮名が含まれている場合無効" do
        user = FactoryBot.build(:user, first_name: "せい")
        user.valid?
        expect(user.errors[:first_name]).to include("は全角カタカナのみ使用できます")
      end
      it "全角スペースが含まれている場合無効" do
        user = FactoryBot.build(:user, first_name: "メイ　")
        user.valid?
        expect(user.errors[:first_name]).to include("は全角カタカナのみ使用できます")
      end
      it "半角スペースが含まれている場合無効" do
        user = FactoryBot.build(:user, first_name: "メイ ")
        user.valid?
        expect(user.errors[:first_name]).to include("は全角カタカナのみ使用できます")
      end
    end

    context "employee_numberが異常" do
      it "存在しない場合無効" do
        user = FactoryBot.build(:user, employee_number: nil)
        user.valid?
        expect(user.errors[:employee_number]).to include("を入力してください")
      end
      it "既にDBに存在する場合無効" do
        user1 = FactoryBot.create(:user, employee_number: "11111", line_id: "sample")
        user2 = FactoryBot.build(:user, employee_number: "11111")
        user2.valid?
        expect(user2.errors[:employee_number]).to include("はすでに存在します")
      end
      it "5桁未満の場合無効" do
        user = FactoryBot.build(:user, employee_number: "1111")
        user.valid?
        expect(user.errors[:employee_number]).to include("は5桁の半角数字で入力してください")
      end
      it "6桁以上の場合無効" do
        user = FactoryBot.build(:user, employee_number: "123456")
        user.valid?
        expect(user.errors[:employee_number]).to include("は5桁の半角数字で入力してください")
      end
      it "小数点が存在する場合無効" do
        user = FactoryBot.build(:user, employee_number: 11.1)
        user.valid?
        expect(user.errors[:employee_number]).to include("は5桁の半角数字で入力してください")
      end
      it "全角数字の場合無効" do
        user = FactoryBot.build(:user, employee_number: "１１１１１")
        user.valid?
        expect(user.errors[:employee_number]).to include("は5桁の半角数字で入力してください")
      end
      it "記号が含まれている場合無効" do
        user = FactoryBot.build(:user, employee_number: "1111@")
        user.valid?
        expect(user.errors[:employee_number]).to include("は5桁の半角数字で入力してください")
      end
      it "平仮名が含まれている場合無効" do
        user = FactoryBot.build(:user, employee_number: "1111あ")
        user.valid?
        expect(user.errors[:employee_number]).to include("は5桁の半角数字で入力してください")
      end
      it "半角カタカナが含まれている場合無効" do
        user = FactoryBot.build(:user, employee_number: "1111ｱ")
        user.valid?
        expect(user.errors[:employee_number]).to include("は5桁の半角数字で入力してください")
      end
      it "全角カタカナが含まれている場合無効" do
        user = FactoryBot.build(:user, employee_number: "1111ア")
        user.valid?
        expect(user.errors[:employee_number]).to include("は5桁の半角数字で入力してください")
      end
      it "半角英字が含まれる場合無効" do
        user = FactoryBot.build(:user, employee_number: "1111a")
        user.valid?
        expect(user.errors[:employee_number]).to include("は5桁の半角数字で入力してください")
      end
      it "全角英字が含まれる場合無効" do
        user = FactoryBot.build(:user, employee_number: "1111ｑ")
        user.valid?
        expect(user.errors[:employee_number]).to include("は5桁の半角数字で入力してください")
      end
    end
    
    context "line_idが異常" do
      it "存在しない場合無効" do
        user = FactoryBot.build(:user, line_id: nil)
        user.valid?
        expect(user.errors[:line_id]).to include("を入力してください")
      end
      it "重複する場合無効" do
        user1 = FactoryBot.create(:user, line_id: "test")
        user2 = FactoryBot.build(:user, line_id: "test")
        user2.valid?
        expect(user2.errors[:line_id]).to include("はすでに存在します")
      end
    end

    context "emailが異常" do
      it "重複する場合無効" do
        user1 = FactoryBot.create(:user, email: "test@test.com")
        user2 = FactoryBot.build(:user, email: "test@test.com")
        user2.valid?
        expect(user2.errors[:email]).to include("はすでに存在します")
      end
      it "@が含まれない場合無効" do
        user = FactoryBot.build(:user, email: "test")
        user.valid?
        expect(user.errors[:email]).to include("フォーマットが間違っています")
      end
      it "ドメインがない場合無効" do
        user = FactoryBot.build(:user, email:"test@test")
        user.valid?
        expect(user.errors[:email]).to include("フォーマットが間違っています")
      end
    end
  end
end
