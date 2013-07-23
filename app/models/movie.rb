class Movie < ActiveRecord::Base
  def self.ratings
    Movie.all(:select => 'DISTINCT rating').map(&:rating)
  end

  private
  def self.fetch_rated_as(ratings = self.ratings)
    find_all_by_rating(ratings)
  end

  public
  def self.fetch_selected_movies(sort = 'title', *ratings)
    ratings = self.ratings if ratings.empty?
    sort = 'title' if sort.blank?

    fetch_rated_as(ratings).sort_by { |movie| movie.send(sort) }
  end
end
