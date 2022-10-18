# frozen_string_literal: true

class Movie < ApplicationRecord
  belongs_to :user
  has_many :votes

  # Validations
  validates :title, presence: true
  validates :user_name, presence: true

  # Scopes

  scope :likes, ->(movie_id) { Vote.where(like: true, movie: movie_id).count }
  scope :hates, ->(movie_id) { Vote.where(hate: true, movie: movie_id).count }

  def day_ago_created
    "#{(DateTime.now - created_at.to_date).to_i} days ago"
  end

  def liked?(user_id)
    return unless user_id

    !!votes.find { |vote| vote.user_id == user_id && vote.like }
  end

  def hated?(user_id)
    return unless user_id

    !!votes.find { |vote| vote.user_id == user_id && vote.hate }
  end
end
