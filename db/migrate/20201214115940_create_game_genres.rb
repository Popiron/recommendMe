class CreateGameGenres < ActiveRecord::Migration[6.0]
  def change
    create_table :game_genres do |t|
      t.integer :genre_id
      t.string :name

      t.timestamps
    end
  end
end
