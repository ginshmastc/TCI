class MovieReviews < ActiveRecord::Migration[5.2]
  def self.up
    drop_table :movie_reviews, if_exists: true
    create_table :movie_reviews do |t|
      t.integer :movie_id
	  t.string :email_address
      t.integer :stars
      t.string :comment
      
      t.timestamps
    end
  end
  def self.down
    drop_table :movie_reviews, if_exists: true
  end
end
