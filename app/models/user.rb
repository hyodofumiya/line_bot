class User < ApplicationRecord
  has_one :standby
  has_many :time_cards
  has_many :user_groups
  has_many :groups, through: :user_groups

  validates :first_name, presence: true
  validates :family_name, presence: true
  validates :employee_number, uniqueness: true, presence: true, numericality: {greater_than_or_equal_to: 10000, less_than_or_equal_to: 99999}
  validates :line_id, uniqueness: true, presence: true

end
