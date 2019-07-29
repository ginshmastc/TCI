class Movie < ApplicationRecord
  has_many :movie_categorizations
  has_many :movie_reviews
  
  def self.genreval(id)
    return MovieCategorization.find_by(movie_id: id).genre_id
  end
end
