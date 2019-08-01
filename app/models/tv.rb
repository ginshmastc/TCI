class Tv < ApplicationRecord
  has_many :tv_categorizations
  has_many :tv_reviews
  validates :title, presence: true
  validates :air_date, presence: true
  validates :tmdb_tv_id, presence: true

  def self.genreval(id)
    return TvCategorization.find_by(tv_id: id).genre_id
  end
end
