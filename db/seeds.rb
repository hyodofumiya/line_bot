richmenus = [
  [1,"出勤用", "richmenu-4357e5ee1155e1a187c752f69b27ecb1", "状態：退勤中"],
  [2,"休憩開始", "richmenu-c483410ed627718cbda57d6ce91ac7f1", "状態:勤務中"],
  [3,"休憩終了", "richmenu-83275022a313bfdfaa7fb7ed1d2d834f", "状態：休憩中"],
  [4,"その他", "richmenu-07792a76bd76607a22553bbf2e052b30", "状態：その他"]
]

richmenus.each do |richmenu|
  req = Richmenu.new(id: richmenu[0], name: richmenu[1], richmenu_id: richmenu[2], explanation: richmenu[3], created_at: Time.now, updated_at: Time.now)
  res = req.save
  p req
  p res
end