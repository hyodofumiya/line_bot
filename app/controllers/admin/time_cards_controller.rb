module Admin
  class TimeCardsController < Admin::ApplicationController

    # Overwrite any of the RESTful controller actions to implement custom behavior
    # For example, you may want to send an email after a foo is updated.
    #
    # def update
    #   super
    #   send_foo_updated_email(requested_resource)
    # end

    def create
      resource = resource_class.new(resource_params)
      if resource.save
        redirect_to(
          [namespace, resource],
          notice: translate_with_resource("create.success"),
        )
        send_line(User.find(params[:time_card][:user_id]).line_id, "#{params[:line_message]}", "#{params[:time_card][:date]}の出勤簿にアクションがありました。")
      else
        resource[:break_time] /= 60
        render action: :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
        }
      end
    end

    def edit
      binding.pry
      requested_resource[:break_time] /= 60
      requested_resource[:start_time] = requested_resource[:start_time].strftime("%H:%M")
      requested_resource[:finish_time] = requested_resource[:finish_time].strftime("%H:%M")
      render locals: {
        page: Administrate::Page::Form.new(dashboard, requested_resource),
      }
    end

    def update
      if requested_resource.update(resource_params)
        requested_resource[:break_time] /= 60
        redirect_to(
          [namespace, requested_resource],
          notice: translate_with_resource("update.success"),
        )
        send_line(User.find(params[:time_card][:user_id]).line_id, "#{params[:line_messsage]}", "#{params[:time_card][:date]}の出勤簿にアクションがありました")
      else
        requested_resource[:break_time] /= 60
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, requested_resource),
        }
      end
    end



    # Override this method to specify custom lookup behavior.
    # This will be used to set the resource for the `show`, `edit`, and `update`
    # actions.
    #
    # def find_resource(param)
    #   Foo.find_by!(slug: param)
    # end

    # The result of this lookup will be available as `requested_resource`

    # Override this if you have certain roles that require a subset
    # this will be used to set the records shown on the `index` action.
    #
    # def scoped_resource
    #   if current_user.super_admin?
    #     resource_class
    #   else
    #     resource_class.with_less_stuff
    #   end
    # end

    # Override `resource_params` if you want to transform the submitted
    # data before it's persisted. For example, the following would turn all
    # empty values into nil values. It uses other APIs such as `resource_class`
    # and `dashboard`:
    #
    # def resource_params
    #   params.require(resource_class.model_name.param_key).
    #     permit(dashboard.permitted_attributes).
    #     transform_values { |value| value == "" ? nil : value }
    # end

    private

    def resource_params
      fixed_start_time = "#{params[:time_card][:date]} #{params[:time_card][:start_time]}"
      fixed_finish_time = "#{params[:time_card][:date]} #{params[:time_card][:finish_time]}"
      fixed_break_time = "#{params[:time_card][:break_time].to_i*60}"
      work_time = (fixed_finish_time.to_time - fixed_start_time.to_time) - params[:time_card][:break_time].to_i*60 if fixed_start_time.present? && fixed_finish_time.present? && fixed_break_time.present?
      params.require(resource_class.model_name.param_key).
        permit(dashboard.permitted_attributes).merge!({"start_time"=>fixed_start_time, "finish_time"=>fixed_finish_time, "work_time"=> "#{work_time}", "break_time"=> fixed_break_time})
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
        client.push_message(user_line_id, return_change_timecard_message(return_message, title_message))
      end
    end

    def return_change_timecard_message(return_message, title_message)
      binding.pry
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

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end