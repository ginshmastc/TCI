class Genre < ApplicationRecord
  has_many :movie_categorizations
  has_many :tv_categorizations
  validates :tmdb_genre_id, presence: true
  validates :name, presence: true
end
