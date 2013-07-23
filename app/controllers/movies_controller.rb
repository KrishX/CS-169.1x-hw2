class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @ratings = Hash.new { |hash, key| hash[key] = 1 }

    if params.has_key?(:ratings)
      @ratings = params[:ratings]
    else
      @all_ratings.each { |r| @ratings[r] }
    end

    @movies = []
    @ratings.keys.each do |r|
      @movies += Movie.find_all_by_rating(r)
    end

    @hilite = Hash.new { |hash, key| hash[key] = '' }
    
    if params[:sort] == 'title'
      @movies = @movies.sort { |a, b| a.title <=> b.title }
      @hilite[:title] = 'hilite'
    elsif params[:sort] == 'release_date'
      @movies = @movies.sort { |a, b| a.release_date <=> b.release_date }
      @hilite[:release_date] = 'hilite' 
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
