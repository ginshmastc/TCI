class Tvs < ActiveRecord::Migration[5.2]
  def self.up
    drop_table :tvs, if_exists: true
    create_table :tvs do |t|
      t.string :tmdb_tv_id
      t.string :title
      t.date :air_date
      
      t.timestamps
    end
  end
  def self.down
    drop_table :tvs, if_exists: true
  end
end
