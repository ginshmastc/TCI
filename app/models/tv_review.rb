class TvReview < ApplicationRecord
  belongs_to :tv
  validates :tv_id, presence: true
  validates :stars, presence: true
end
