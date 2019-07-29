class Tv < ApplicationRecord
  has_many :tv_categorizations
  has_many :tv_reviews

  def self.genreval(id)
    return TvCategorization.find_by(tv_id: id).genre_id
  end
end
