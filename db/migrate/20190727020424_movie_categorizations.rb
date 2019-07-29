class MovieCategorizations < ActiveRecord::Migration[5.2]
  def self.up
    drop_table :movie_categorizations, if_exists: true
    create_table :movie_categorizations do |t|
      t.integer :movie_id
      t.integer :genre_id
      
      t.timestamps
    end
  end
  def self.down
    drop_table :movie_categorizations, if_exists: true
  end
end
