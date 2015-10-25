class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :place_id
      t.text :source
      t.references :tweet, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
