require 'rails_helper'

RSpec.describe TimeCard, type: :model do
  describe '正常に登録できること' do
    it "family_name, first_name, employee_number, line_idがある場合有効である" do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end
  end

  describe 'エラーが生じること' do
    context "family_nameが異常" do
      it "family_nameが存在しない場合無効" do
        user = FactoryBot.build(:user, family_name: nil)
      end
      it "family_nameに半角英字が含まれている場合無効" do
        user = FactoryBot.build(:user, family_name: "セイa")
      end
      it "family_nameに半角数字が含まれている場合無効" do
        user = FactoryBot.build(:user, family_name: "セイ1")
      end
      it "family_nameに半角カナが含まれている場合無効" do
        user = FactoryBot.build(:user, family_name: "ｾｲ")
      end
      it "family_nameに全角英字が含まれている場合無効" do
        user = FactoryBot.build(:user, family_name: "セイａ")
      end
      it "family_nameに全角数字が含まれている場合無効" do
        user = FactoryBot.build(:user, family_name: "セイ１")
      end
      it "family_nameに漢字が含まれている場合無効" do
        user = FactoryBot.build(:user, family_name: "セイ漢字")
      end
      it "family_nameに全角平仮名が含まれている場合無効" do
        user = FactoryBot.build(:user, family_name: "せい")
      end
    end
    
    context "first_nameが異常" do
      it "first_nameが存在しない場合無効"
      it "first_nameに半角英字が含まれている場合無効"
      it "first_nameに半角数字が含まれている場合無効"
      it "first_nameに半角カナが含まれている場合無効"
      it "first_nameに全角英字が含まれている場合無効"
      it "first_nameに全角数字が含まれている場合無効"
      it "first_nameに漢字が含まれている場合無効"
      it "first_nameに全角平仮名が含まれている場合無効"
    end

    context "employeeが異常" do
    end
    
    context "line_idが異常" do
    end 
  end
end
