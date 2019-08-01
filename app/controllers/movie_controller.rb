class MovieController < ApplicationController

  def details
    @movie = Movie.find_by(tmdb_movie_id: params[:tmdb_id])
    if !@movie
      @movie = Movie.new({tmdb_movie_id: params[:tmdb_id], title: URI::decode(params[:title]), release_date: params[:date]})
      @movie.save
	  addGenres(params[:genres].split(","), @movie.id)
    end
  end
  
  def addGenres(genrelist, id)
    puts "add genreid " + id
	genrelist.each do |g|
	  @genreid = Genre.find_by(tmdb_genre_id: g.to_i())
	  @mcat = MovieCategorization.new({movie_id: id, genre_id: @genreid.id})
	  @mcat.save
	  end
  end
  
  def list
    @sort = params[:sort]
	if @sort
	  puts @sort
	end
    @movies = Movie.all
	
	if @sort == "title"
	  @movies = @movies.sort_by do |m|
	    m.title
	  end
	end
	
	if @sort == "date"
	  @movies = @movies.sort_by do |m|
	    m.release_date
	  end
	end
	
	if @sort == "genre"
	  @movies = @movies.sort_by do |m|
	    Movie.genreval(m.id)
	  end
	end
  end
  
  def show
    @movie = Movie.find(params[:id])
  end
  
end
