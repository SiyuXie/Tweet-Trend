class CreateRetweets < ActiveRecord::Migration
  def change
    create_table :retweets do |t|
      # t.string :tweet_id
      # t.string :retweet_user_id
      t.references :tweet, index: true, foreign_key: true
      t.references :twitter_user, index: true, foreign_key: true      
      
      t.timestamps null: false
    end
  end
end
