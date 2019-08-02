require 'test_helper'

class MovieFlowTest < ActionDispatch::IntegrationTest
  include SiteHelper
  test "open home" do
    get '/home/index'
	assert_response :success
  end

  test "open details and add movie" do
    get '/movie/details', params: {page: "details", tmdb_id:"299534", title:"Avengers: Endgame", date:"2019-04-24", isMovie: true, genres:"12,878,28"}
	mov = Movie.find_by(tmdb_movie_id: 299534)
	assert_equal("Avengers: Endgame", mov.title)
	assert_equal("Adventure, Science Fiction, Action", listMovGenres(mov.id))
	
	get '/movie/details', params: {page: "details", tmdb_id:"466282", title:"To All the Boys I've Loved Before", date:"2018-08-16", isMovie: true, genres:"35,10749"}
	mov = Movie.find_by(tmdb_movie_id: 466282)
	assert_equal("To All the Boys I've Loved Before", mov.title)
	assert_equal("Comedy, Romance", listMovGenres(mov.id))
	
	get '/movie/details', params: {page: "details", tmdb_id:"346364", title:"It", date:"2017-09-06", isMovie: true, genres:"27,53"}
	mov = Movie.find_by(tmdb_movie_id: 346364)
	assert_equal("It", mov.title)
	assert_equal("Horror, Thriller", listMovGenres(mov.id))
  end
  
  test "open review and add movie" do
    get '/movie_review/review', params: {page: "details", tmdb_id:"299537", title:"Captain Marvel", date:"2019-03-06", isMovie: true, genres:"12,878,28"}
	mov = Movie.find_by(tmdb_movie_id: 299537)
	assert_equal("Captain Marvel", mov.title)
	assert_equal("Adventure, Science Fiction, Action", listMovGenres(mov.id))
	
	get '/movie_review/review', params: {page: "details", tmdb_id:"465003", title:"The Red Sea Diving Resort", date:"2019-07-31", isMovie: true, genres:"28,18,36,53"}
	mov = Movie.find_by(tmdb_movie_id: 465003)
	assert_equal("The Red Sea Diving Resort", mov.title)
	assert_equal("Action, Drama, History, Thriller", listMovGenres(mov.id))
	
	get '/movie_review/review', params: {page: "details", tmdb_id:"459992", title:"Long Shot", date:"2019-05-02", isMovie: true, genres:"35,10749"}
	mov = Movie.find_by(tmdb_movie_id: 459992)
	assert_equal("Long Shot", mov.title)
	assert_equal("Comedy, Romance", listMovGenres(mov.id))
	
	
  end
  
  test "open review and add review" do
  
    get '/movie_review/review', params: {page: "details", tmdb_id:"299537", title:"Captain Marvel", date:"2019-03-06", isMovie: true, genres:"12,878,28"}
	get '/movie_review/review', params: {page: "details", tmdb_id:"465003", title:"The Red Sea Diving Resort", date:"2019-07-31", isMovie: true, genres:"28,18,36,53"}
	get '/movie_review/review', params: {page: "details", tmdb_id:"459992", title:"Long Shot", date:"2019-05-02", isMovie: true, genres:"35,10749"}
  
    #invalid email addresses
    post '/movie_review/create', params: {tmdb_id:"299537", email:"thereviewer", stars:"4", comment: "Captain Marvel was good!"}
	assert_response :redirect
	
	post '/movie_review/create', params: {tmdb_id:"299537", email:"@reviews", stars:"4", comment: "Captain Marvel was good!"}
	assert_response :redirect
	
	post '/movie_review/create', params: {tmdb_id:"299537", email:"thereviewer@reviews.", stars:"4", comment: "Captain Marvel was good!"}
	assert_response :redirect
	
	#valid review
	post '/movie_review/create', params: {tmdb_id:"299537", email:"thereviewer@reviews.com", stars:"4", comment: "Captain Marvel was good!"}
	mov = Movie.find_by(tmdb_movie_id: 299537)
	rev = MovieReview.find_by(movie_id: mov.id)
	assert_equal("thereviewer@reviews.com", rev.email_address)
	assert_equal(4, rev.stars)
	
	#valid email for localhost domain
	post '/movie_review/create', params: {tmdb_id:"465003", email:"thereviewer@reviews", stars:"2", comment: ""}
	mov = Movie.find_by(tmdb_movie_id: 465003)
	rev = MovieReview.find_by(movie_id: mov.id)
	assert_equal("thereviewer@reviews", rev.email_address)
	assert_equal(2, rev.stars)
	
	post '/movie_review/create', params: {tmdb_id:"459992", email:"thereviewer@reviews.com", stars:"5", comment: "Amazing!"}
	mov = Movie.find_by(tmdb_movie_id: 459992)
	rev = MovieReview.find_by(movie_id: mov.id)
	assert_equal("thereviewer@reviews.com", rev.email_address)
	assert_equal(5, rev.stars)
	assert_equal("Amazing!", rev.comment)
  end
  
  test "create and average reviews" do
    get '/movie_review/review', params: {page: "details", tmdb_id:"299537", title:"Captain Marvel", date:"2019-03-06", isMovie: true, genres:"12,878,28"}
	mov = Movie.find_by(tmdb_movie_id: 299537)
	
	post '/movie_review/create', params: {tmdb_id:"299537", email:"thereviewer@reviews.com", stars:"1", comment: "Captain Marvel was good!"}

	assert_equal(1, avgMovRating(mov.id))
	
	post '/movie_review/create', params: {tmdb_id:"299537", email:"thereviewer@reviews.com", stars:"5", comment: "Captain Marvel was good!"}
		
	assert_equal(3, avgMovRating(mov.id))
	
	post '/movie_review/create', params: {tmdb_id:"299537", email:"thereviewer@reviews.com", stars:"3", comment: "Captain Marvel was good!"}

	assert_equal(3, avgMovRating(mov.id))
	
	post '/movie_review/create', params: {tmdb_id:"299537", email:"thereviewer@reviews.com", stars:"4", comment: "Captain Marvel was good!"}

	assert_equal(3.25, avgMovRating(mov.id))
	
	post '/movie_review/create', params: {tmdb_id:"299537", email:"thereviewer@reviews.com", stars:"2", comment: "Captain Marvel was good!"}

	assert_equal(3, avgMovRating(mov.id))
  end
end
