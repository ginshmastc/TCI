class MovieCategorization < ApplicationRecord
  belongs_to :movies, optional: true
  belongs_to :genres, optional: true
end
