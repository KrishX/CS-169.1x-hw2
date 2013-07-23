class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # Initialize instance variables to be used by the view 
    @all_ratings = Movie.ratings  # all the ratings categories for the movies
    @movies = []                  # movies that get shown for user
    @selected_ratings = Hash.new { |hash, key| hash[key] = 1 }
                                  # ratings selected by the user
    @hilite = Hash.new { |hash, key| hash[key] = '' }
                                  # name of the sorted column

    # Set ratings
    #
    # if user has selected ratings
    if params.has_key?(:ratings)
      @selected_ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    # if user has not selected any ratings, but has a previous session
    elsif session.has_key?(:ratings)
      # redirect the user into a page with the correct url
      redirect_to movies_path(:sort => session[:sort],
                              :ratings => session[:ratings])
    # user has not selected any ratings, nor has a previous session
    else
      # set @selected_ratings to contain all the ratings
      @all_ratings.each { |r| @selected_ratings[r] }
    end

    # Set sorting of the movies
    #   - fetch the selected movies
    #   - set hilite to contain the id of the table column to be highlighted
    sort = params[:sort]
    if @movies = Movie.fetch_selected_movies(sort, @selected_ratings.keys)
      @hilite.send(:[]=, :"#{sort}", 'hilite')
      session[:sort] = sort
    else
      @movies = []
    end
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
