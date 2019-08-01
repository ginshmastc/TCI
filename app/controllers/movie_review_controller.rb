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
    @sort = params[:sort]
    @movie_reviews = MovieReview.all
	@tv_reviews = TvReview.all
	
	if @sort == "title"
	  @movie_reviews = @movie_reviews.sort_by do |m|
	    Movie.find(m.movie_id)[:title]
	  end
	  @tv_reviews = @tv_reviews.sort_by do |m|
	    Tv.find(m.tv_id)[:title]
	  end
	end
	
	if @sort == "date"
	  @movie_reviews = @movie_reviews.sort_by do |m|
	    m.created_at
	  end
	  @tv_reviews = @tv_reviews.sort_by do |m|
	    m.created_at
	  end
	end
	
	if @sort == "genre"
	  @movie_reviews = @movie_reviews.sort_by do |m|
	    Movie.genreval(Movie.find(m.movie_id)[:id])
	  end
	  @tv_reviews = @tv_reviews.sort_by do |m|
	    Tv.genreval(Tv.find(m.tv_id)[:id])
	  end
	end
	
  end
  
  def show
    @movie_review = MovieReview.find(params[:id])
  end
  
end
