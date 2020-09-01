
def create_richmenu_data
    richmenus = [
    [1,"出勤用", "richmenu-4357e5ee1155e1a187c752f69b27ecb1", "状態：退勤中"],
    [2,"休憩開始", "richmenu-c483410ed627718cbda57d6ce91ac7f1", "状態:勤務中"],
    [3,"休憩終了", "richmenu-83275022a313bfdfaa7fb7ed1d2d834f", "状態：休憩中"],
    [4,"その他", "richmenu-8806ccd7c079a67b70bd2c16a36646a8", "状態：その他"]
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
    date = "2020/05/#{num}"
    date = date.to_date
    start_time = Time.new(date.year, date.month, date.day, num, num, 0)
    finish_time = Time.new(date.year, date.month, date.day, num+2, 2+num, 0)
    break_time = 1800
    work_time = (finish_time - start_time - break_time).to_i
    timecard = TimeCard.new(user_id: 2, date: date, work_time: work_time, start_time: start_time, finish_time: finish_time, break_time: break_time)
    timecard.save
    p date
    p start_time
    p break_time
    p work_time
    p timecard.errors
  end
end

def create_admin_user
  User.create( employee_number: 99999, family_name: "テスト", first_name: "テスト", line_id: "000", email: "sample@sample.com", password: "testtest", admin_user: true)
end

create_richmenu_data
create_admin_user