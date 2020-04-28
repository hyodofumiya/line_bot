class User < ApplicationRecord
  validates :employee_number, uniqueness: true
  validates :line_id, uniqueness: true
end
