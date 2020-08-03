module Admin
  class TimeCardsController < Admin::ApplicationController

    # Overwrite any of the RESTful controller actions to implement custom behavior
    # For example, you may want to send an email after a foo is updated.
    #
    # def update
    #   super
    #   send_foo_updated_email(requested_resource)
    # end

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
      work_time = (fixed_finish_time.to_time - fixed_start_time.to_time) - params[:time_card][:break_time].to_i*60
      binding.pry
      params.require(resource_class.model_name.param_key).
        permit(dashboard.permitted_attributes).merge!({"start_time"=>fixed_start_time, "finish_time"=>fixed_finish_time, "work_time"=> "#{work_time}", "break_time"=> fixed_break_time})
    end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information


  end
end
