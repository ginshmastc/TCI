require 'test_helper'

class TvFlowTest < ActionDispatch::IntegrationTest
  include SiteHelper
  test "open home" do
    get '/home/index'
	assert_response :success
  end

  test "open details and add show" do
    get '/tv/details', params: {page: "details", tmdb_id:"1100", title:"How I Met Your Mother", date:"2005-09-19", isMovie: false, genres:"35"}
	tv = Tv.find_by(tmdb_tv_id: 1100)
	assert_equal("How I Met Your Mother", tv.title)
	assert_equal("Comedy", listTvGenres(tv.id))
	
	get '/tv/details', params: {page: "details", tmdb_id:"32726", title:"Bob's Burgers", date:"2011-01-09", isMovie: false, genres:"16,35"}
	tv = Tv.find_by(tmdb_tv_id: 32726)
	assert_equal("Bob's Burgers", tv.title)
	assert_equal("Animation, Comedy", listTvGenres(tv.id))
	
	get '/tv/details', params: {page: "details", tmdb_id:"48891", title:"Brooklyn Nine-Nine", date:"2013-09-17", isMovie: true, genres:"35,80"}
	tv = Tv.find_by(tmdb_tv_id: 48891)
	assert_equal("Brooklyn Nine-Nine", tv.title)
	assert_equal("Comedy, Crime", listTvGenres(tv.id))
  end
  
  test "open review and add show" do
    get '/tv_review/review', params: {page: "review", tmdb_id:"1100", title:"How I Met Your Mother", date:"2005-09-19", isMovie: false, genres:"35"}
	tv = Tv.find_by(tmdb_tv_id: 1100)
	assert_equal("How I Met Your Mother", tv.title)
	assert_equal("Comedy", listTvGenres(tv.id))
	
	get '/tv_review/review', params: {page: "review", tmdb_id:"32726", title:"Bob's Burgers", date:"2011-01-09", isMovie: false, genres:"16,35"}
	tv = Tv.find_by(tmdb_tv_id: 32726)
	assert_equal("Bob's Burgers", tv.title)
	assert_equal("Animation, Comedy", listTvGenres(tv.id))
	
	get '/tv_review/review', params: {page: "review", tmdb_id:"48891", title:"Brooklyn Nine-Nine", date:"2013-09-17", isMovie: true, genres:"35,80"}
	tv = Tv.find_by(tmdb_tv_id: 48891)
	assert_equal("Brooklyn Nine-Nine", tv.title)
	assert_equal("Comedy, Crime", listTvGenres(tv.id))
	
  end
  
  test "open review and add review" do
  
    get '/tv_review/review', params: {page: "review", tmdb_id:"1100", title:"How I Met Your Mother", date:"2005-09-19", isMovie: false, genres:"35"}
	get '/tv_review/review', params: {page: "review", tmdb_id:"32726", title:"Bob's Burgers", date:"2011-01-09", isMovie: false, genres:"16,35"}
	get '/tv_review/review', params: {page: "review", tmdb_id:"48891", title:"Brooklyn Nine-Nine", date:"2013-09-17", isMovie: true, genres:"35,80"}
	
    #invalid email addresses
    post '/tv_review/create', params: {tmdb_id:"1100", email:"thereviewer", stars:"4", comment: "How I Met Your Mother is so funny!"}
	assert_response :redirect
	
	post '/tv_review/create', params: {tmdb_id:"1100", email:"@reviews", stars:"4", comment: "How I Met Your Mother is so funny!"}
	assert_response :redirect
	
	post '/tv_review/create', params: {tmdb_id:"1100", email:"thereviewer@reviews.", stars:"4", comment: "How I Met Your Mother is so funny!"}
	assert_response :redirect
	
	#valid review
	post '/tv_review/create', params: {tmdb_id:"1100", email:"thereviewer@reviews.com", stars:"4", comment: "How I Met Your Mother is so funny!"}
	tv = Tv.find_by(tmdb_tv_id: 1100)
	rev = TvReview.find_by(tv_id: tv.id)
	assert_equal("thereviewer@reviews.com", rev.email_address)
	assert_equal(4, rev.stars)
	
	#valid email for localhost domain
	post '/tv_review/create', params: {tmdb_id:"32726", email:"thereviewer@reviews", stars:"5", comment: "Bob's Burgers is a great show for all ages"}
	tv = Tv.find_by(tmdb_tv_id: 32726)
	rev = TvReview.find_by(tv_id: tv.id)
	assert_equal("thereviewer@reviews", rev.email_address)
	assert_equal(5, rev.stars)
	
	post '/tv_review/create', params: {tmdb_id:"48891", email:"thereviewer@reviews.com", stars:"4", comment: "Amazing!"}
	tv = Tv.find_by(tmdb_tv_id: 48891)
	rev = TvReview.find_by(tv_id: tv.id)
	assert_equal("thereviewer@reviews.com", rev.email_address)
	assert_equal(4, rev.stars)
	assert_equal("Amazing!", rev.comment)
  end
  
  test "create and average reviews" do
    get '/tv_review/review', params: {page: "review", tmdb_id:"1100", title:"How I Met Your Mother", date:"2005-09-19", isMovie: false, genres:"35"}
	tv = Tv.find_by(tmdb_tv_id: 1100)
	
	post '/tv_review/create', params: {tmdb_id:"1100", email:"thereviewer@reviews.com", stars:"1", comment: "HIMYM is good!"}

	assert_equal(1, avgTvRating(tv.id))
	
	post '/tv_review/create', params: {tmdb_id:"1100", email:"thereviewer@reviews.com", stars:"5", comment: ""}
		
	assert_equal(3, avgTvRating(tv.id))
	
	post '/tv_review/create', params: {tmdb_id:"1100", email:"thereviewer@reviews.com", stars:"3", comment: ""}

	assert_equal(3, avgTvRating(tv.id))
	
	post '/tv_review/create', params: {tmdb_id:"1100", email:"thereviewer@reviews.com", stars:"4", comment: ""}

	assert_equal(3.25, avgTvRating(tv.id))
	
	post '/tv_review/create', params: {tmdb_id:"1100", email:"thereviewer@reviews.com", stars:"2", comment: ""}

	assert_equal(3, avgTvRating(tv.id))
  end
end
