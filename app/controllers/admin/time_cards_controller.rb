module Admin
  class TimeCardsController < Admin::ApplicationController
    def new
      resource = new_resource
      authorize_resource(resource)
      render locals: {
        page: Administrate::Page::Form.new(dashboard, resource),
      }
    end

    def create
      resource = resource_class.new(resource_params)
      if resource.save
        redirect_to(
          [namespace, resource],
          notice: translate_with_resource("create.success"),
        )
        send_line(User.find(params[:time_card][:user_id]).line_id, "#{params[:line_message]}", "#{params[:time_card][:date]}の出勤簿にアクションがありました。")
      else
        resource[:break_time] /= 60 if resource[:break_time].present?
        render action: :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
        }
      end
    end

    def edit
      requested_resource[:break_time] /= 60 if requested_resource[:break_time].present?
      requested_resource[:start_time] = requested_resource[:start_time].strftime("%H:%M") if requested_resource[:start_time].present?
      requested_resource[:finish_time] = requested_resource[:finish_time].strftime("%H:%M") if requested_resource[:finish_time].present?
      render locals: {page: Administrate::Page::Form.new(dashboard, requested_resource)}
    end

    def update
      if requested_resource.update(resource_params)
        requested_resource[:break_time] /= 60 if requested_resource[:break_time].present?
        send_line(User.find(params[:time_card][:user_id]).line_id, "#{params[:line_messsage]}", "#{params[:time_card][:date]}の出勤簿にアクションがありました")
        redirect_to([namespace, requested_resource], notice: translate_with_resource("update.success"))
      else
        requested_resource[:break_time] /= 60 if requested_resource[:break_time].present?
        render :edit, locals: {page: Administrate::Page::Form.new(dashboard, requested_resource)}
      end
    end

    private
    #ストロングパラメータ
    def resource_params
      fix_resource_params
      params.require(resource_class.model_name.param_key).
        permit(dashboard.permitted_attributes).merge!({"start_time"=>fixed_start_time, "finish_time"=>fixed_finish_time, "work_time"=> "#{work_time}", "break_time"=> fixed_break_time})
    end

    #DBの型に対応する型にresource情報を整形するメソッド。
    def fix_resource_params
      @fixed_start_time = "#{params[:time_card][:date]} #{params[:time_card][:start_time]}"
      @fixed_finish_time = "#{params[:time_card][:date]} #{params[:time_card][:finish_time]}"
      @fixed_break_time = params[:time_card][:break_time].present? ? params[:time_card][:break_time].to_i*60 : 0 
      @work_time = fixed_start_time.present? && fixed_finish_time.present? ? ((fixed_finish_time.to_time - fixed_start_time.to_time) - fixed_break_time).to_i : 0
    end

    #勤怠履歴のindexページのレコードの並び順を反映させるカラムを定義
    def default_sorting_attribute
      :date
    end
    
    #勤怠履歴のindexページのレコードの並び順を定義
    def default_sorting_direction
      :desc
    end

  end
end
