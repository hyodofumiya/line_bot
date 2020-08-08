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

  validates :employee_number, presence: true
  validates :employee_number, uniqueness: true, numericality: {only_integer: true}, length: {is: 5, message: "5ケタの半角数字で入力してください"}, if: Proc.new { |resource| resource.employee_number.present?}
  validates :family_name, presence: true
  validates :family_name, format: {with: /\A([ァ-ン]|ー)+\z/, message: "全角カタカナのみ使用できます"}, length: { in: 1..15, too_long: "最大%{count}文字です", too_short: "を入力してください" }, if: Proc.new{ |resource| resource.family_name.present?}
  validates :first_name, presence: true
  validates :first_name, format: {with: /\A([ァ-ン]|ー)+\z/, message: "全角カタカナのみ使用できます"}, length: { in: 1..15, too_long: "最大%{count}文字です", too_short: "を入力してください" }, if: Proc.new{ |resource| resource.first_name.present?}
  validates :line_id, uniqueness: true, presence: true
  validates :email, allow_blank: true, uniqueness: true, format: {with: /\A\S+@\S+\.\S+\z/, message: "フォーマットが間違っています"}
end
