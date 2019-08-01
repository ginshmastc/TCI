class TvController < ApplicationController
  
  def details
    @tv = Tv.find_by(tmdb_tv_id: params[:tmdb_id])
    
    if !@tv
      @tv = Tv.new({tmdb_tv_id: params[:tmdb_id], title: URI::decode(params[:title]), release_date: params[:date]})
      @tv.save
	  addGenres(params[:genres].split(","))
    end
  end
  
  def addGenres(genrelist)
	genrelist.each do |g|
	  @genreid = Genre.find_by(tmdb_genre_id: g.to_i())
	  @mcat = TvCategorization.new({movie_id: @movie.id, genre_id: @genreid.id})
	  @mcat.save
	  end
  end
  
  def list
    @sort = params[:sort]
	if @sort
	  puts @sort
	end
    @tvs = Tv.all
	
	if @sort == "title"
	  @tvs = @tvs.sort_by do |m|
	    m.title
	  end
	end
	
	if @sort == "date"
	  @tv = @tvs.sort_by do |m|
	    m.air_date
	  end
	end
	
	if @sort == "genre"
	  @tvs = @tvs.sort_by do |m|
	    Tv.genreval(m.id)
	  end
	end
  end
  
  def show
    @tv = Tv.find(params[:id])
  end
  
end
