class Richmenu
  def self.start
    client = Line::Bot::Client.new{ |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
    
    rich_menu = {
        "size": {
          "width": 1200,
          "height": 810
        },
        "selected": true,
        "name": "その他",
        "chatBarText": "その他",
        "areas": [
          {
            "bounds": {
                "x": 45,
                "y": 15,
                "width": 313,
                "height": 373
            },
            "action": {
                "type": "postback",
                "label": "今月と前月分",
                "data": [{name: "timecard_index"}].to_json
            }
          },
          {
            "bounds": {
                "x": 444,
                "y": 15,
                "width": 313,
                "height": 373
            },
            "action": {
                "type": "datetimepicker",
                "mode": "date",
                "label": "日付を指定",
                "data": [{name: "timecard_show"}].to_json
            }
          },
          {
            "bounds": {
                "x": 842,
                "y": 15,
                "width": 313,
                "height": 373
            },
            "action": {
                "type": "uri",
                "label": "修正",
                "uri": "https://liff.line.me/1654154094-1nd8zDod",
                "data": [{name: "timecard-fix"}].to_json
            }
          },
          {
            "bounds": {
                "x": 45,
                "y": 424,
                "width": 313,
                "height": 373
            },
            "action": {
                "type": "postback",
                "label": "出勤中/作業中の人を探す",
                "data": [{name: "search_member"}].to_json
            }
          },
          {
            "bounds": {
                "x": 893,
                "y": 494,
                "width": 212,
                "height": 232
            },
            "action": {
                "type": "postback",
                "label": "戻る",
                "data": [{name: "back"}].to_json
            }
          }
        ]
      }
    response = client.create_rich_menu(rich_menu)
    p response
  end

  def self.show
    client = Line::Bot::Client.new{ |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
    response = client.get_rich_menus
    body = JSON.parse(response.body)
  end

  def self.image_uproad
    client = Line::Bot::Client.new{ |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
    file = File.open('public/others.jpg')
    response = client.create_rich_menu_image('richmenu-d882125ecd5761d36fc8102049c0fb04', file)
    body = JSON.parse(response.body)
    p body
  end

  def self.set_default
    client = Line::Bot::Client.new{ |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
    res = client.set_default_rich_menu('richmenu-4357e5ee1155e1a187c752f69b27ecb1')
    p res
  end

  def self.delete
    client = Line::Bot::Client.new{ |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
    response = client.delete_rich_menu("richmenu-07792a76bd76607a22553bbf2e052b30")
    p response
  end

  def self.check_image
    client = Line::Bot::Client.new{ |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
    response = client.get_rich_menu_image("richmenu-c483410ed627718cbda57d6ce91ac7f1")
    p response
  end
end



while true
  puts '選択してください'
  puts '[0]リッチメニュー一覧を取得'
  puts '[1]リッチメニューの画像をアップロードする'
  puts '[3]リッチメニューを登録する'
  puts '[4]終了する'
  puts '[5}削除する'
  input = gets.to_i

  if input == 0
    p Richmenu.show
  elsif input == 1
    p Richmenu.image_uproad
  elsif input ==2
    p Richmenu.set_default
  elsif input ==3
    p Richmenu.start
  elsif input == 4
    exit# アプリケーションを終了させなさい
  elsif input == 5
    p Richmenu.delete
  elsif input == 6
    p Richmenu.check_image
  else
    puts '無効な値です'
  end
end