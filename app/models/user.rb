class User < ApplicationRecord
  has_one :standby
  has_many :time_cards
  has_many :user_groups
  has_many :groups, through: :user_groups

  validates :employee_number, uniqueness: true
  validates :line_id, uniqueness: true

end
