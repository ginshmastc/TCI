class MovieCategorization < ApplicationRecord
  belongs_to :movies, optional: true
  belongs_to :genres, optional: true
  validates :movie_id, presence: true
  validates :genre_id, presence: true
end
