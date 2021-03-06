class CreateStandbies < ActiveRecord::Migration[5.2]
  def change
    create_table :standbies do |t|
      t.references :user, null:false, foreign_key: {on_delete: :cascade}
      t.date :date,  null:false
      t.timestamp :start, null:false
      t.timestamp :break_start
      t.integer :break_sum, null:false, default: 0 #休憩時間の合計をsecondで保存
      t.timestamp
    end
  end
end
