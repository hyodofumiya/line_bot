class LinebotsController < ApplicationController
  require 'line/bot'
  protect_from_forgery :except => [:callback]


  #exitnclude Standby

  def callback
    $body = request.body.read
    #リクエストがlineからのものかを確認する
    check_from_line($body)
    #Lineでuserから送られてきた内容のみをeventsとしてパース
    events = client.parse_events_from($body)
    #userがlineで送ってきたイベントタイプに応じて処理を割り振る
    events.each { |event|
      #メッセージ送信者のLINEidを＠user_idとして定義
      user_id(event)
      @user = User.find_by(line_id: $user_id)
      case event
      #メッセージイベントだった場合
      when Line::Bot::Event::Message
        #メッセージのタイプに応じて処理を割り振る
        case event.type
        #テキストメッセージの場合
        when Line::Bot::Event::MessageType::Text
          # LINEから送られてきたメッセージが「アンケート」と一致した場合
          if event.message['text'].eql?('アンケート')
            #lineの送信者にレスポンスにメッセージを返す。
            # private内のtemplateメソッドを呼び出します。
            client.reply_message(event['replyToken'], message)
          #LINEからのテキストメッセージが「ユーザー登録フォームを送信しました」と一致した場合
          else event.message['text'].eql?('新規ユーザー登録')
            client.reply_message(event['replyToken'], create_user_message) if @user.nil?
          end
        end
      
      #友達追加の場合
      when Line::Bot::Event::Follow
        #lineのuser_idに対応するユーザーがDBに存在するか判断
        #DBにline_idが存在しなかった場合ユーザー登録させる
        client.reply_message(event['replyToken'], create_user_message) if @user.nil?
      #友達ブロックされた場合
      when Line::Bot::Event::Unfollow

      #既存のグループにアプリが招待された場合
      when Line::Bot::Event::Join

      #参加していたグループから削除された又は退出した場合
      when Line::Bot::Event::Leave

      #すでに参加しているグループにメンバーが追加された場合
      when Line::Bot::Event::MemberJoined

      #参加しているグループからメンバーが退出又は削除された場合
      when Line::Bot::Event::MemberLeft

      #ポストバックだった場合
      when Line::Bot::Event::Postback
        #postbackリクエストのdataプロパティを＠post_dataとして定義
        @postback_data = JSON.parse(event["postback"]["data"])
        #dataプロパティ配列の[0]["name"]に入っている内容でフォーム元を判断し、条件分け
        if @postback_data[0]["name"] == "user_form"
          create_user
        else
          #user登録してあるか確認
          binding.pry
          if check_user(event) == true
            case @postback_data[0]["name"]
            when "start_work"
              binding.pry
              create_standby_record = Standby.add_new_record(@postback_data[1]["date"])
              standby_return_message = Standby.return_message(create_standby_record)
              binding.pry
            when "start_break"
              binding.pry
              #standbyレコードを更新してもいいか確認
                #問題なければ更新
                #問題があればエラーメッセージを表示
                  #リッチメニューのidを取得し、条件に応じて切り替える
            when "finish_break"
              #standbyレコードを更新してもいいか確認
                #問題なければ更新
                #問題があれば
                  #問題の内容を返信
                  #リッチメニューの更新が必要か確認し、必要なら更新
              binding.pry

            when "finish_work"
            end
            client.reply_message(event['replyToken'], standby_return_message)
          else
          end
        end
      end
    }
    head :ok
  end

  private
#各メソッド------------------------------------------------------------------------------------------------
  
  #リクエスト元がlineかどうかを確認する
  def check_from_line(body)
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end
  end

  #メッセージの送信元lineのアカウントを@clientとして定義する。
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  #メッセージ送信者のlineのuser_idを$user_idとして取得する
  def user_id(event)
    $user_id = event['source']['userId']
  end

  def check_user(event)
    client.reply_message(event['replyToken'], [no_user_message ,create_user_message])
  end

  def create_user
    form_data = @postback_data[1]
    create_user = User.new(family_name:form_data["family_name"], first_name:form_data["first_name"], employee_number:form_data["employee_number"], line_id: $line_id, admin_user:"false")
      #if create_user.save
        #client.reply_message(event['replyToken'], success_create_user_message)
      #else
        #if User.find_by(employee_numer:@form_data["employee_number"]).present?
        #else
          #client.reply_message(event['replyToken'], fails_create_user_message)
          binding.pry
  end


#応答メッセージの内容---------------------------------------------------------------------------------------------------


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
        "text": "勤怠入力を行うためのユーザー登録を行いますか？"
      }
    }
  end

  def no_user_message
    {"type": "text",
      "text": "ユーザーが登録されていません"}
  end

  def message
    {"type": "text",
      "text": "test"}
  end

  def success_create_user_message
    {type:"text",
    text:"登録が完了しました"}
  end

  def fails_create_user_message
    {type:"text",
    text:"登録できませんでした。"}
  end

  def already_exist_user
    {type:"text",
      text:"すでに登録されています"}
  end

end