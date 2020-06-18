
def create_richmenu_data
    richmenus = [
    [1,"出勤用", "richmenu-4357e5ee1155e1a187c752f69b27ecb1", "状態：退勤中"],
    [2,"休憩開始", "richmenu-c483410ed627718cbda57d6ce91ac7f1", "状態:勤務中"],
    [3,"休憩終了", "richmenu-83275022a313bfdfaa7fb7ed1d2d834f", "状態：休憩中"],
    [4,"その他", "richmenu-d882125ecd5761d36fc8102049c0fb04", "状態：その他"]
  ]

  richmenus.each do |richmenu|
    req = Richmenu.new(id: richmenu[0], name: richmenu[1], richmenu_id: richmenu[2], explanation: richmenu[3], created_at: Time.now, updated_at: Time.now)
    res = req.save
    p req
    p res
  end
end

def create_dammy_data
  for num in 2..18 do
    date = "2020/04/#{num}"
    date = date.to_date
    start_time = Time.new(date.year, date.month, date.day, 2, 1, 0)
    finish_time = Time.new(date.year, date.month, date.day, num+1, 2+num, 0)
    break_time = 1800
    work_time = finish_time - start_time - break_time
    new = TimeCard.new(user_id: 1, date: date, work_time: work_time, start_time: start_time, finish_time: finish_time, break_time: break_time)
    new.save
  end
end

create_richmenu_data