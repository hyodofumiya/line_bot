class UserGroup < ApplicationRecord

  belongs_to :user
  belongs_to :group

  def self.add_member_to_new_group(group_line_id, replyToken)
    group = Group.find_by(line_id: group_line_id)
    #グループメンバーのuserIDを取得する
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.line_channel[:secret]
      Rails.application.credentials.line_channel[:token]
    }
    response = client.get_group_member_ids(group_line_id)
    #メンバーのlineIDの入った配列をmembers_line_idとして定義する
    members_line_id = response["memberIds"]
    #メンバーをグループに紐付けるための中間テーブルに保存
    members_line_id.each do |member_line_id|
      user = User.find_by(line_id: member_line_id)
      UserGroup.create(user: user.id, group: group.id) if user.present?
    end
  end
end
