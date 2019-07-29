class AddEmailAddressToTvReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :tv_reviews, :email_address, :string
  end
end
