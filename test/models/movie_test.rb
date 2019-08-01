require 'test_helper'
 
class MovieTest < ActiveSupport::TestCase

  test "add movies" do
    Movie.new({tmdb_movie_id: "41234", title: "Test Mov 1", release_date: "2019-11-28"}).save
	Movie.new({tmdb_movie_id: "13284", title: "Test Mov 2", release_date: "2019-01-01"}).save
	Movie.new({tmdb_movie_id: "63465", title: "Test Mov 3", release_date: "2019-02-14"}).save
	Movie.new({tmdb_movie_id: "65437", title: "Test Mov 4", release_date: "2018-09-02"}).save
	Movie.new({tmdb_movie_id: "56976", title: "Test Mov 5", release_date: "2019-02-23"}).save
	Movie.new({tmdb_movie_id: "82865", title: "Test Mov 6", release_date: "2019-11-11"}).save
	Movie.new({tmdb_movie_id: "63265", title: "Test Mov 7", release_date: "2019-05-27"}).save
	Movie.new({tmdb_movie_id: "65932", title: "Test Mov 8", release_date: "2019-07-04"}).save
	Movie.new({tmdb_movie_id: "65348", title: "Test Mov 9", release_date: "2017-07-09"}).save
	Movie.new({tmdb_movie_id: "59876", title: "Test Mov 10", release_date: "2019-12-25"}).save
	
	@list = Movie.all
    assert_equal(@list.length, 10)
	assert_equal(@list[6].title, "Test Mov 7")
	assert_equal(@list[3].tmdb_movie_id, "65437")
	assert_equal(@list[8].release_date, Date.parse("2017-07-09"))
	movie = Movie.new
	assert_not movie.save, "Saved without parameters"
  end

  test "list" do
    
  end
end