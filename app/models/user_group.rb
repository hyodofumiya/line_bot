class UserGroup < ApplicationRecord

  belongs_to :user
  belongs_to :group

  def self.add_member_to_new_group(group_line_id, replyToken)
    group = Group.find_by(line_id: group_line_id)
    #グループメンバーのuserIDを取得する
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "S5fTELJVb90Nr4PW9YQcQettd2e7ox4eVHOKpdNXqOs8akh5BVjVLLzfr4EPFVaQsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJMgjxLBuMAE8fGgu32MdhFjH2jBhad/Ro7T4Y7e5Yx31AdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
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
