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
    @checked_ratings = @all_ratings

    if params[:ratings]
      session[:ratings] = params[:ratings]
    end

    if params[:sort_by]
      session[:sort_by] = params[:sort_by] 
    end

    if params[:sort_by].nil? && session[:sort_by]
      @sorting = session[:sort_by]
      if params[:rating]
        @ratings = params[:ratings]
      else
        @ratings = session[:ratings]
      end
      flash.keep
      redirect_to movies_path(:sort_by => @sorting, :ratings => @ratings) and return
    elsif params[:ratings].nil? && session[:ratings]
      @ratings = session[:ratings]
      if params[:sort_by]
        @sorting = params[:sort_by]
      else 
        @sorting = session[:sort_by]
      end
      flash.keep
      redirect_to movies_path(:sort_by => @sorting, :ratings => @ratings) and return 
    end

    if session[:ratings]
      @checked_ratings = session[:ratings].keys()
      @movies = Movie.with_ratings(@checked_ratings)
    end

    if session[:sort_by] == "title"
      @movies = @movies.order(:title)
      @hilite_title = 'hilite'
    elsif session[:sort_by] == "release_date"
      @movies = @movies.order(:release_date)
      @hilite_release_date ='hilite'
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
