class Genre < ActiveRecord::Migration[5.2]
  def self.up
    drop_table :genres, if_exists: true
    create_table :genres do |t|
      t.string :tmdb_genre_id
      t.string :name
      t.timestamps
    end
    
  end
  def self.down
    drop_table :genres, if_exists: true
  end
end
