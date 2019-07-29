class GenreController < ApplicationController
  def list
    @genres = Genre.all
  end
  
  def show
    @genre = Genre.find(params[:id])
  end
end
