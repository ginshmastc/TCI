class MovieReview < ApplicationRecord
  belongs_to :movie
  validates :movie_id, presence: true
  validates :stars, presence: true
end
