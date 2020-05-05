class RichmenuController < ApplicationController
  require 'line/bot'
  require 'date'
  require 'json'

  #勤務開始のリッチメニューを作成
  def start_work_menu
    client = Line::Bot::Client.new{ |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
    
    rich_menu = {
        "size": {
          "width": 1200,
          "height": 405
        },
        "selected": true,
        "name": "出勤用",
        "chatBarText": "退勤中(タップで表示)",
        "areas": [
          {
            "bounds": {
                "x": 60,
                "y": 20,
                "width": 340,
                "height": 362
            },
            "action": {
                "type": "postback",
                "label": "出勤",
                "data": [{name: "start_work"}, {date: DateTime.now}]
            }
          },
          {
            "bounds": {
                "x": 950,
                "y": 135,
                "width": 140,
                "height": 220
            },
            "action": {
                "type": "postback",
                "label": "others",
                "data": [{name: "others"}].to_json
            }
          }
        ]
      }.to_json
    response = client.create_rich_menu(rich_menu)
    binding.pry
    p response
  end

  def test
    client = Line::Bot::Client.new{ |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
    response = client.get_rich_menus
    binding.pry
  end
end

