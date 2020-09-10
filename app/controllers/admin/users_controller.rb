module Admin
  class UsersController < Admin::ApplicationController
    before_action :admin_user

    def index
      super
    end

    def show
      render locals: {
        page: Administrate::Page::Show.new(dashboard, requested_resource),
      }
    end

    def create
      resource = resource_class.new(resource_params)
      if resource.save
        send_line(params[:user][:line_id], "#{params[:line_message]}", "管理者が社員情報を登録しました")
        redirect_to([namespace, resource], notice: translate_with_resource("create.success"))
      else 
        render action: :new, locals: { page: Administrate::Page::Form.new(dashboard, resource)}
      end
    end

    def update
      if requested_resource.update(resource_params)
        send_line(params[:user][:line_id], "#{params[:line_message]}", "社員情報にアクションがありました")
        redirect_to([namespace, requested_resource], notice: translate_with_resource("update.success"))
      else
        render :edit, locals: { page: Administrate::Page::Form.new(dashboard, requested_resource)}
      end
    end

    private

    #ストロングパラメーター
    def resource_params
      if @admin
        params.require(resource_class.model_name.param_key).
          permit(dashboard.permitted_attributes)
      else
        params.require(resource_class.model_name.param_key).
        permit(dashboard.permitted_attributes).merge!({"email"=>"", "admin_user"=>false})
      end
    end

    #管理者以外が閲覧しようとした際に弾くメソッド
    def admin_user
      redirect_back(fallback_location: admin_root_path) unless @admin
    end

    #index画面の並び順を決めるカラムを定義
    def default_sorting_attribute
      :employee_number
    end
    
    #indexの並び順を定義
    def default_sorting_direction
      :desc
    end

  end
end
