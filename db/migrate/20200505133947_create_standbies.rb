class CreateStandbies < ActiveRecord::Migration[5.2]
  def change
    create_table :standbies do |t|
      t.references :user, null:false, foreign_key: {on_delete: :cascade}
      t.date :date,  null:false
      t.time :start, null:false
      t.time :break_start
      t.time :break_end
      t.time :break_sum
      t.timestamps
    end
  end
end
