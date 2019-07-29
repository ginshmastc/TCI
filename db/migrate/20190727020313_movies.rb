class Movies < ActiveRecord::Migration[5.2]
  def self.up
    drop_table :movies, if_exists: true
    create_table :movies do |t|
      t.string :tmdb_movie_id
      t.string :title
      t.date :release_date
      
      t.timestamps
    end
  end
  def self.down
    drop_table :movies, if_exists: true
  end
end
