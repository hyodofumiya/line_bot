class UserGroup < ApplicationRecord

  belongs_to :user
  belongs_to :group

  def self.add_member_to_new_group(group_line_id, replyToken)
    group = Group.find_by(line_id: group_line_id)
    #グループメンバーのuserIDを取得する
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
    response = client.get_group_member_ids(group_line_id)
  end
end
