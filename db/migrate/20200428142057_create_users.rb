class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null:false
      t.integer :employee_number, null:false
      t.text :line_id, null:false
      t.boolean :admin_user, default: false
      t.timestamps
    end
    add_index :users, [:employee_number, :line_id], unique: true
  end
end
