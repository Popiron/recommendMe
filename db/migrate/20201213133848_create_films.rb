class CreateFilms < ActiveRecord::Migration[6.0]
  def change
    create_table :films do |t|
      t.integer :film_id
      t.string :title
      t.string :release_date
      t.string :genres
      t.string :background_image
      t.string :rating
      t.string :poster
      t.string :description
      t.timestamps
    end
  end
end
