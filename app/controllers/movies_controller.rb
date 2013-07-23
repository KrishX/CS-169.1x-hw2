class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params.has_key?(:ratings)
      @ratings = params[:ratings].keys
      @movies = []
      @ratings.each do |r|
        @movies += Movie.find_all_by_rating(r)
        flash[:"#{r}"] = true
      end

    else
      @movies = Movie.all
    end

    @all_ratings = Movie.ratings
    @title_hilite = '' 
    @date_hilite = ''

    if params[:sort] == 'title'
      @movies = @movies.sort { |a, b| a.title <=> b.title }
      @title_hilite = 'hilite' 
    elsif params[:sort] == 'date'
      @movies = @movies.sort { |a, b| a.release_date <=> b.release_date }
      @date_hilite = 'hilite'
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
