class CreateStandbies < ActiveRecord::Migration[5.2]
  def change
    create_table :standbies do |t|
      t.references :user, null:false, foreign_key: {on_delete: :cascade}
      t.date :date,  null:false
      t.timestamp :start, null:false
      t.timestamp :break_start
      t.timestamp :break_sum
      t.timestamp
    end
  end
end
