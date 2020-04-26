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
    events.each { |event|
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

  #メッセージの送信者を@clientとして定義する。
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"] #"d8b577ffcb6bb3447f437c2a6285b27f"
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"] #"uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="
    }
  end


#---------------------------------------------------------------------------------------------------
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
end