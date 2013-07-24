class Movie < ActiveRecord::Base
  scope :sorted_by_title, order("title")
  scope :sorted_by_release_date, order("release_date")

  def self.ratings
    Movie.all(:select => 'DISTINCT rating').map(&:rating)
  end

  def self.fetch_rated_as(ratings = self.ratings)
    where(:rating => ratings)
  end
end
