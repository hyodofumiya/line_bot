class Richmenu < ApplicationRecord
  require 'line/bot'

  def self.client
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }  
  end

  def self.get_user_richmenu_id
    Richmenu.client
    response_user_richmenu_id = JSON.parse(client.get_user_rich_menu($user_line_id).body)["richMenuId"]
    user_richmenu_obj = Richmenu.find_by(richmenu_id: response_user_richmenu_id)
    user_richmenu_id = user_richmenu_obj.id
    return user_richmenu_id
  end

  def self.check_and_change_richmenu
    #状態に応じた最適なリッチメニュー
    standby = Standby.find_by(user_id: $user.id)
    if standby.nil?
      current_answer_richmenu_id = 1
    elsif standby.break_start.nil?
      current_answer_richmenu_id = 2
    else
      current_answer_richmenu_id = 3
    end
    
    if $user_richmenu_id != current_answer_richmenu_id
      richmenu_id = Richmenu.find(current_answer_richmenu_id).richmenu_id
      Richmenu.client
      res = client.link_user_rich_menu($user_line_id, richmenu_id)
    end
  end
  
  private

end
