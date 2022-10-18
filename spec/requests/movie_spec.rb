# frozen_string_literal: true

require 'rails_helper'
require 'pry'

RSpec.describe 'Movies', type: :request do
  fixtures :users, :movies, :votes
  describe 'GET /index' do
    it 'returns movies' do
      get '/movies'
      expect(response).to have_http_status(:success)
      expect(assigns(:movies).length).to eq(Movie.all.length)
    end

    it 'returns movies filter like votes' do
      get '/movies', params: { filter: 'like' }
      expect(response).to have_http_status(:success)
      expect(assigns(:movies)).to match_array(Movie.all.sort_by(&:like_count))
    end

    it 'returns movies filter hate votes' do
      get '/movies', params: { filter: 'hate' }
      expect(response).to have_http_status(:success)
      expect(assigns(:movies)).to match_array(Movie.all.sort_by(&:hate_count))
    end

    it 'returns movies filter date votes' do
      get '/movies', params: { filter: 'date' }
      expect(response).to have_http_status(:success)
      expect(assigns(:movies)).to match_array(Movie.all.sort_by(&:created_at))
    end
  end

  describe 'Movie create' do
    it 'create movie' do
      user = User.first
      sign_in user
      post '/movies',
           params: { movie: { title: 'test', description: 'test movie', user_id: user.id, user_name: user.full_name } }
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(movie_url(assigns(:movie).id))
      expect(assigns(:movie).title).to eq('test')
      expect(assigns(:movie).description).to eq('test movie')
      expect(assigns(:movie).user_id).to eq(user.id)
      expect(assigns(:movie).user_name).to eq(user.full_name)
    end

    it 'create movie no access' do
      get '/movies/new'
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(user_session_path)
    end

    it 'create movie with error' do
      user = User.first
      sign_in user
      post '/movies',
           params: { movie: { description: 'test movie', user_id: user.id, user_name: user.full_name } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(assigns(:movie).errors.messages).to eq({ title: ["can't be blank"] })
    end
  end

  describe 'Movie vote' do
    before(:each) do
      @user = User.first
      @movie = Movie.first
      sign_in @user
    end

    it 'creates like vote' do
      post like_movie_url(@movie.id, user_id: @user.id)
      expect(assigns(:vote).like).to eq(true)
      expect(assigns(:vote).hate).to eq(false)
      expect(Movie.first.like_count).to eq(4)
      expect(Movie.first.hate_count).to eq(0)
    end

    it 'creates hate vote' do
      post hate_movie_url(@movie.id, user_id: @user.id)
      expect(assigns(:vote).like).to eq(false)
      expect(assigns(:vote).hate).to eq(true)
      expect(Movie.first.like_count).to eq(2)
      expect(Movie.first.hate_count).to eq(1)
    end
  end
end
