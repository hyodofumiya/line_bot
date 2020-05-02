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

      #メッセージ送信者のLINEidを＠user_idとして定義
      user_id(event)

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
            client.reply_message(event['replyToken'], template)
          #LINEからのテキストメッセージが「ユーザー登録フォームを送信しました」と一致した場合
          else event.message['text'].eql?('ユーザー登録フォームを送信しました')
            #client.reply_message(event['replyToken'], template)
          end
        end
      
      #友達追加の場合
      when Line::Bot::Event::Follow
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
      "type": "flex",
      "altText": "Flex Message",
      "contents": {
        "type": "bubble",
        "direction": "ltr",
        "header": {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "text",
              "text": "入力内容の確認",
              "margin": "none",
              "size": "xl",
              "align": "center",
              "weight": "bold",
              "color": "#767474"
            },
            {
              "type": "separator"
            }
          ]
        },
        "body": {
          "type": "box",
          "layout": "vertical",
          "flex": 0,
          "spacing": "none",
          "margin": "none",
          "contents": [
            {
              "type": "text",
              "text": "氏名",
              "size": "lg"
            },
            {
              "type": "box",
              "layout": "horizontal",
              "contents": [
                {
                  "type": "text",
                  "text": "姓:　",
                  "flex": 0,
                  "align": "start",
                  "weight": "regular",
                  "color": "#787878"
                },
                {
                  "type": "text",
                  "text": "テストせい",
                  "align": "start",
                  "weight": "regular",
                  "wrap": true
                }
              ]
            },
            {
              "type": "box",
              "layout": "horizontal",
              "contents": [
                {
                  "type": "text",
                  "text": "名:　",
                  "flex": 0,
                  "margin": "none",
                  "color": "#787878"
                },
                {
                  "type": "text",
                  "text": "テスト名",
                  "align": "start",
                  "wrap": true
                }
              ]
            },
            {
              "type": "text",
              "text": "社員番号",
              "margin": "md",
              "size": "lg"
            },
            {
              "type": "text",
              "text": "テスト番号"
            },
            {
              "type": "text",
              "text": "上記内容で登録しますか？",
              "margin": "xxl",
              "wrap": true
            }
          ]
        },
        "footer": {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "button",
              "action": {
                "type": "message",
                "label": "はい",
                "text": "はい"
              },
              "style": "primary"
            },
            {
              "type": "separator",
              "margin": "md",
              "color": "#FFFFFF"
            },
            {
              "type": "button",
              "action": {
                "type": "message",
                "label": "いいえ",
                "text": "いいえ"
              },
              "style": "secondary"
            }
          ]
        }
      }
    }
  end

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

  def message
    {"type": "text",
      "text": "test"}
  end

end