class CreateTimeCards < ActiveRecord::Migration[5.2]
  def change
    create_table :time_cards do |t|
      t.references :user, null:false
      t.date :date, null:false
      t.integer :work_time, null:false
      t.timestamp :start_time, null:false
      t.timestamp :finish_time, null:false
      t.integer :break_time
      t.timestamps
    end
  end
end
