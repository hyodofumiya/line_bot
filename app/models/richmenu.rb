class Richmenu < ApplicationRecord
  require 'line/bot'


  #現在のユーザーのリッチメニューIDをLINEサーバーから取得するメソッド。返り値は対応するリッチメニューレコードのid
  def self.get_user_richmenu_id
    response_user_richmenu_id = JSON.parse(client.get_user_rich_menu($line_id).body)["richMenuId"]
    user_richmenu_obj = Richmenu.find_by(richmenu_id: response_user_richmenu_id)
    user_richmenu_id = user_richmenu_obj.id
    return user_richmenu_id
  end

  #現在のユーザーのリッチメニューを適切なものに切り替えるメソッド
  def self.check_and_change_richmenu
    #状態に応じた最適なリッチメニュー
    current_answer_richmenu_id = Richmenu.check_richmenu_id($user.id) if $user.present?
    Richmenu.change_richmenu($line_id, current_answer_richmenu_id) if $user_richmenu_id != current_answer_richmenu_id
  end

  #現在のユーザーに必要なRichmenuを判定するメソッド
  def self.check_richmenu_id(user_id)
    standby = Standby.find_by(user_id: user_id)
    if standby.nil?
      current_answer_richmenu_id = 1
    elsif standby.break_start.nil?
      current_answer_richmenu_id = 2
    else
      current_answer_richmenu_id = 3
    end
  end

  #ユーザーのリッチメニューを切り替えるメソッド。引数にユーザーのline_idと変更後のリッチメニューidを受け取る
  def self.change_richmenu(line_id, richmenu_id)
    richmenu_id_of_line = Richmenu.find(richmenu_id).richmenu_id
    client.link_user_rich_menu(line_id, richmenu_id_of_line)
  end


  #リッチメニューをデフォルトの状態に戻すメソッド
  def self.reset_richmenu_id
    client.link_user_rich_menu($line_id, Richmenu.find(1).richmenu_id) 
  end
  
  private

end
