class Group < ApplicationRecord

  has_many: user_groups
  has_many: users, thought: :user_groups

  validates :line_id, uniqueness: true

end
