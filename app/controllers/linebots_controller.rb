class LinebotsController < ApplicationController
  require 'line/bot'
  require 'time'
  protect_from_forgery :except => [:callback]
  before_action :check_from_line

  def callback
    callback_body = request.body.read
    #check_from_line(callback_body) #リクエストがlineからのものかを確認する
    events = client.parse_events_from(callback_body)#Lineから送られてきた内容をeventsとしてパース
    events.each { |event|
      @event = event
      check_line_sender #メッセージ送信元を@senderに、そのlineIdを$line_idに定義する
      $timestamp = Time.at(event["timestamp"]/1000)#リクエストの送信日時を定義。timestampのarea_codeを消すため下３桁を消している
      case @sender
      when "user"
        get_user_info #DBから該当するユーザーを取得
        get_richmenu_id #リッチメニューIDを取得
        #ユーザー登録の有無で条件分岐
        if $user.present?
          case event
            when Line::Bot::Event::Message #メッセージイベントだった場合
              #何もしない

            when Line::Bot::Event::Follow #友達追加の場合
              #何もしない
            
            when Line::Bot::Event::Unfollow #友達ブロックされた場合
              #何もしない
      
            when Line::Bot::Event::Postback #ポストバックだった場合
              @postback_data = JSON.parse(@event["postback"]["data"]) #postbackリクエストのdataプロパティを＠post_dataとして定義
              case @postback_data[0]["name"] #dataプロパティからフォーム元を判断し、条件分け
              when "timecard_index" #勤怠簿一覧を表示ボタンを押した時
                selected_timecards_messages = TimeCard.index_selected_date
                return_message = selected_timecards_messages
  
              when "timecard_show" #日付を指定した勤怠簿表示ボタンを押した時
                selected_date = event["postback"]["params"]["date"]
                selected_timecard = TimeCard.show_selected_date(selected_date)
                return_message = set_text_message(selected_timecard)

              when "search_member" #報連相ボタンを押した時
                return_message = "この機能は未実装です"

              when "back" #戻るボタンを押した時
                Richmenu.check_and_change_richmenu
              
              when "start_work" #勤務開始ボタンを押した時
                create_standby_record = Standby.add_new_record
                return_message = set_text_message(create_standby_record)
                Richmenu.check_and_change_richmenu

              when "start_break" #休憩開始ボタンを押した時
                update_standby_record = Standby.add_startbreak_to_record
                return_message = set_text_message(update_standby_record)
                Richmenu.check_and_change_richmenu

              when "finish_break" #休憩終了ボタンを押した時
                update_standby_record = Standby.add_breaksum_to_record
                return_message = set_text_message(update_standby_record)
                Richmenu.check_and_change_richmenu

              when "finish_work" #退勤ボタンを押した時
                finish_standby = Standby.finish_work_flow
                return_message = set_text_message(finish_standby)
                Richmenu.check_and_change_richmenu

              when "others"
                client.link_user_rich_menu($line_id, Richmenu.find(4).richmenu_id) #その他のリッチメニューを表示させる
              else
                return_message = "エラーが発生しました"
              end
            else
              return_message = "エラーが発生しました"
            end
            response = reply_message(return_message) if return_message.present? #必要に応じてメッセージをレスポンスする
        else
          handle_no_user
        end
      when "group"
        return_message = "このグループはアプリでサポートされていません"
        response = reply_message(return_message) #メッセージをレスポンスする
      when "room"
        return_message = "このトークルームはアプリでサポートされていません"
        response = reply_message(return_message) #メッセージをレスポンスする
      end
    }
    head :ok
  end

  private
#各メソッド------------------------------------------------------------------------------------------------
  
  #リクエスト元がlineかどうかを確認するメソッド
  #リクエスト元がlineでない場合はステータスコード400、エラーを返す
  def check_from_line
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      response_bad_request
    end
  end

  #リクエストの送信元を判断するメソッド
  #@senderに送信元, $line_idに送信元のlineIdを定義する
  def check_line_sender
    page_source = @event['source']
    case 
    when page_source["userId"].present?
      @sender = "user"
      $line_id = @event['source']['userId']
    when page_source["groupId"].present?
      @sender = "group"
      $line_id = @event['source']['groupId']
    when page_source["roomId"].present?
      @sender = "room"
      $line_id = @event['source']['roomId']
    end
  end

  #userをdbから取得するメソッド
  def get_user_info
    $user = User.find_by(line_id: $line_id)
  end

  #userのリッチメニューidを取得するメソッド
  def get_richmenu_id
    $user_richmenu_id = Richmenu.get_user_richmenu_id if $user.present?
  end

  #ユーザー登録前のuserからのリクエストを処理するメソッド
  def handle_no_user
    if @event["type"] == "postback"
      postback_data = JSON.parse(@event["postback"]["data"])
      case postback_data[0]["name"]
      when "user_form"
        create_user
      when "fix_user_form"
        reply_message(create_user_message)
      else
        reply_message([set_text_message("ユーザー登録をしてください") ,create_user_message])
      end
    else
      reply_message([set_text_message("ユーザー登録をしてください") ,create_user_message])
    end
    Richmenu.reset_richmenu_id
  end

  #ユーザー登録メソッド
  def create_user
    new_user = User.create_user(@postback_data[1])
    case new_user
    when "登録が完了しました"
      reply_message(set_text_message(new_user))
    when "すでに社員番号が使われています" or "登録できませんでした"
      reply_message([set_text_message(new_user), create_user_message])
    end
  end

  def reply_message(message)
    client.reply_message(@event['replyToken'], message)
  end

#応答メッセージの内容---------------------------------------------------------------------------------------------------
  #ユーザー登録確認メッセージ
  def create_user_message
    {
      "type": "template",
      "altText": "this is a buttons template",
      "template": {
        "type": "buttons",
        "actions": [
          {
            "type": "uri",
            "label": "はい",
            "uri": "line://app/1654154094-L2PYjd9P"
          },
          {
            "type": "message",
            "label": "いいえ",
            "text": "いいえ"
          }
        ],
        "title": "ユーザー登録",
        "text": "ユーザー登録を行いますか？"
      }
    }
  end

  #lineに送信する形式にテキストを加工するメソッド
  def set_text_message(message)
    {type: "text",
    text: message}
  end

end