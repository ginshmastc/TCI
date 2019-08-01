class Movie < ApplicationRecord
  has_many :movie_categorizations
  has_many :movie_reviews
  validates :title, presence: true
  validates :release_date, presence: true
  validates :tmdb_movie_id, presence: true
  
  def self.genreval(id)
    return MovieCategorization.find_by(movie_id: id).genre_id
  end
  
  def addGenres(genrelist, id)
    @movie = Movie.find(:id)
	genrelist.each do |g|
	  @genreid = Genre.find_by(tmdb_genre_id: g.to_i())
	  @mcat = MovieCategorization.new({movie_id: @movie.id, genre_id: @genreid.id})
	  @mcat.save
	end
  end
end
