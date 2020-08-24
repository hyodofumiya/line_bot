module Admin
  class StandbiesController < Admin::ApplicationController

    def create
      resource = resource_class.new(resource_params)
      if resource.save
        redirect_to(
          [namespace, resource],
          notice: translate_with_resource("create.success"),
        )
        send_line(User.find(params[:standby][:user_id]).line_id, "#{params[:line_message]}", "出勤情報にアクションがありました。")
      else
        resource[:break_sum] /= 60 if resource[:break_sum].present?
        render action: :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
        }
      end
    end

    def edit
      requested_resource[:break_sum] /= 60 if requested_resource[:break_sum].present?
      render locals: {
        page: Administrate::Page::Form.new(dashboard, requested_resource),
      }
    end

    def update
      binding.pry
      if requested_resource.update(resource_params)
        requested_resource[:break_sum] /= 60 if requested_resource[:break_sum].present?
        redirect_to(
          [namespace, requested_resource],
          notice: translate_with_resource("update.success")
        )
        send_line(User.find(params[:standby][:user_id]).line_id, "#{params[:line_messsage]}", "勤務状況にアクションがありました")
      else
        requested_resource[:break_sum] /= 60 if requested_resource[:break_sum].present?
        redirect_to(
          [namespace, requested_resource],
          notice: translate_with_resource("update.fails")
        )
      end
    end

    private

    def resource_params
      break_sum = params[:standby][:break_sum].present? ? params[:standby][:break_sum].to_i*60 : 0
      params.require(resource_class.model_name.param_key).permit(dashboard.permitted_attributes).merge!({"break_sum"=>break_sum})
    end

    def scoped_resource
      if @admin
        resource_class
      else
        super.where(user_id: current_user.id)
      end
    end
  end
end
