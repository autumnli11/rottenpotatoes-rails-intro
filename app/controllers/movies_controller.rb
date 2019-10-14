class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.get_all_ratings

    
    # if params.key?(:ratings)
    #   @checked_ratings = params.keys()
    # elsif session[:ratings]
    #   @checked_ratings = session.keys()
    # else
    #   @checked_ratings = @all_ratings
    # end

    #@movie = Movie.with_ratings(@all_ratings)

    if params[:sort_by] == "title"
      @movies = @movies.order(:title)
      @title_header = 'hilite'
    elsif params[:sort_by] == "release_date"
      @movies = @movies.order(:release_date)
      @release_header ='hilite'    
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
