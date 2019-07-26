Rails.application.routes.draw do
  root "home#index"
  get "movie/details"
  get "movie_reviews/reviews"
  
end
