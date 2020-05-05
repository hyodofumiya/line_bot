class Richmenu
  def self.start
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
                "data": [{name: "start_work"}, {date: DateTime.now}].to_json
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
      }
    response = client.create_rich_menu(rich_menu)
    binding.pry
    p response
  end

  def self.show
    client = Line::Bot::Client.new{ |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
    response = client.get_rich_menus
    body = JSON.parse(response.body)
    binding.pry
  end

  def self.image_uproad

    client = Line::Bot::Client.new{ |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
    file = File.open('public/startwork.jpg')
    binding.pry
    response = client.create_rich_menu_image('richmenu-4357e5ee1155e1a187c752f69b27ecb1', file)
    body = JSON.parse(response.body)
    binding.pry
  end

  def self.set_default
    client = Line::Bot::Client.new{ |config|
      config.channel_secret = "d8b577ffcb6bb3447f437c2a6285b27f" #ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = "uRbTi0SYK1jKGmffyjvmzZdj+H/xVnfZ5Skey+ToaSkJKGGV+bZl8FA8/ENhdkKUsxNqXNZFEhu22kk9/nTI7PrttXwfaQ0PdiXY15W8mJN4ZbLJNrRSVqjUPWXfuPZY/o87s47+pga1RubZabBZgwdB04t89/1O/w1cDnyilFU="#ENV["LINE_CHANNEL_TOKEN"]
    }
    client.set_default_rich_menu('richmenu-4357e5ee1155e1a187c752f69b27ecb1')
    binding.pry
  end
end



while true
  puts '選択してください'
  puts '[0]リッチメニュー一覧を取得'
  puts '[1]リッチメニューの画像をアップロードする'
  puts '[2]リッチメニューを登録する'
  puts '[2]終了する'
  input = gets.to_i

  if input == 0
    p Richmenu.show
  elsif input == 1
    p Richmenu.image_uproad
  elsif input ==2
    p Richmenu.set_default
  elsif input == 3
    exit# アプリケーションを終了させなさい
  else
    puts '無効な値です'
  end
end