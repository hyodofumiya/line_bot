module Admin
  class StandbiesController < Admin::ApplicationController

    def create
      resource = resource_class.new(resource_params)
      if resource.save
        send_line(User.find(params[:standby][:user_id]).line_id, "#{params[:line_message]}", "出勤情報にアクションがありました。")
        redirect_to([namespace, resource], notice: translate_with_resource("create.success"))
      else
        resource[:break_sum] /= 60 if resource[:break_sum].present?
        render action: :new, locals: {page: Administrate::Page::Form.new(dashboard, resource)}
      end
    end

    def edit
      convert_break_sum_of_reqested_resource_to_min
      render locals: {page: Administrate::Page::Form.new(dashboard, requested_resource)}
    end

    def update
      if requested_resource.update(resource_params)
        convert_break_sum_of_reqested_resource_to_min
        redirect_to([namespace, requested_resource], notice: translate_with_resource("update.success"))
        send_line(User.find(params[:standby][:user_id]).line_id, "#{params[:line_messsage]}", "勤務状況にアクションがありました")
      else
        convert_break_sum_of_reqested_resource_to_min
        render :edit, locals: {page: Administrate::Page::Form.new(dashboard, requested_resource)}
      end
    end

    private

    #ストロングパラメータ
    def resource_params
      convert_break_sum_to_sec
      params.require(resource_class.model_name.param_key).permit(dashboard.permitted_attributes).merge!({"break_sum"=>@break_sum})
    end

    #break_sumの単位をminからsecに変換し、＠break_sumとして定義
    def convert_break_sum_to_sec
      @break_sum = params[:standby][:break_sum].present? ? params[:standby][:break_sum].to_i*60 : 0
    end

    #indexページの並び順を決めるカラムを定義
    def default_sorting_attribute
      :start
    end
    
    #indexページの並び順を定義
    def default_sorting_direction
      :desc
    end

    #requested_resourceのbreak_sumをsecからminに変換する
    def convert_break_sum_of_reqested_resource_to_min
      requested_resource[:break_sum] /= 60 if requested_resource[:break_sum].present?
    end
  end
end
