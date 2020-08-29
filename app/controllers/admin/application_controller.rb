# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin, :request_path, :user_category, :set_default_line_message

    def authenticate_admin
      authenticate_user!
    end

    def request_path
      @path = controller_path + '#' + action_name
      def @path.is(*str)
        str.map{|s| self.include?(s)}.include?(true)
      end
    end

    def set_default_line_message
      case
      when (controller_path == "admin/time_cards" and action_name == ("new" or "edit"))
        @line_default_message = "管理者が出勤簿を変更しました。"
      when (controller_path == "admin/standbies" and action_name == ("new" or "edit"))
        @line_default_message = "管理者が勤怠を変更しました。"
      when (controller_path == "admin/users" and action_name == ("new" or "edit"))
        @line_default_message = "管理者が社員情報を変更しました。"
      when (controller_path == "admin/users" and action_name == ("index" or "show"))
        @line_default_message = "管理者から連絡があります。"
      when (controller_path == "admin/time_cards" and action_name == ("index" or "show"))
        @line_default_message = "管理者が出勤簿を確認しました。"
      when (controller_path == "admin/standbies" and action_name == ("index" or "show"))
        @line_default_message = "管理者が出勤情報を確認しました。"
      end
    end

    def user_category
      @admin = current_user.admin_user?
    end

    def valid_action?(name, resource = resource_class)
      if @admin
        valid_array = [["users", "index"], ["users", "new"], ["users", "show"], ["users", "edit"], ["users", "create"], ["users", "update"], ["users", "destroy"], ["standbies", "index"], ["standbies", "create"], ["standbies", "new"], ["standbies", "edit"], ["standbies", "show"], ["standbies", "update"], ["standbies", "destroy"], ["time_cards", "index"], ["time_cards", "create"], ["time_cards", "new"], ["time_cards", "edit"], ["time_cards", "show"], ["time_cards", "update"], ["time_cards", "destroy"]]
      else
        valid_array = [["standbies", "index"], ["standbies", "create"], ["standbies", "new"], ["standbies", "edit"], ["standbies", "show"], ["standbies", "update"], ["standbies", "destroy"], ["time_cards", "index"], ["time_cards", "create"], ["time_cards", "new"], ["time_cards", "edit"], ["time_cards", "show"], ["time_cards", "update"], ["time_cards", "destroy"]]
      end

      !!valid_array.detect do |controller, action|
        controller == resource.to_s.underscore.pluralize && action == name.to_s
      end
    end

    #lineにプッシュメッセージを送信するメソッド
    #第一引数 送信先のline_id
    #第二引数 送信するメッセージ
    #第三引数 タイトルに表示するメッセージ　例：出勤簿にアクションが付きました
    def send_line(user_line_id, return_message, title_message)
      line_send = params[:line_send]
      if line_send == "true"
        client.push_message(user_line_id, change_timecard_message(return_message, title_message))
      end
    end

    def change_timecard_message(return_message, title_message)
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
                "text": return_message,
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


    def translate_with_resource(key)
      t(
        "administrate.controller.#{key}",
        resource: t("administrate.resource.#{resource_resolver.resource_title}"),
      )
    end

  end
end