class Tv < ApplicationRecord
  has_many :tv_categorizations
  has_many :tv_reviews
  validates :title, presence: true
  validates :air_date, presence: true
  validates :tmdb_tv_id, presence: true

  def genreval()
    return TvCategorization.find_by(tv_id: self.id).genre_id
  end
  
  def addGenres(genrelist)
	genrelist.each do |g|
	  @genreid = Genre.find_by(tmdb_genre_id: g.to_i())
	  @mcat = TvCategorization.new({tv_id: self.id, genre_id: @genreid.id})
	  @mcat.save
	end
  end
end
