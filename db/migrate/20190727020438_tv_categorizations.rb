class TvCategorizations < ActiveRecord::Migration[5.2]
  def self.up
    drop_table :tv_categorizations, if_exists: true
    create_table :tv_categorizations do |t|
      t.integer :tv_id
      t.integer :genre_id
      
      t.timestamps
    end
  end
  def self.down
    drop_table :tv_categorizations, if_exists: true
  end
end
