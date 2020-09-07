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

    #ログイン中のユーザーが管理者権限を有しているか判断するメソッド。
    #@adminに管理者の場合はtrue,それ以外の場合はfalseが入る
    def user_category
      @admin = current_user.admin_user?
    end

    #lineメッセージの入力フィールドにデフォルトで表示するメッセージを,@line_default_messageとして返すメソッド。
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

    #ユーザーの権限に応じて指定されたページを表示して良いか判断するメソッド
    #許可する場合はtrue,ブロックする場合はfalseを返す。
    def valid_action?(name, resource = resource_class)
      set_valid_array
      !!@valid_array.detect do |controller, action|
        controller == resource.to_s.underscore.pluralize && action == name.to_s
      end
    end

    #ユーザーの権限に応じてアクセスできるページ一覧を@valid_arrayとして返すメソッド
    def set_valid_array
      if @admin
        @valid_array = [["users", "index"], ["users", "new"], ["users", "show"], ["users", "edit"], ["users", "create"], ["users", "update"], ["users", "destroy"], ["standbies", "index"], ["standbies", "create"], ["standbies", "new"], ["standbies", "edit"], ["standbies", "show"], ["standbies", "update"], ["standbies", "destroy"], ["time_cards", "index"], ["time_cards", "create"], ["time_cards", "new"], ["time_cards", "edit"], ["time_cards", "show"], ["time_cards", "update"], ["time_cards", "destroy"]]
      else
        @valid_array = [["standbies", "index"], ["standbies", "create"], ["standbies", "new"], ["standbies", "edit"], ["standbies", "show"], ["standbies", "update"], ["standbies", "destroy"], ["time_cards", "index"], ["time_cards", "create"], ["time_cards", "new"], ["time_cards", "edit"], ["time_cards", "show"], ["time_cards", "update"], ["time_cards", "destroy"]]
      end
    end

    #操作するユーザーの権限に応じてresourceの情報公開範囲をコントロールするメソッド
    def scoped_resource
      if @admin
        resource_class
      else
        super.where(user_id: current_user.id)
      end
    end

    #lineにプッシュメッセージを送信するメソッド
    #第一引数 送信先のline_id
    #第二引数 送信するメッセージ
    #第三引数 タイトルに表示するメッセージ。 例：出勤簿にアクションが付きました
    def send_line(user_line_id, return_message, title_message)
      line_send = params[:line_send]
      if line_send == "true"
        client.push_message(user_line_id, change_timecard_message(return_message, title_message))
      end
    end

    #lineに送信するメッセージを返す。引数にメッセージの内容とタイトルをとる。
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

    #公式アカウントから送信するためのクライアント情報を格納
    def client
      client ||= Line::Bot::Client.new { |config|
        config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = "S5fTELJVb90Nr4PW9YQcQettd2e7ox4eVHOKpdNXqOs8akh5BVjVLLzfr4EPFVaQsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJMgjxLBuMAE8fGgu32MdhFjH2jBhad/Ro7T4Y7e5Yx31AdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
      }
    end

    #administrateの各ページにアクセスするボタンを日本語化するメソッド
    def translate_with_resource(key)
      t(
        "administrate.controller.#{key}",
        resource: t("administrate.resource.#{resource_resolver.resource_title}"),
      )
    end

  end
end