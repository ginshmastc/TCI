class TvCategorization < ApplicationRecord
  belongs_to :tvs, optional: true
  belongs_to :genres, optional: true
end
