class Richmenu < ApplicationRecord
  require 'line/bot'

  def self.check_richmenu
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
      binding.pry
      client.link_user_rich_menu($user_line_id, current_answer_richmenu_id)
      binding.ppry
    end
  end

  private
  
  def client
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end
