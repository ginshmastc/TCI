module SiteHelper

  def listMovGenres(id)
    @genrestr = ""
	@mo = Movie.find(id)
	MovieCategorization.where(movie_id: @mo.id).find_each do |g|
	  @gid = g.genre_id
	  @gdb = Genre.find(@gid)
	  @genrestr += @gdb.name + ", "
	end
	return @genrestr.delete_suffix(", ")
  end

  def listTvGenres(id)
    @genrestr = ""
	@med = Tv.find(id)
	TvCategorization.where(tv_id: id).find_each do |g|
	  @gid = g.genre_id
	  @gdb = Genre.find(@gid)
	  @genrestr += @gdb.name + ", "
	end
	return @genrestr.delete_suffix(", ")
  end
  
  def avgMovRating(id)
    @total = 0
	@amount = 0
	MovieReview.where(movie_id: id).find_each do |r|
	  @amount += 1
	  @total += r.stars
	end
	if @amount == 0
	  return 0
	end
	puts "total " + @total.to_s() + " amount " + @amount.to_s()
	return (@total.to_f() / @amount.to_f()).round(1)
  end
  
  def avgTvRating(id)
    @total = 0
	@amount = 0
	TvReview.where(tv_id: id).find_each do |r|
	  @amount += 1
	  @total += r.stars
	end
	if @amount == 0
	  return 0
	end
	return (@total.to_f() / @amount.to_f()).round(1)
  end
  
end
