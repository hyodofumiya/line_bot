class Group < ApplicationRecord

  has_many :user_groups
  has_many :users, through: :user_groups

  validates :line_id, uniqueness: true

  def self.add_new_group(group_line_id)
    #招待されたグループがDBに存在するかで条件分岐
    if Group.find_by(line_id: group_line_id).nil?
      response = Group.create(line_id: group_line_id)
      return response
    end
  end
end
