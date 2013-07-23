class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = []

    # Set the ratings parameters
    @all_ratings = Movie.ratings
    @selected_ratings = Hash.new { |hash, key| hash[key] = 1 }


    # Set the @selected parameter
    if params.has_key?(:ratings)
      @selected_ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session.has_key?(:ratings)
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    else
      @all_ratings.each { |r| @selected_ratings[r] }
    end

    # Use @selected_ratings to filter the selected movies
    @selected_ratings.keys.each do |r|
      @movies += Movie.find_all_by_rating(r)
    end

    # Set the @hilite variable
    @hilite = Hash.new { |hash, key| hash[key] = '' }

    # If sorting is selected
    #   - sort the movies list
    #   - set hilite to contain the id of the element to be highlighted
    sort_by = params[:sort]
    if sort_by == 'title' || sort_by == 'release_date'
      @movies = @movies.sort { |a, b| a.send(sort_by) <=> b.send(sort_by) }
      @hilite.send(:[]=, :"#{sort_by}", 'hilite')
      session[:sort] = sort_by
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
