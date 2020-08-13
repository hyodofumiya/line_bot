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
      when (@path.is "admin/time_cards")
        @line_default_message = "管理者が出勤簿を変更しました。"
      when (@path.is "admin/standby")
        @line_default_message = "管理者が勤怠を変更しました。"
      when (@path.is "admin/user")
        @line_default_message = "管理者が社員情報を変更しました。"
      end
    end

    def user_category
      @admin = current_user.admin_user?
    end

    def valid_action?(name, resource = resource_class)
      if @admin
        true
      else
        valid_array = [["standbies", "index"], ["standbies", "create"], ["standbies", "new"], ["standbies", "edit"], ["standbies", "show"], ["standbies", "update"], ["standbies", "destroy"], ["time_cards", "index"], ["time_cards", "create"], ["time_cards", "new"], ["time_cards", "edit"], ["time_cards", "show"], ["time_cards", "update"], ["time_cards", "destroy"]]
        !!valid_array.detect do |controller, action|
          controller == resource.to_s.underscore.pluralize && action == name.to_s
        end
      end
    end
  end
end