class TvReviews < ActiveRecord::Migration[5.2]
  def self.up
    drop_table :tv_reviews, if_exists: true
    create_table :tv_reviews do |t|
      t.integer :tv_id
	  t.string :email_address
      t.integer :stars
      t.string :comment
      
      t.timestamps
    end
  end
  def self.down
    drop_table :tv_reviews, if_exists: true
  end
end
