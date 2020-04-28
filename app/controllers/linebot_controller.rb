class LinebotController < ApplicationController
  require 'line/bot'
  protect_from_forgery :except => [:callback]


  def callback
    body = request.body.read
    #リクエストがlineからのものかを確認する
    check_from_line(body)
    #Lineでuserから送られてきた内容のみをeventsとしてパース
    events = client.parse_events_from(body)
    #userがlineで送ってきたイベントタイプに応じて処理を割り振る
    binding.pry
    events.each { |event|

      #メッセージ送信者のLINEidを＠user_idとして定義
      user_id(event)

      case event

      #メッセージイベントだった場合
      when Line::Bot::Event::Message
        #メッセージのタイプに応じて処理を割り振る
        case event.type
        #テキストメッセージの場合
        when Line::Bot::Event::MessageType::Text
          # LINEから送られてきたメッセージが「アンケート」と一致するかチェック
          if event.message['text'].eql?('アンケート')
            #lineの送信者にレスポンスにメッセージを返す。
            # private内のtemplateメソッドを呼び出します。
            client.reply_message(event['replyToken'], template)
          end
        end
      
      #友達追加の場合
      when Line::Bot::Event::Follow
        binding.pry
        #lineのuser_idに対応するユーザーがDBに存在するか判断
        #DBにline_idが存在しなかった場合ユーザー登録させる
        user = User.find_by(line_id: @user_id)
        user.nil? client.reply_message(event['replyToken'], create_user_message)
      #友達ブロックされた場合
      when Line::Bot::Event::Unfollow
        binding.pry

      #既存のグループにアプリが招待された場合
      when Line::Bot::Event::Join

      #参加していたグループから削除された又は退出した場合
      when Line::Bot::Event::Leave

      #すでに参加しているグループにメンバーが追加された場合
      when Line::Bot::Event::MemberJoined

      #参加しているグループからメンバーが退出又は削除された場合
      when Line::Bot::Event::MemberLeft

      end
    }
    head :ok
  end

  private
#各メソッド------------------------------------------------------------------------------------------------
  
  #リクエスト元かlineかどうかを確認する
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

  #メッセージ送信者のlineのuser_idを@user_idとして取得する
  def user_id(event)
    @user_id = event['source']['userId']
  end


#応答メッセージの内容---------------------------------------------------------------------------------------------------

  def template
    {
      "type": "template",
      "altText": "this is a confirm template",
      "template": {
          "type": "confirm",
          "text": "今日のもくもく会は楽しいですか？",
          "actions": [
              {
                "type": "message",
                # Botから送られてきたメッセージに表示される文字列です。
                "label": "楽しい",
                # ボタンを押した時にBotに送られる文字列です。
                "text": "楽しい"
              },
              {
                "type": "message",
                "label": "楽しくない",
                "text": "楽しくない"
              }
          ]
      }
    }
  end

  def create_user_message
    {
      "type": "template",
      "altText": "this is a create_user_message",
      "template": {
          "type": "confirm",
          "text": "今日のもくもく会は楽しいですか？",
          "actions": [
              {
                "type": "message",
                # Botから送られてきたメッセージに表示される文字列です。
                "label": "楽しい",
                # ボタンを押した時にBotに送られる文字列です。
                "text": "楽しい"
              },
              {
                "type": "message",
                "label": "楽しくない",
                "text": "楽しくない"
              }
          ]
      }
    }
  end


end