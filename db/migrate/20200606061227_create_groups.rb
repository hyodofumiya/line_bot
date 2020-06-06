class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.text :line_id, null:false, unique: true
      t.timestamps
    end
  end
end
