class MovieReviewController < ApplicationController
   def review
    @movie = Movie.find_by(tmdb_movie_id: params[:tmdb_id])
    
    if !@movie
      @movie = Movie.new({tmdb_movie_id: params[:tmdb_id], title: URI::decode(params[:title]), release_date: params[:date]})
      @movie.save
	  @genrelist = params[:genres].split(",")
	  @genrelist.each do |g|
	    @genreid = Genre.find_by(tmdb_genre_id: g.to_i())
		@mcat = MovieCategorization.new({movie_id: @movie.id, genre_id: @genreid.id})
		@mcat.save
	  end
    end
    if @movie
      @reviews = MovieReview.where(:movie_id => @movie.id)
    end
  end

  def create
  
	@movie = Movie.find_by(tmdb_movie_id: params[:tmdb_id])
	@email_regex = Regexp.new(/^([^@\s]+)@((?:[-a-z0-9]+.)+[a-z]{2,})$/)
    if params["email"] == "" || !@email_regex.match(params["email"])
      redirect_to :action => 'review', :title => @movie[:title], :date => @movie[:release_date], :tmdb_id => @movie[:tmdb_movie_id], :isMovie => "yes",  :page => "review", :error => "email"
	  return
    end
    
    @movie_review = MovieReview.new({movie_id: @movie[:id], stars: params[:stars], comment: params[:comment], email_address: params[:email]})
	if @movie_review
      @movie_review.save
    end
    redirect_to :action => 'review', :title => @movie[:title], :date => @movie[:release_date], :tmdb_id => @movie[:tmdb_movie_id], :isMovie => "yes",  :page => "review"
  end
  
  def list
    @movie_reviews = MovieReview.all
  end
  
  def show
    @movie_review = MovieReview.find(params[:id])
  end
  
end
