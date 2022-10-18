# frozen_string_literal: true

class MoviesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create update destroy upvote downvote user_movies]
  before_action :set_movie, only: %i[show edit update destroy upvote downvote]
  before_action :set_filter, only: %i[index]

  # GET /movies or /movies.json
  def index
    @movies = Movie.includes(:votes).all.order(@filter)
  end

  def show; end

  def new
    @movie = Movie.new(user_name: current_user.full_name)
  end

  def edit; end

  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to movie_url(@movie), notice: 'Movie was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to movie_url(@movie), notice: 'Movie was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
    end
  end

  def upvote
    @vote = Vote.find_or_initialize_by(movie_id: @movie.id, user_id: params[:user_id])
    @vote.transaction do
      @vote.decrease_movie_hate_count if @vote.hate
      @vote.increase_movie_like_count
      @vote.like = true
      @vote.hate = false
      respond_to do |format|
        if @vote.save
          format.html { redirect_to movies_url }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end
  end

  def downvote
    @vote = Vote.find_or_initialize_by(movie_id: @movie.id, user_id: params[:user_id])
    @vote.transaction do
      @vote.decrease_movie_like_count if @vote.like
      @vote.increase_movie_hate_count
      @vote.like = false
      @vote.hate = true
      respond_to do |format|
        if @vote.save
          format.html { redirect_to movies_url }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end
  end

  def user_movies
    @movies = Movie.includes(:votes).where(user_id: params[:user_id]).order(@filter)
  end

  private

  def set_filter
    @filter = case params[:filter]
              when 'like'
                { like_count: :desc }
              when 'hate'
                { hate_count: :desc }
              else
                { created_at: :desc }
              end
  end

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def movie_params
    params.require(:movie).permit(:title, :description, :user_name, :likes, :hates, :user_id, :user_name)
  end
end
