class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]

  has_one :standby
  has_many :time_cards
  has_many :user_groups
  has_many :groups, through: :user_groups

  validates :first_name, presence: true, format: {with: /\A([ァ-ン]|ー)+\z/, message: "全角カタカナのみ使用できます"}
  validates :family_name, presence: true, format: {with: /\A([ァ-ン]|ー)+\z/, message: "全角カタカナのみ使用できます"}
  validates :employee_number, uniqueness: true, presence: true, numericality: {greater_than_or_equal_to: 10000, less_than_or_equal_to: 99999, message: "5ケタで入力してください"}
  validates :line_id, uniqueness: true, presence: true
  validates :email, uniqueness: true, format: {with: /\A\S+@\S+\.\S+\z/, message: "フォーマットが間違っています"}

end
