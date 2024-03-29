class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
	@movie = Movie.find(id) # look up movie by unique ID
	# will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    params[:ratings] = params[:ratings] || {'G' => 1,'PG' => 1,'PG-13' => 1,'R' => 1}
    #@movies = Movie.find(:all, :order => params[:tosort], 
    #:where => "rating = " + params[:ratings].keys.join(","))
    @movies = Movie.find_by_sql("SELECT * FROM movies WHERE movies.rating='" +
      params[:ratings].keys.join("' OR movies.rating='") + 
      "' ORDER BY movies." + (params[:tosort] || "rating")) 
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
