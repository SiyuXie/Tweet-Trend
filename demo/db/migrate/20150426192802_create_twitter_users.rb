class CreateTwitterUsers < ActiveRecord::Migration
  def change
    create_table :twitter_users do |t|
      t.string :user_id
      t.text :source
      t.references :tweet, index: true, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
