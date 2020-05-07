class CreateRichmenus < ActiveRecord::Migration[5.2]
  def change
    create_table :richmenus do |t|
      t.string :name , null:false
      t.text :richmenu_id, null:false
      t.string :explanation, null:false
      t.timestamps
    end
  end
end

#id:1 出勤用
#id:2 休憩開始・退勤用
#id:3 休憩終了・退勤用
