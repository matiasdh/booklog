class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email,    null: false
      t.string :username, null: false

      t.index :email,    unique: true
      t.index :username, unique: true


      t.timestamps
    end
  end
end
