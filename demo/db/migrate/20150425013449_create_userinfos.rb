class CreateUserinfos < ActiveRecord::Migration
  def change
    create_table :userinfos do |t|
      t.string :user_name
      t.string :country
      t.string :city
      t.integer :age

      t.timestamps null: false
    end
  end
end
