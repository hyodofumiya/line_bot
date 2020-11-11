
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
  end
end

def create_dammy_data
  date_10 = [1,2,5,6,7,8,9,12,13,14,15,16,19,20,21,22,23,26,27,28,29,30]
  date_11 =[2,3,4,5,6,9,10,11]
  date_10.each do |i|
    create_timecard_record(10, i)
  end
  date_11.each do |i|
    create_timecard_record(11, i)
  end
end

def create_timecard_record(month,day)
  date = "2020/#{month}/#{day}"
  date = date.to_date
  start_time = Time.new(date.year, date.month, date.day, 9, 0, 0)
  finish_time = Time.new(date.year, date.month, date.day, 17, 0, 0)
  break_time = 4800
  work_time = (finish_time - start_time - break_time).to_i
  timecard = TimeCard.new(user_id: 3, date: date, work_time: work_time, start_time: start_time, finish_time: finish_time, break_time: break_time)
  timecard.save
end

def create_admin_user
  User.create(employee_number: 99999, family_name: "カンリシャ", first_name: "タロウ", line_id: "000", email: "admin@sample.com", password: "adminuser", admin_user: true)
end

def create_sample_user
  User.create(employee_number: 11111, family_name: "サンプル", first_name: "ハナコ", line_id: "111", admin_user: false)
end

#create_admin_user
#create_sample_user
#create_richmenu_data
create_dammy_data
