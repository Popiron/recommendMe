class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.integer :game_id
      t.string :title
      t.string :release_date
      t.string :genres
      t.string :rating
      t.string :background_image
      t.string :description
      t.timestamps
    end
  end
end
