class TvReviewController < ApplicationController
   def review
    @tv = Tv.find_by(tmdb_tv_id: params[:tmdb_id])
    
    if !@tv
      @tv = Tv.new({tmdb_tv_id: params[:tmdb_id], title: URI::decode(params[:title]), air_date: params[:date]})
      @tv.save
	  @genrelist = params[:genres].split(",")
	  @genrelist.each do |g|
	    @genreid = Genre.find_by(tmdb_genre_id: g.to_i())
		@mcat = TvCategorization.new({tv_id: @tv.id, genre_id: @genreid.id})
		@mcat.save
	  end
    end
    if @movie
      @reviews = TvReview.where(:tv_id => @tv.id)
    end
  end

  def create
  
	@tv = Tv.find_by(tmdb_tv_id: params[:tmdb_id])
	@email_regex = Regexp.new(/^([^@\s]+)@((?:[-a-z0-9]+.)+[a-z]{2,})$/)
    if params["email"] == "" || !@email_regex.match(params["email"])
      redirect_to :action => 'review', :title => @tv[:title], :date => @tv[:air_date], :tmdb_id => @tv[:tmdb_tv_id], :isMovie => "false",  :page => "review", :error => "email"
	  return
    end
    
    @tv_review = TvReview.new({tv_id: @tv[:id], stars: params[:stars], comment: params[:comment], email_address: params[:email]})
	if @tv_review
      @tv_review.save
    end
    redirect_to :action => 'review', :title => @tv[:title], :date => @tv[:air_date], :tmdb_id => @tv[:tmdb_tv_id], :isMovie => "false",  :page => "review"
  end
  
  def list
    @tv_reviews = TvReview.all
  end
  
  def show
    @tv_review = TvReview.find(params[:id])
  end
  
end
