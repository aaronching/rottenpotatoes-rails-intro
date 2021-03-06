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
    if params[:sort] == "title"
      @movies = Movie.order('title')
      @name_sort = true
      session[:sort] = :title
    elsif params[:sort] == "date"
      @movies = Movie.order('release_date')
      @date_sort = true
      session[:sort] = :date
    else
      @movies = Movie.all
    end
    sort = session[:sort]
    
    if params[:ratings]
      @movies = @movies.where("rating IN (?)", params[:ratings].keys)
      @ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    else
      @ratings = Movie.all_ratings
    end
    ratings = session[:ratings]
    
    if (!params[:sort] and session[:sort]) or (!params[:ratings] and session[:ratings])
      redirect_to movies_path(:sort => sort, :ratings => ratings)
    end
    
    @all_ratings = Movie.all_ratings
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
