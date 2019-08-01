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
	
  end
  #post review (invalid email)
  #calc review avg
  #list movie page?
  
  
  test "open review and add movie" do
    post '/movie_review/create', params: {tmdb_id:"299537", email:"thereviewer@reviews.com", stars:"4", comment: "Captain Marvel was good!"}
	
	mov = Movie.find_by(tmdb_movie_id: 299537)
	rev = MovieReview.find_by(movie_id: mov.id)
	assert_equal("thereviewer@reviews.com", rev.email_address)
	assert_equal("4", rev.stars)
  end
end
