class Genre < ApplicationRecord
  has_many :movie_categorizations
  has_many :tv_categorizations
end
