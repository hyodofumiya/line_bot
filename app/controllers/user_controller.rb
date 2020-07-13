class UserController < ApplicationController
  require 'line/bot'
  require 'net/https'
  require 'uri'
  require 'json'

  def new
  end

  def create
  end

  def user_check_bot
    user_id_token = params[:user_token]
    #LINEのIDトークンをLINEに送信し、LINEのIDを取得する
    @user_id = get_user_id_from_token(user_id_token)
    #ユーザーに入力内容の確認メッセージを送信する
    return_check_message()
  end

  private
  
  #userIDのトークンからuserIDを取得する関数
  def get_user_id_from_token(user_id_token)
    uri = URI.parse('https://api.line.me/oauth2/v2.1/verify')
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.path)

    req.set_form_data({"id_token":user_id_token, "client_id":"1654154094"})
    res = http.request(req)
    
    result = ActiveSupport::JSON.decode(res.body)
    user_id = result["sub"]
    
    return user_id
  end

  def return_check_message()
    form_data = [{name: "user_form"},{'family_name': params[:family_name], 'first_name': params[:first_name], 'employee_number': params[:employee_number]}]
    message = {
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
              "type": "separator",
              "margin": "none"
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
              "margin": "sm",
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
                  "text": params[:family_name],
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
                  "text": params[:first_name],
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
              "text": params[:employee_number]
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
                "type": "postback",
                "label": "はい",
                "displayText": "送信しました",
                "data": form_data.to_json
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
                "type": "postback",
                "label": "いいえ",
                "displayText": "いいえ",
                "data": [{name: "fix_user_form"}].to_json
              },
              "style": "secondary"
            }
          ]
        }
      }
    }
    response = client.push_message(@user_id, message)
  end

  #メッセージの送信元lineのアカウントを@clientとして定義する。
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "S5fTELJVb90Nr4PW9YQcQettd2e7ox4eVHOKpdNXqOs8akh5BVjVLLzfr4EPFVaQsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJMgjxLBuMAE8fGgu32MdhFjH2jBhad/Ro7T4Y7e5Yx31AdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end

