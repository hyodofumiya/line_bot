module Admin
  class LineSendController < Admin::ApplicationController
  
    def index
      @users = User.all
      binding.pry
    end

    def create
      binding.pry
    end

    def search
      @users = User.where(employee_numer: params[:employee_numer])
      respond_to do ||format|
        format.html
        format.json
      end
    end
  end
end
