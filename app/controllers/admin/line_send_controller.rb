module Admin
  class LineSendController < Admin::ApplicationController
    respond_to :json, only: [:create]

    def index
      @users = User.all
      
    end

    def create
      resource_ids = params[:checked_line_send]
      resource_name = params[:resource_name]
      message = params[:line_message]
      #リクエストがどのページから送信されたものか判断する
      case resource_name
      when "time_card"
        time_cards= TimeCard.includes(:user).where(id: resource_ids).reject{|s| s.user.admin_user == true}
        time_cards.each do |time_card|
          send_line(time_card.user.line_id, message, "勤怠簿にアクションがあります")
        end
      when "standby"
        standbies = Standby.includes(:user).where(id: resource_ids).reject{|s| s.user.admin_user == true}
        standbies.each do |standby|
          send_line(standby.user.line_id, message, "出勤情報にアクションがあります")
        end
      when "user"
        #一斉送信がONか確認する
        send_all = (params[:all_user_line_send] == "true")
        if send_all
          User.all.reject{|u| u.admin_user == true}.each do |user|
            send_line(user.line_id, message, "管理者からの連絡");
          end
        else
          if resource_ids.present?
            users = User.where(id: resource_ids).reject{|u| u.admin_user == true}
            users.each do |user|
              send_line(user.line_id, message, "管理者からアクションがあります")
            end
          end
        end
      end
    end

    private

    def send_line(user_line_id, main_message, title_message)
      line_send = params[:line_send]
      if line_send == "true"
        client.push_message(user_line_id, change_timecard_message(main_message, title_message))
      end
    end

    def change_timecard_message(main_message, title_message)
      {
        "type": "flex",
        "altText": "管理者がアクションしました",
        "contents":
        {
          "type": "bubble",
          "body": {
            "type": "box",
            "layout": "vertical",
            "contents": [
              {
                "type": "text",
                "text": title_message,
                "color": "#C1D21F",
                "wrap": true,
              },
              {
                "type": "text",
                "text": main_message,
                "margin": "lg",
                "wrap": true,
              }
            ]
          }
        }
      }
    end

    def client
      client ||= Line::Bot::Client.new { |config|
        config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = "S5fTELJVb90Nr4PW9YQcQettd2e7ox4eVHOKpdNXqOs8akh5BVjVLLzfr4EPFVaQsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJMgjxLBuMAE8fGgu32MdhFjH2jBhad/Ro7T4Y7e5Yx31AdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
      }
    end

  end
end
