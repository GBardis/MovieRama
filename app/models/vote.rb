# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  # Validation
  validates :user_id, uniqueness: { scope: :movie_id }

  def increase_movie_like_count
    movie.increment!(:like_count, 1)
  end

  def decrease_movie_like_count
    movie.decrement!(:like_count, 1)
  end

  def increase_movie_hate_count
    movie.increment!(:hate_count, 1)
  end

  def decrease_movie_hate_count
    movie.decrement!(:hate_count, 1)
  end

  private

  def movie
    Movie.find(movie_id)
  end
end
