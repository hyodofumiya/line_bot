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
      @user_admin = current_user.admin_user
    end
  end
    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
