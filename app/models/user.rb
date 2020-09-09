class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :omniauthable, omniauth_providers: %i[line]

  has_one :standby
  has_many :time_cards
  has_many :user_groups
  has_many :groups, through: :user_groups

  attr_accessor :on_work

  validates :employee_number, presence: true
  validates :employee_number, uniqueness: true, format: {with: /\A([1-9]\d{4})+\z/, message: "は5桁の半角数字で入力してください"}, if: Proc.new{|resource| resource.employee_number.present?}
  validates :family_name, presence: true
  validates :family_name, format: {with: /\A([ァ-ン]|ー)+\z/, message: "は全角カタカナのみ使用できます"}, length: { in: 1..15, too_long: "は最大%{count}文字です", too_short: "を入力してください" }, if: Proc.new{ |resource| resource.family_name.present?}
  validates :first_name, presence: true
  validates :first_name, format: {with: /\A([ァ-ン]|ー)+\z/, message: "は全角カタカナのみ使用できます"}, length: { in: 1..15, too_long: "は最大%{count}文字です", too_short: "を入力してください" }, if: Proc.new{ |resource| resource.first_name.present?}
  validates :line_id, uniqueness: true, presence: true
  validates :email, uniqueness: true, format: {with: /\A\S+@\S+\.\S+\z/, message: "フォーマットが間違っています"}, if: Proc.new{ |resource| resource.email.present? }


  def on_work
    self.standby.present?
  end

  #Lineアプリ軽油でUserを作成した時のメソッド。userの登録結果をstringで返す
  def self.create_user(form_data)
    new_user = User.new(family_name:form_data["family_name"], first_name:form_data["first_name"], employee_number:form_data["employee_number"], line_id: $line_id, admin_user:"false")
    if new_user.save
      "ユーザー登録が完了しました"
    else
      if User.find_by(employee_number: form_data["employee_number"]).present?
        "すでに社員番号が使われています"
      else
        "登録できませんでした"
      end
    end
  end
end
