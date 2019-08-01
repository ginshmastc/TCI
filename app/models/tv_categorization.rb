class TvCategorization < ApplicationRecord
  belongs_to :tvs, optional: true
  belongs_to :genres, optional: true
  validates :tv_id, presence: true
  validates :genre_id, presence: true
end
