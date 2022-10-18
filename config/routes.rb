# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  root 'movies#index'
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :movies do
    post '/upvote', to: 'movies#upvote', as: :like, on: :member
    post '/downvote', to: 'movies#downvote', as: :hate, on: :member
    get '/user_movies', to: 'movies#user_movies', on: :collection
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
