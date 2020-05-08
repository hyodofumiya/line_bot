class User < ApplicationRecord
  has_one :standby
  has_many :time_cards

  validates :employee_number, uniqueness: true
  validates :line_id, uniqueness: true

end
