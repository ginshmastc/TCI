class AddEmailAddressToMovieReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :movie_reviews, :email_address, :string
  end
end
