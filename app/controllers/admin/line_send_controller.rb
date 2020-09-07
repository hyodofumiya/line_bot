module Admin
  class LineSendController < Admin::ApplicationController
    respond_to :json, only: [:create]

    def index
      @users = User.all
    end

    def create
      resource_ids = params[:checked_line_send] #送信先の一覧が入っている
      resource_name = params[:resource_name] #送信されたページに対応するモデル名
      message = params[:line_message] #lineに送るメインメッセージ

      #リクエストの送信元ページによって条件分岐
      case resource_name
      when "time_card"
        time_cards = TimeCard.includes(:user).where(id: resource_ids).reject{|s| s.user.admin_user == true}
        time_cards.each do |time_card|
          send_line(time_card.user.line_id, message, "#{time_card.date}の勤怠にアクションがあります")
        end
      when "standby"
        standbies = Standby.includes(:user).where(id: resource_ids).reject{|s| s.user.admin_user == true}
        standbies.each do |standby|
          send_line(standby.user.line_id, message, "出勤情報にアクションがあります")
        end
      when "user"
        if send_all #一斉送信
          User.all.reject{|u| u.admin_user == true}.each do |user|
            send_line(user.line_id, message, "管理者からの連絡");
          end
        else #個別の送信先
          users = User.where(id: resource_ids).reject{|u| u.admin_user == true}
          users.each do |user|
            send_line(user.line_id, message, "管理者からアクションがあります")
          end
        end
      end
    end

    private

    #一斉送信がONか確認する
    #ONならtrue,OFFならfalse
    def send_all
      params[:all_user_line_send] == "true"
    end

  end
end
