module Admin
  class UsersController < Admin::ApplicationController
    before_action :admin_user

    def index
      if @admin
        super
      else
        redirect_back(fallback_location: admin_root_path)
      end
    end

    def show
      render locals: {
        page: Administrate::Page::Show.new(dashboard, requested_resource),
      }
    end

    def create
      resource = resource_class.new(resource_params)
      if resource.save
        redirect_to(
          [namespace, resource],
          notice: translate_with_resource("create.success"),
        )
        send_line(params[:user][:line_id], "#{params[:line_message]}", "管理者が社員情報を登録しました")
      else 
        render action: :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
        }
      end
    end

    def update
      if requested_resource.update(resource_params)
        redirect_to(
          [namespace, requested_resource],
          notice: translate_with_resource("update.success"),
        )
        send_line(params[:user][:line_id], "#{params[:line_message]}", "社員情報にアクションがありました")
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, requested_resource),
        }
      end

    end

    private

    def resource_params
      params.require(resource_class.model_name.param_key).
        permit(dashboard.permitted_attributes).merge!({"email"=>"", "admin_user"=>false})
    end

    def requested_resource
      @requested_resource ||= find_resource(params[:id]).tap do |resource|
        authorize_resource(resource)
      end
    end

    #lineにプッシュメッセージを送信するメソッド
    #第一引数 送信先のline_id
    #第二引数 送信するメッセージ
    #第三引数 タイトルに表示するメッセージ　例：出勤簿にアクションが付きました
    def send_line(user_line_id, return_message, title_message)
      line_send = params[:line_send]
      if line_send == "true"
        client.push_message(user_line_id, change_user_message(return_message, title_message))
      end
    end

    def change_user_message(return_message, title_message)
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

    def admin_user
      redirect_back(fallback_location: admin_root_path) unless @admin
    end

    
  end
end
